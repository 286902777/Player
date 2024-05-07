//
//  HPPlayer.swift
//  HPlayer
//
//  Created by HF on 2024/2/1.
//


import UIKit
import MediaPlayer
import AVFoundation

enum HPPlayerPanDirection: Int {
    case horizontal = 0
    case vertical
}

protocol HPPlayerDelegate: AnyObject {
    func player(player: HPPlayer, playerStateDidChange state: PlayerState)
    func player(player: HPPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval)
    func player(player: HPPlayer, playTimeDidChange currentTime : TimeInterval, totalTime: TimeInterval)
    func player(player: HPPlayer, playerIsPlaying playing: Bool)
    func player(player: HPPlayer, playerOrientChanged isFullscreen: Bool)
    func playerShowCaptionView(_ isfull: Bool)
    func playerShowEpsView()
    func playerNext()
    func playerScreenLock(_ lock: Bool)
    func playerChangeVideoGravity()
    func playerIsPlaying(_ play: Bool)
}


class HPPlayer: UIView {
    let session = AVAudioSession.sharedInstance()

    weak var delegate: HPPlayerDelegate?
    
    var vc: UIViewController?
    
    var panGes: UIPanGestureRecognizer!
    
    var videoGravity = AVLayerVideoGravity.resizeAspect {
        didSet {
            self.playerLayer?.videoGravity = videoGravity
        }
    }
    
    var backBlock:((Bool) -> Void)?
    var exitFullScreen:((Bool) -> Void)?

    open var isPlaying: Bool {
        get {
            return playerLayer?.isPlaying ?? false
        }
    }
    
    var tempIsPlaying: Bool = false
    var isFaceBook: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.controlView.controlShowAnimation(isShowing: !self.controlView.showing)
            }
            if isFaceBook {
                self.controlView.hideLottie()
            }
        }
    }
    
    var playTimeDidChange:((TimeInterval, TimeInterval) -> Void)?

    var playStateDidChange:((Bool) -> Void)?

    var isPlayingStateChanged:((Bool) -> Void)?

    var playStateChanged:((PlayerState) -> Void)?
    
    var avPlayer: AVPlayer? {
        return playerLayer?.player
    }
    
    var playerLayer: PlayerLayerView?
    
    fileprivate var resource: PlayerResource!
    
    fileprivate var IndexDef = 0
    
    fileprivate var controlView: HPPlayerControlView!
    
    fileprivate var customControlView: HPPlayerControlView?
    
    var sourceKey = ""
        
    var isFullScreen: Bool = false
    
    /// 滑动方向
    var panDirection = HPPlayerPanDirection.horizontal
    
    /// 音量
    var voSlider: UISlider!
    var voValue: Float = 0
    
    lazy var lightView: HPPlayerLightView = {
        let view = HPPlayerLightView.view()
        view.isHidden = true
        self.playerLayer?.addSubview(view)
        view.snp.makeConstraints { make in
            make.width.equalTo(204)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        return view
    }()
    
    let animationTimeInterval: Double = 4.0
    let autoFadeOutTimeInterval: Double = 0.5
    
    /// 用来保存时间状态
    fileprivate var sumTime         : TimeInterval = 0
    var totalDuration   : TimeInterval = 0
    var currentPosition : TimeInterval = 0
    fileprivate var shouldSeekTo    : TimeInterval = 0
    
    var panPosition : TimeInterval = 0
    
    var isURLSet        = false
    var isSliding = false
    var isPauseByUser   = false
    var isVolume        = false
    var isMaskShowing   = false
    var isSlowed        = false
    var isMirrored      = false
    
    var isPlayEnd  = false
    //视频画面比例
    var aspectRatio: PlayerAspectRatio = .normal
    
    //Cache is playing result to improve callback performance
    fileprivate var isPlayingCache: Bool? = nil
    
    var subTitleSelectId = ""
    
    // MARK: - Public functions
    
    /**
     Play
     
     - parameter resource:        media resource
     - parameter definitionIndex: starting definition index, default start with the first definition
     */
    open func setVideo(resource: PlayerResource, sourceKey: String, index: Int = 0) {
        isURLSet = false
        self.resource = resource
        self.sourceKey = sourceKey
                
        IndexDef = index
        controlView.prepareUI(for: resource, currentIndex: index)
        controlView.playRate = 1.0
        self.playerLayer?.player?.rate = 1.0
        
        if PlayerManager.share.autoPlay {
            isURLSet = true
            let asset = resource.definitions[index]
            playerLayer?.playAsset(asset: asset.avURLAsset)
        } else {
            controlView.showCover(url: resource.cover)
//            controlView.hideLottie()
        }
    }
    
    /**
     auto start playing, call at viewWillAppear, See more at pause
     */
    open func autoPlay() {
        if !isPauseByUser && isURLSet && !isPlayEnd {
            play()
        }
    }
    
    /**
     Play
     */
    open func play() {
        guard resource != nil else { return }
        
        if !isURLSet {
            let asset = resource.definitions[IndexDef]
            playerLayer?.playAsset(asset: asset.avURLAsset)
            controlView.hideCoverImageView()
            isURLSet = true
        }
        
        panGes.isEnabled = true
        playerLayer?.play()
        playerLayer?.player?.rate = controlView.playRate
        isPauseByUser = false
    }
    
    /**
     Pause
     
     - parameter allow: should allow to response `autoPlay` function
     */
    open func pause(allowAutoPlay allow: Bool = false) {
        playerLayer?.pause()
        isPauseByUser = !allow
    }
    
    /**
     seek
     
     - parameter to: target time
     */
    open func seek(_ to:TimeInterval, completion: (()->Void)? = nil) {
        playerLayer?.seek(to: to, completion: completion)
    }
    
    /**
     update UI to fullScreen
     */
    func reSetUI(_ isFull: Bool) {
        controlView.reSetUI(isFullScreen)
    }
    
    func addVolume(step: Float = 0.1) {
        self.voSlider.value += step
        self.voValue += step
    }
    
    /**
     decreace volume with step, default step 0.1
     
     - parameter step: step
     */
    func reduceVolume(step: Float = 0.1) {
        self.voSlider.value -= step
        self.voValue -= step
    }
    
    /**
     prepare to dealloc player, call at View or Controllers deinit funciton.
     */
    func prepareToDealloc() {
        playerLayer?.distroyPrepare()
        controlView.distroyPrepare()
    }
    
    /**
     If you want to create BMPlayer with custom control in storyboard.
     create a subclass and override this method.
     
     - return: costom control which you want to use
     */
    func storyBoardCustomControl() -> HPPlayerControlView? {
        return nil
    }
    
    // MARK: - Action Response
    
    @objc fileprivate func panDirection(_ pan: UIPanGestureRecognizer) {
        // 根据在view上Pan的位置，确定是调音量还是亮度
        let locationPoint = pan.location(in: self)
        
        // 我们要响应水平移动和垂直移动
        // 根据上次和本次移动的位置，算出一个速率的point
        let velocityPoint = pan.velocity(in: self)
        
        // 判断是垂直移动还是水平移动
        switch pan.state {
        case UIGestureRecognizer.State.began:
            // 使用绝对值来判断移动的方向
            let x = abs(velocityPoint.x)
            let y = abs(velocityPoint.y)
            
            if x > y {
                if PlayerManager.share.enablePlaytimeGestures {
                    self.panDirection = HPPlayerPanDirection.horizontal
                    if let player = playerLayer?.player {
                        let time = player.currentTime()
                        self.sumTime = TimeInterval(time.value) / TimeInterval(time.timescale)
                        self.panPosition = TimeInterval(time.value) / TimeInterval(time.timescale)
                    }
                    self.tempIsPlaying = self.isPlaying
                    self.pause()
                }
            } else {
                self.panDirection = HPPlayerPanDirection.vertical
                if locationPoint.x > self.bounds.size.width / 2 {
                    self.isVolume = true
                } else {
                    self.isVolume = false
                    self.playerLayer?.bringSubviewToFront(self.lightView)
                    self.lightView.isHidden = false
                    self.lightView.imageView.isHighlighted = true
                }
            }
            
        case UIGestureRecognizer.State.changed:
            switch self.panDirection {
            case HPPlayerPanDirection.horizontal:
                self.horizontalMoved(velocityPoint.x)
            case HPPlayerPanDirection.vertical:
                self.verticalMoved(velocityPoint.y)
            }
            
        case UIGestureRecognizer.State.ended:
            switch (self.panDirection) {
            case HPPlayerPanDirection.horizontal:
                controlView.hideSeekToView()
                isSliding = false
                if isPlayEnd {
                    isPlayEnd = false
                    seek(self.sumTime, completion: {[weak self] in
                        self?.play()
                    })
                } else {
                    seek(self.sumTime, completion: {[weak self] in
                        if self?.tempIsPlaying == true {
                            self?.play()
                        } else {
                            self?.autoPlay()
                        }
                    })
                }
                // sumTime会越加越多
                self.panPosition = 0.0
                self.sumTime = 0.0
            case HPPlayerPanDirection.vertical:
                self.isVolume = false
                self.lightView.isHidden = true
            }
        default:
            break
        }
    }
    
    fileprivate func verticalMoved(_ value: CGFloat) {
        if PlayerManager.share.enableVolumeGestures && self.isVolume {
            self.voSlider.value -= Float(value / 10000)
            self.voValue -= Float(value / 10000)
        } else if PlayerManager.share.enableBrightnessGestures && !self.isVolume {
            UIScreen.main.brightness -= value / 5000
            self.lightView.isHidden = false
            self.lightView.progressView.progress = Float(UIScreen.main.brightness)
            self.lightView.layoutIfNeeded()
        }
    }
    
    fileprivate func horizontalMoved(_ value: CGFloat) {
        guard PlayerManager.share.enablePlaytimeGestures else { return }
        
        isSliding = true
        if let playerItem = playerLayer?.playerItem {
            // 每次滑动需要叠加时间，通过一定的比例，使滑动一直处于统一水平
            self.sumTime = self.sumTime + TimeInterval(value) / 100.0 * (TimeInterval(self.totalDuration)/400)
            
            let totalTime = playerItem.duration
            
            // 防止出现NAN
            if totalTime.timescale == 0 { return }
            
            let totalDuration = TimeInterval(totalTime.value) / TimeInterval(totalTime.timescale)
            if (self.sumTime >= totalDuration) { self.sumTime = totalDuration }
            if (self.sumTime <= 0) { self.sumTime = 0 }
            
            controlView.showSeekToView(to: sumTime, total: totalDuration, isAdd: value > 0)
            if isPlayEnd {
                isPlayEnd = false
            }
        }
    }
    
//    @objc open func onOrientationChanged() {
//        self.setUpdateUI(isFullScreen)
//        delegate?.player(player: self, playerOrientChanged: isFullScreen)
//        playOrientChanged?(isFullScreen)
//    }
    
    @objc func fullScreenButtonPressed() {
        self.isFullScreen = !self.isFullScreen
        delegate?.player(player: self, playerOrientChanged: isFullScreen)
        controlView.reSetUI(self.isFullScreen)
        self.exitFullScreen?(self.isFullScreen)
        self.controlView.controlShowAnimation(isShowing: self.isFullScreen)
        if #available(iOS 16.0, *) {
            vc?.setNeedsUpdateOfSupportedInterfaceOrientations()
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return }
            let orientation: UIInterfaceOrientationMask = isFullScreen ?  UIInterfaceOrientationMask.landscapeRight : UIInterfaceOrientationMask.portrait
            let geometryPreferencesIOS = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation)
            windowScene.requestGeometryUpdate(geometryPreferencesIOS) { error in
                print("geometryPreferencesIOS error: \(error)")
            }
        } else {
            if isFullScreen {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            } else {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
    }
    
    @objc fileprivate func airplayButtonPressed() {
        
    }
    
    // MARK: - 生命周期
    deinit {
        playerLayer?.pause()
        playerLayer?.distroyPrepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let customControlView = storyBoardCustomControl() {
            self.customControlView = customControlView
        }
        setUpUI()
        configVolume()
        preparePlayer()
    }
    
    public init(customControlView: HPPlayerControlView?) {
        super.init(frame:CGRect.zero)
        self.customControlView = customControlView
        setUpUI()
        configVolume()
        preparePlayer()
    }
    
    public convenience init() {
        self.init(customControlView: nil)
    }
    
    // MARK: - 初始化
    fileprivate func setUpUI() {
        self.backgroundColor = UIColor.black
        if let customView = customControlView {
            controlView = customView
        } else {
            controlView = HPPlayerControlView()
        }
        addSubview(controlView)
        controlView.delegate = self
        controlView.player   = self
        controlView.reSetUI(isFullScreen)
        controlView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        panGes = UIPanGestureRecognizer(target: self, action: #selector(self.panDirection(_:)))
        panGes.delegate = self
        self.addGestureRecognizer(panGes)
    }
    
    fileprivate func configVolume() {
        let voView = MPVolumeView(frame: CGRect(x: -100, y: -100, width: 40, height: 40))
        vc?.view.addSubview(voView)
        voView.showsVolumeSlider = true
        for view in voView.subviews {
            if let slider = view as? UISlider {
                self.voSlider = slider
            }
        }
    }
    
    fileprivate func preparePlayer() {
        do {
            try session.setCategory(AVAudioSession.Category.playback, options: [.defaultToSpeaker, .allowBluetoothA2DP])
            try session.setActive(true)
        } catch {
            print("error: session \(error.localizedDescription)")
        }
        
        playerLayer = PlayerLayerView()
        playerLayer!.videoGravity = videoGravity
        insertSubview(playerLayer!, at: 0)
        playerLayer!.snp.makeConstraints { make in
          make.edges.equalTo(self)
        }
        playerLayer!.delegate = self
        controlView.showLottie()
        self.layoutIfNeeded()
    }
    
    func showPlayingAd() {
        HPConfig.share.showADS(type: self.isFullScreen ? .other : .play) { [weak self] result in
            DispatchQueue.main.async {
                if result {
                    self?.tempIsPlaying = self?.isPlaying ?? false
                    self?.pause()
                }
            }
        }
        HPADManager.share.tempDismissComplete = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self?.tempIsPlaying == true {
                    self?.play()
                }
            }
            HPADManager.share.tempDismissComplete = nil
        }
    }
}

extension HPPlayer {
    static func secondsToFormat(_ seconds: TimeInterval, duration: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00"
        }
        if duration >= 3600 {
            let sec = Int(seconds.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
            let hour = Int(seconds / 3600)
            let min = Int(seconds.truncatingRemainder(dividingBy: 3600) / 60)
            return String(format: "%02d:%02d:%02d", hour, abs(min), abs(sec))
        } else {
            let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
            let min = Int(seconds / 60)
            return String(format: "%02d:%02d", abs(min), abs(sec))
        }
    }
}

extension HPPlayer: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if PlayerManager.share.isLock {
            return false
        }
        return true
    }
}

// MARK: - PlayerLayerViewDelegate
extension HPPlayer: PlayerLayerViewDelegate {
    func player(player: PlayerLayerView, playerIsPlaying playing: Bool) {
        controlView.playStateDidChange(isPlaying: playing)
        delegate?.player(player: self, playerIsPlaying: playing)
        playStateDidChange?(player.isPlaying)
        isPlayingStateChanged?(player.isPlaying)
    }
    
    func player(player: PlayerLayerView, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        controlView.loadedTimeDidChange(loadedDuration: loadedDuration, totalDuration: totalDuration)
        delegate?.player(player: self, loadedTimeDidChange: loadedDuration, totalDuration: totalDuration)
        controlView.totalDuration = totalDuration
        self.totalDuration = totalDuration
    }
    
    func player(player: PlayerLayerView, playerStateDidChange state: PlayerState) {
        controlView.playerStateDidChange(state: state)
        switch state {
        case .ready:
            if !isPauseByUser {
                play()
            }
            if shouldSeekTo != 0 {
                seek(shouldSeekTo, completion: {[weak self] in
                  guard let self = self else { return }
                  if !self.isPauseByUser {
                      self.play()
                  } else {
                      self.pause()
                  }
                })
                shouldSeekTo = 0
            }
        case .finished:
            autoPlay()
        case .end:
            break
        case .error:
            break
        default:
            break
        }
        panGes.isEnabled = state != .end
        delegate?.player(player: self, playerStateDidChange: state)
        playStateChanged?(state)
    }
    
    func player(player: PlayerLayerView, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        delegate?.player(player: self, playTimeDidChange: currentTime, totalTime: totalTime)
        self.currentPosition = currentTime
        totalDuration = totalTime
        if isSliding {
            return
        }
        controlView.playTimeDidChange(currentTime: currentTime, totalTime: totalTime)
        controlView.totalDuration = totalDuration
        playTimeDidChange?(currentTime, totalTime)
        
        if self.isPlaying, !self.isSliding, Int(currentTime) % HPADManager.share.play_time == 0, Int(currentTime) / HPADManager.share.play_time != 0 {
            self.showPlayingAd()
        }
    }
}

extension HPPlayer: HPPlayerControlViewDelegate {
    func controlView(view: HPPlayerControlView,
                          didChooseDefinition index: Int) {
        shouldSeekTo = currentPosition
        playerLayer?.resetPlayer()
        IndexDef = index
        playerLayer?.playAsset(asset: resource.definitions[index].avURLAsset)
    }
    
    func controlView(view: HPPlayerControlView,
                          didPressButton button: UIButton) {
        if let action = HPButtonType(rawValue: button.tag) {
            switch action {
            case .back:
                backBlock?(isFullScreen)
            case .play:
                if button.isSelected {
                    pause()
                    self.delegate?.playerIsPlaying(false)
                } else {
                    if isPlayEnd {
                        seek(0, completion: {[weak self] in
                          self?.play()
                        })
                        isPlayEnd = false
                    }
                    self.delegate?.playerIsPlaying(true)
                    play()
                }
            case .replay:
                isPlayEnd = false
                seek(0)
                self.delegate?.playerIsPlaying(true)
                play()
            case .fullscreen:
                fullScreenButtonPressed()
            case.airplay:
                airplayButtonPressed()
            case .rate:
                controlView.controlShowAnimation(isShowing: false)
            case .backword:
                controlView.backwordAction()
                self.showSeekViewWithTime(false)
            case .forword:
                controlView.forword()
                self.showSeekViewWithTime(true)
            case .list:
                break
            case .cc:
                self.controlView.controlShowAnimation(isShowing: false)
                self.delegate?.playerShowCaptionView(isFullScreen)
            case .eps:
                self.delegate?.playerShowEpsView()
            case .next:
                self.delegate?.playerNext()
            case .lock:
                self.delegate?.playerScreenLock(controlView.lockButton.isSelected)
            case .size:
                button.isSelected = !button.isSelected
                self.videoGravity = button.isSelected ? .resizeAspectFill : .resizeAspect
                UserDefaults.standard.set(button.isSelected, forKey: "videoGravity")
                UserDefaults.standard.synchronize()
                self.delegate?.playerChangeVideoGravity()
            default:
                print("Error Action")
                break
            }
        }
    }
    
    func showSeekViewWithTime(_ forword: Bool = false) {
        if let playerItem = playerLayer?.playerItem, let player = playerLayer?.player{
            let time = player.currentTime()
            var sumTime: TimeInterval = TimeInterval(time.value) / TimeInterval(time.timescale)
            let totalTime = playerItem.duration
            
            // 防止出现NAN
            if totalTime.timescale == 0 { return }
            
            let totalDuration = TimeInterval(totalTime.value) / TimeInterval(totalTime.timescale)
            if (sumTime >= totalDuration) { sumTime = totalDuration }
            if (sumTime <= 0) { sumTime = 0 }
            controlView.setForOrBackSeekToView(forword, to: sumTime, total: totalDuration, isAdd: forword)
        }
    }
    
    func controlView(view: HPPlayerControlView,
                          slider: UISlider,
                          onSliderEvent event: UIControl.Event) {
        switch event {
        case .touchDown:
            playerLayer?.setSliderTimeBegan()
            isSliding = true
        case .touchUpInside :
            isSliding = false
            let target = self.totalDuration * Double(slider.value)
//            controlView.showSeekToView(to: sumTime, total: totalDuration, isAdd: sumTime > 0)
            if isPlayEnd {
                isPlayEnd = false
                seek(target, completion: {[weak self] in
                  self?.play()
                })
            } else {
                seek(target, completion: {[weak self] in
                    if self?.tempIsPlaying == true {
                        self?.play()
                    } else {
                        self?.autoPlay()
                    }
                })
            }
        default:
            break
        }
    }
    
    func controlView(view: HPPlayerControlView, didChangeVideoAspectRatio: PlayerAspectRatio) {
        self.playerLayer?.aspectRatio = self.aspectRatio
    }
    
    func controlView(view: HPPlayerControlView, didChangeVideoPlaybackRate rate: Float) {
        if self.isPlaying {
            self.playerLayer?.player?.rate = rate
        } else {
            self.controlView.playRate = rate
        }
    }
}
