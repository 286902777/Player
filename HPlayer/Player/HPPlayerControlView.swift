//
//  HPPlayerControlView.swift
//  HPlayer
//
//  Created by HF on 2024/2/11.
//


import UIKit

enum HPButtonType: Int {
    case play       = 101
    case pause
    case back
    case fullscreen
    case replay
    case forword
    case airplay
    case rate
    case list
    case backword
    case lock
    case cc
    case next
    case eps
    case size
}

protocol HPPlayerControlViewDelegate: AnyObject {
    /**
     call when control view choose a definition
     
     - parameter controlView: control view
     - parameter index:       index of definition
     */
    func controlView(view: HPPlayerControlView, didChooseDefinition index: Int)
    
    /**
     call when control view pressed an button
     
     - parameter controlView: control view
     - parameter button:      button type
     */
    func controlView(view: HPPlayerControlView, didPressButton button: UIButton)
    
    /**
     call when slider action trigged
     
     - parameter controlView: control view
     - parameter slider:      progress slider
     - parameter event:       action
     */
    func controlView(view: HPPlayerControlView, slider: UISlider, onSliderEvent event: UIControl.Event)
    
    /**
     call when needs to change playback rate
     
     - parameter controlView: control view
     - parameter rate:        playback rate
     */
    func controlView(view: HPPlayerControlView, didChangeVideoPlaybackRate rate: Float)
}

class HPPlayerControlView: UIView {
    weak var delegate: HPPlayerControlViewDelegate?
    weak var player: HPPlayer?
    
    // MARK: Variables
    var resource: PlayerResource?
    
    var currentIndex = 0
    var isFullscreen = false {
        didSet {
            if isFullscreen, isMovie == false {
                self.epsButton.isHidden = false
                self.nexHPutton.isHidden = false
            } else {
                self.epsButton.isHidden = true
                self.nexHPutton.isHidden = true
            }
            self.sizeButton.isHidden = !isFullscreen
        }
    }
    var showing = true
    var isMovie = false
    var playRate: Float = 1.0
    var isReadyToPlayed = false
    
    var totalDuration: TimeInterval = 0
    var delayItem: DispatchWorkItem?
    
    var playerState: PlayerState = .noURL
    
    let leading: CGFloat = 48
    let marge: CGFloat = 8
    let space: CGFloat = 72

    fileprivate var isSelectDefinition = false
    
    // MARK: UI Components
    /// main views which contains the topView and bottom  view
    var baseView   = UIView()
    var topView    = UIView()
    var bottomView = UIView()
    var centerContentView = UIView()
    var leftShowView   = UIView()
    var rightShowView = UIView()
    
    /// Image view to show video cover
    var ImageView = UIImageView()
    
    /// top views
    var topWrapperView = UIView()
    var backButton = UIButton(type : .custom)
    //    var rate1Button = UIButton(type : .custom)
    var ccButton = UIButton(type : .custom)
    var epsButton = UIButton(type : .custom)
    var titleL = UILabel()
    var defChooseView = UIView()
    
    /// bottom view
    var bottomWrapperView = UIView()
    var currentTimeL = UILabel()
    //    var centerTimeLabel = UILabel()
    var totalTimeL   = UILabel()
    
    /// Progress slider
    var timeSlider = HPTimeSlider()
    
    /// load progress view
    var progressView = UIProgressView()
    
    /* play button
     playButton.isSelected = player.isPlaying
     */
    var playButton = UIButton(type: .custom)
    //    var forwBtn = UIButton(type: .custom)
    //    var backwBtn = UIButton(type: .custom)
    
    
    var centerWrapperView = UIView()
    var playMiddleBtn = UIButton(type: .custom)
    var forwBtn = UIButton(type: .custom)
    var backwBtn = UIButton(type: .custom)
    
    var lockButton = UIButton(type: .custom)
    /* fullScreen button
     fullButton.isSelected = player.isFullscreen
     */
    var nexHPutton = UIButton(type: .custom)
    var fullButton = UIButton(type: .custom)
    var sizeButton = UIButton(type: .custom)
    
    var captionL    = UILabel()
    var captionBgView = UIView()
    var subtileAttr: [NSAttributedString.Key : Any]?
    
    /// Activty Indector for loading
    
    lazy var loadingView: HPPlayerLoadingView = {
        let view = HPPlayerLoadingView.view()
        return view
    }()
    
    var seekToView       = UIView()
    var seekEffView    = UIView()
    var seekToViewImage  = UIImageView()
    var seekToL      = UILabel()
    var offsetToL    = UILabel()
    
    //    var replayButton     = UIButton(type: .custom)
    
    /// Gesture used to show / hide control view
    var tapGR: UITapGestureRecognizer!
    var doubleGR: UITapGestureRecognizer!
    var leftGR: UITapGestureRecognizer!
    var rightGR: UITapGestureRecognizer!
    
    
    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setMakeConstrain()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
        setMakeConstrain()
    }
    
    func configUI() {
        let graph = NSMutableParagraphStyle()
        graph.alignment = .center
        graph.lineHeightMultiple = 1.0
//        NSAttributedString.Key.strokeColor: UIColor.hexColor("#141414"), NSAttributedString.Key.strokeWidth: -2,
        self.subtileAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white,  NSAttributedString.Key.paragraphStyle: graph]
        // Subtile view
        captionL.numberOfLines = 0
        captionL.textAlignment = .center
        captionBgView.backgroundColor = UIColor.hexColor("#141414", alpha: 0.2)
        captionBgView.layer.cornerRadius = 2
        captionBgView.layer.masksToBounds = true
        captionBgView.addSubview(captionL)
        captionBgView.isHidden = true
        
        addSubview(captionBgView)
        
        // baseView
        addSubview(baseView)
        baseView.addSubview(leftShowView)
        baseView.addSubview(rightShowView)
        baseView.addSubview(topView)
        baseView.addSubview(bottomView)
        baseView.addSubview(centerContentView)
        baseView.insertSubview(ImageView, at: 0)
        baseView.clipsToBounds = true
        baseView.backgroundColor = UIColor(white: 0, alpha: 0.4 )
        baseView.bringSubviewToFront(topView)
        
        leftShowView.backgroundColor   = UIColor.clear
        rightShowView.backgroundColor  = UIColor.clear
        
        // Top views
        topView.addSubview(topWrapperView)
        topWrapperView.addSubview(backButton)
        //        topWrapperView.addSubview(rate1Button)
        
        topWrapperView.addSubview(titleL)
        topWrapperView.addSubview(defChooseView)
        
        backButton.tag = HPButtonType.back.rawValue
        backButton.contentHorizontalAlignment = .left
        backButton.setImage(UIImage(named: "nav_back"), for: .normal)
        backButton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
        ccButton.tag = HPButtonType.cc.rawValue
        ccButton.setImage(UIImage(named: "icon_cc"), for: .normal)
        ccButton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
        epsButton.tag = HPButtonType.eps.rawValue
        epsButton.setImage(UIImage(named: "play_eps"), for: .normal)
        epsButton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
        titleL.textColor = UIColor.white
        titleL.font      = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        defChooseView.clipsToBounds = true
        
        // Bottom views
        bottomView.addSubview(bottomWrapperView)
        bottomWrapperView.addSubview(playButton)
        bottomWrapperView.addSubview(currentTimeL)
        bottomWrapperView.addSubview(totalTimeL)
        bottomWrapperView.addSubview(progressView)
        bottomWrapperView.addSubview(timeSlider)
        bottomWrapperView.addSubview(nexHPutton)
        bottomWrapperView.addSubview(epsButton)
        bottomWrapperView.addSubview(fullButton)
        bottomWrapperView.addSubview(sizeButton)

        playButton.tag = HPButtonType.play.rawValue
        playButton.setImage(UIImage(named: "play_pause"),  for: .normal)
        playButton.setImage(UIImage(named: "play_play"), for: .selected)
        playButton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
        currentTimeL.textColor  = UIColor.white
        currentTimeL.font       = UIFont.systemFont(ofSize: 10, weight: .medium)
        currentTimeL.text       = "00:00"
        currentTimeL.textAlignment = NSTextAlignment.center
        
        totalTimeL.textColor    = UIColor.white
        totalTimeL.font         = UIFont.systemFont(ofSize: 10, weight: .medium)
        totalTimeL.text         = "00:00"
        totalTimeL.textAlignment   = NSTextAlignment.center
        
        currentTimeL.setContentHuggingPriority(.required, for: .horizontal)
        totalTimeL.setContentHuggingPriority(.required, for: .horizontal)
        timeSlider.maximumValue = 1.0
        timeSlider.minimumValue = 0.0
        timeSlider.value        = 0.0
        timeSlider.setThumbImage(UIImage(named: "play_slider"), for: .normal)
        timeSlider.maximumTrackTintColor = UIColor.hexColor("#FFFFFF", alpha: 0.5)
        timeSlider.minimumTrackTintColor = UIColor.hexColor("#7061FF")
                
        timeSlider.addTarget(self, action: #selector(beginProgressValue(_:)),
                             for: .touchDown)
        
        timeSlider.addTarget(self, action: #selector(changeProgressValue(_:)),
                             for: .valueChanged)
        
        timeSlider.addTarget(self, action: #selector(endProgressValue(_:)),
                             for: [.touchUpInside, .touchCancel, .touchUpOutside])
        
        progressView.tintColor = UIColor.hexColor("#7061FF", alpha: 0.4)
        
        baseView.addSubview(lockButton)
        
        nexHPutton.tag = HPButtonType.next.rawValue
        nexHPutton.setImage(UIImage(named: "play_next"), for: .normal)
        nexHPutton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
        lockButton.tag = HPButtonType.lock.rawValue
        lockButton.contentHorizontalAlignment = .left
        lockButton.setImage(UIImage(named: "play_unlock"), for: .normal)
        lockButton.setImage(UIImage(named: "play_lock"), for: .selected)
        lockButton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        lockButton.isHidden = true
        
        fullButton.tag = HPButtonType.fullscreen.rawValue
        fullButton.setImage(UIImage(named: "play_full"), for: .normal)
        fullButton.setImage(UIImage(named: "play_offscreen"), for: .selected)
        fullButton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
        sizeButton.tag = HPButtonType.size.rawValue
        sizeButton.setImage(UIImage(named: "play_maxSize"), for: .normal)
        sizeButton.setImage(UIImage(named: "play_mixSize"), for: .selected)
        sizeButton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
        centerContentView.addSubview(centerWrapperView)
        centerWrapperView.addSubview(playMiddleBtn)
        centerWrapperView.addSubview(backwBtn)
        centerWrapperView.addSubview(forwBtn)
        
        playMiddleBtn.tag = HPButtonType.play.rawValue
        playMiddleBtn.setImage(UIImage(named: "mid_pause"),  for: .normal)
        playMiddleBtn.setImage(UIImage(named: "mid_play"), for: .selected)
        playMiddleBtn.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
        forwBtn.tag = HPButtonType.forword.rawValue
        forwBtn.setImage(UIImage(named: "fast_forward"),  for: .normal)
        forwBtn.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
        backwBtn.tag = HPButtonType.backword.rawValue
        backwBtn.setImage(UIImage(named: "fast_backward"),  for: .normal)
        backwBtn.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)

        addSubview(seekToView)

        seekToView.addSubview(seekEffView)
        seekToView.addSubview(seekToL)
        seekToView.addSubview(offsetToL)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = CGSize(width: 134, height: 72)
        seekEffView.addSubview(blurView)
        
        seekToL.font                  = UIFont.systemFont(ofSize: 18)
        seekToL.textColor             = .white
        seekToL.textAlignment         = .center
        offsetToL.font                = UIFont.systemFont(ofSize: 12)
        offsetToL.textColor           = .white
        offsetToL.textAlignment       = .center
        seekToView.backgroundColor        = UIColor(white: 1, alpha: 0.08)
        seekToView.layer.cornerRadius     = 2
        seekToView.layer.masksToBounds    = true
        seekToView.isHidden               = true
        seekEffView.layer.cornerRadius  = 2
        seekEffView.layer.masksToBounds = true
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tapGR)
        
        if PlayerManager.share.enablePlayControlGestures {
            doubleGR = UITapGestureRecognizer(target: self, action: #selector(doubleAction(_:)))
            doubleGR.numberOfTapsRequired = 2
            addGestureRecognizer(doubleGR)
            tapGR.require(toFail: doubleGR)
        }
        
        leftGR = UITapGestureRecognizer(target: self, action: #selector(leftTapAction(_:)))
        leftGR.numberOfTapsRequired = 2
        leftShowView.addGestureRecognizer(leftGR)
        
        tapGR.require(toFail: leftGR)
        
        rightGR = UITapGestureRecognizer(target: self, action: #selector(rightTapAction(_:)))
        rightGR.numberOfTapsRequired = 2
        rightShowView.addGestureRecognizer(rightGR)

        tapGR.require(toFail: rightGR)
        doubleGR.delegate = self
        leftGR.delegate = self
        rightGR.delegate = self
    }
    
    func setMakeConstrain() {
        // Main  view
        baseView.snp.makeConstraints {  make in
            make.edges.equalTo(self)
        }
        
        leftShowView.snp.makeConstraints {  make in
            make.top.leading.bottom.equalTo(self.baseView)
            make.width.equalTo(kScreenWidth * 0.45)
        }
        
        rightShowView.snp.makeConstraints {  make in
            make.top.trailing.bottom.equalTo(self.baseView)
            make.width.equalTo(kScreenWidth * 0.45)
        }
        
        ImageView.snp.makeConstraints {  make in
            make.edges.equalTo(self.baseView)
        }
        
        topView.snp.makeConstraints {  make in
            make.top.leading.trailing.equalTo(self.baseView)
        }
        
        topWrapperView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {  make in
            make.bottom.leading.trailing.equalTo(self.baseView)
        }
        
        bottomWrapperView.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        centerContentView.snp.makeConstraints {  make in
            make.bottom.leading.trailing.equalTo(self.baseView)
        }
        
        centerWrapperView.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.top.leading.trailing.equalToSuperview()
        }
        
        // Top views
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().offset(18)
            make.bottom.equalToSuperview()
        }
        
        lockButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(backButton)
            make.width.height.equalTo(40)
        }
        titleL.snp.makeConstraints {  make in
            make.leading.equalTo(self.backButton.snp.trailing)
            make.trailing.equalToSuperview().offset(-130)
            make.centerY.equalTo(self.backButton)
        }
        
        defChooseView.snp.makeConstraints {  make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.titleL.snp.top).offset(-4)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        playButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalTo(marge)
            make.bottom.equalToSuperview().offset(-marge)
        }

        currentTimeL.snp.makeConstraints {  make in
            make.centerY.equalTo(self.playButton)
            make.left.equalTo(self.playButton.snp.right).offset(marge)
            make.height.equalTo(17)
        }
        
        totalTimeL.snp.makeConstraints {  make in
            make.centerY.equalTo(self.playButton)
            make.right.equalTo(self.fullButton.snp.left).offset(-marge)
        }
        
        progressView.snp.makeConstraints {  make in
            make.leading.trailing.equalTo(self.timeSlider)
            make.centerY.equalTo(self.timeSlider)
            make.height.equalTo(4)
        }
        
        fullButton.snp.makeConstraints {  make in
            make.width.height.equalTo(40)
            make.bottom.right.equalToSuperview().offset(-marge)
        }
    
        playMiddleBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.center.equalToSuperview()
        }
        
        backwBtn.snp.makeConstraints {  make in
            make.width.height.equalTo(48)
            make.trailing.equalTo(playMiddleBtn.snp.leading).offset(-48)
            make.centerY.equalToSuperview()
        }
        
        forwBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.leading.equalTo(playMiddleBtn.snp.trailing).offset(48)
            make.centerY.equalToSuperview()
        }

        baseView.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(80)
        }

        seekToView.snp.makeConstraints {  make in
            make.center.equalTo(self)
            make.width.equalTo(134)
            make.height.equalTo(72)
        }
        
        seekEffView.snp.makeConstraints {  make in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(134)
            make.height.equalTo(72)
        }
        
        seekToL.snp.makeConstraints {  make in
            make.centerX.equalTo(self.seekToView)
            make.top.equalTo(self.seekToView).offset(11)
            make.height.equalTo(25)
        }
        
        offsetToL.snp.makeConstraints {  make in
            make.centerX.equalTo(self.seekToView)
            make.top.equalTo(self.seekToL.snp.bottom).offset(marge)
            make.height.equalTo(17)
        }
        
        captionBgView.snp.makeConstraints {  make in
            make.bottom.equalTo(self.snp.bottom).offset(-16)
            make.centerX.equalTo(self.snp.centerX)
            make.width.lessThanOrEqualTo(self.snp.width).offset(-20).priority(750)
        }
        
        captionL.snp.makeConstraints {  make in
            make.leading.equalTo(self.captionBgView.snp.leading).offset(10)
            make.trailing.equalTo(self.captionBgView.snp.trailing).offset(-10)
            make.top.equalTo(self.captionBgView.snp.top).offset(2)
            make.bottom.equalTo(self.captionBgView.snp.bottom).offset(-2)
        }
    }
    
    func reSetUI(_ isFull: Bool) {
        isFullscreen = isFull
        fullButton.isSelected = isFull
        titleL.isHidden = !isFull
        defChooseView.isHidden = !PlayerManager.share.enableChooseDefinition || !isFull
        if isFull {
            if PlayerManager.share.topBarInCase.rawValue == 2 {
                topView.isHidden = true
            } else {
                topView.isHidden = false
            }
        } else {
            if PlayerManager.share.topBarInCase.rawValue >= 1 {
                topView.isHidden = true
            } else {
                topView.isHidden = false
            }
        }
        if isFullscreen, self.showing {
            self.lockButton.isHidden = false
        } else {
            self.lockButton.isHidden = true
        }
        self.sizeButton.isSelected = self.player?.playerLayer?.videoGravity == .resizeAspectFill
        leftShowView.snp.remakeConstraints {  make in
            make.top.bottom.equalTo(self.baseView)
            make.left.equalTo(self.space)
            make.width.equalTo(isFullscreen ? ((kScreenHeight - 144) * 0.45) : (kScreenWidth * 0.45))
        }
        
        rightShowView.snp.remakeConstraints {  make in
            make.top.trailing.bottom.equalTo(self.baseView)
            make.trailing.equalTo(-self.space)
            make.width.equalTo(isFullscreen ? ((kScreenHeight - 144) * 0.45) : (kScreenWidth * 0.45))
        }
        
        backButton.snp.remakeConstraints { (make) in
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(isFullscreen ? leading : 18)
            make.bottom.equalToSuperview()
        }
  
        playButton.isHidden = isFullscreen
        backwBtn.isHidden = false
        playMiddleBtn.isHidden = false
        forwBtn.isHidden = false
        if isFullscreen {
            playMiddleBtn.snp.remakeConstraints { (make) in
                make.width.height.equalTo(48)
                make.center.equalToSuperview()
            }
            
            backwBtn.snp.remakeConstraints {  make in
                make.width.height.equalTo(48)
                make.trailing.equalTo(playMiddleBtn.snp.leading).offset(-48)
                make.centerY.equalToSuperview()
            }
            
            forwBtn.snp.remakeConstraints { (make) in
                make.width.height.equalTo(48)
                make.leading.equalTo(playMiddleBtn.snp.trailing).offset(48)
                make.centerY.equalToSuperview()
            }
        } else {
            forwBtn.isHidden = true
            backwBtn.isHidden = true
            playMiddleBtn.isHidden = true
        }
        
        currentTimeL.snp.remakeConstraints {  make in
            if isFullscreen {
                make.bottom.equalTo(timeSlider.snp.top).offset(4)
                make.left.equalToSuperview().offset(leading)
            } else {
                make.centerY.equalTo(playButton)
                make.left.equalTo(playButton.snp.right)
            }
            make.height.equalTo(17)
        }
        
        totalTimeL.snp.remakeConstraints {  make in
            make.centerY.equalTo(self.currentTimeL)
            if isFullscreen {
                make.right.equalToSuperview().offset(-leading)
            } else {
                make.right.equalTo(fullButton.snp.left).offset(-marge)
            }
        }
        
        timeSlider.snp.remakeConstraints {  make in
            if isFullscreen {
                make.bottom.equalTo(fullButton.snp.top)
                make.leading.equalTo(currentTimeL.snp.leading)
                make.trailing.equalTo(totalTimeL.snp.trailing)
            } else {
                make.centerY.equalTo(playButton)
                make.leading.equalTo(currentTimeL.snp.trailing).offset(marge)
                make.trailing.equalTo(totalTimeL.snp.leading).offset(-marge)
            }
            make.height.equalTo(30)
        }
        
        progressView.snp.remakeConstraints {  make in
            make.leading.trailing.equalTo(self.timeSlider)
            make.centerY.equalTo(self.timeSlider)
            make.height.equalTo(4)
        }
        
        nexHPutton.snp.remakeConstraints { make in
            make.width.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(leading)
        }
        
        fullButton.snp.remakeConstraints {  make in
            make.width.height.equalTo(40)
            if isFullscreen {
                make.bottom.equalToSuperview().offset(-16)
                make.trailing.equalToSuperview().offset(-leading + marge)
            } else {
                make.centerY.equalTo(playButton)
                make.right.equalToSuperview().offset(-marge)
            }
        }
        
        ccButton.removeFromSuperview()
        topWrapperView.addSubview(ccButton)
        
        ccButton.snp.remakeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(self.backButton)
            if isFullscreen {
                make.trailing.equalTo(-leading + marge)
            } else {
                make.trailing.equalTo(-marge)
            }
        }
        
        epsButton.snp.remakeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(fullButton)
            make.right.equalTo(fullButton.snp.left).offset(-marge)
        }

        sizeButton.snp.remakeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(fullButton)
            if self.isMovie {
                make.right.equalTo(fullButton.snp.left).offset(-marge)
            } else {
                make.right.equalTo(epsButton.snp.left).offset(-marge)
            }
        }
        
        self.topView.snp.remakeConstraints {
            $0.top.equalTo(self.baseView.snp.top).offset(self.showing ? 0 : (isFullscreen ? -58 : -44))
            $0.left.right.equalTo(self.baseView)
            $0.height.equalTo(isFullscreen ? 58 : 44)
        }
        self.bottomView.snp.remakeConstraints {
            $0.bottom.equalTo(self.baseView.snp.bottom).offset(self.showing ? 0 :  (isFullscreen ? 120 : 50))
            //            $0.bottom.equalTo(self.baseView.snp.bottom)
            $0.left.right.equalTo(self.baseView)
            $0.height.equalTo(isFullscreen ? 120 : 50)
        }
        
        self.centerContentView.snp.remakeConstraints {
            $0.center.equalTo(self.baseView)
            $0.width.equalTo(220)
            $0.height.equalTo(56)
        }
                
        let graph = NSMutableParagraphStyle()
        graph.alignment = .center
        graph.lineHeightMultiple = 1.0
//        NSAttributedString.Key.strokeColor: UIColor.hexColor("#141414"), NSAttributedString.Key.strokeWidth: -2,
        self.subtileAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: isFullscreen ? 16 : 12, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: graph]
        
        captionBgView.snp.remakeConstraints {  make in
            make.bottom.equalTo(self.snp.bottom).offset(isFullscreen ? -24 : -16)
            make.centerX.equalTo(self.snp.centerX)
            make.width.lessThanOrEqualTo(self.snp.width).offset(isFullscreen ? -57 : -20).priority(750)
        }
        self.layoutIfNeeded()
        if let p = self.player {
            p.layoutIfNeeded()
        }
    }
    // MARK: - handle player state change
    
    func playTimeDidChange(currentTime: TimeInterval, totalTime: TimeInterval) {
        currentTimeL.text = HPPlayer.secondsToFormat(currentTime, duration: totalTime)
        totalTimeL.text   = HPPlayer.secondsToFormat(totalTime, duration: totalTime)
        timeSlider.value      = Float(currentTime) / Float(totalTime)
        showCaption(from: resource?.subtitle, at: currentTime)
    }
    
    
    /**
     change subtitle resource
     
     - Parameter subtitles: new subtitle object
     */
    func update(subtitles: HPSubtitles?) {
        resource?.subtitle = subtitles
        self.ccButton.isHidden = subtitles == nil
    }
    
    /**
     call on load duration changed, update load progressView here
     
     - parameter loadedDuration: loaded duration
     - parameter totalDuration:  total duration
     */
    func loadedTimeDidChange(loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        progressView.setProgress(Float(loadedDuration)/Float(totalDuration), animated: true)
    }
    
    func playerStateDidChange(state: PlayerState) {
        switch state {
        case .ready:
            self.isReadyToPlayed = true
            break
        case .waiting:
            self.isReadyToPlayed = false
            showLottie()
        case .finished:
//            if let p = self.player, p.tempIsPlaying, HPConfig.currentVC()?.isKind(of: VideoPlayViewController.self) == true {
//                self.player?.play()
//            }
            if isReadyToPlayed {
                hideLottie()
            }
            break
        case .end:
            playButton.isSelected = false
            playMiddleBtn.isSelected = false
            lockButton.isSelected = false
            controlShowAnimation(isShowing: true)
        default:
            break
        }
        playerState = state
    }
    
    /**
     Call when User use the slide to seek function
     
     - parameter toSecound:     target time
     - parameter totalDuration: total duration of the video
     - parameter isAdd:         isAdd
     */
    func showSeekToView(to toSecound: TimeInterval, total totalDuration:TimeInterval, isAdd: Bool) {
        seekToView.isHidden = false
        seekToL.text = HPPlayer.secondsToFormat(self.player?.panPosition ?? 0, duration: totalDuration)
        
        if let _ = self.player?.currentPosition {
            let offset = toSecound - (self.player?.panPosition ?? 0)
            offsetToL.text  = "\(offset > 0 ? "+ " : "- ")\(HPPlayer.secondsToFormat(offset, duration: totalDuration))"
        }
                
        let targetTime = HPPlayer.secondsToFormat(toSecound, duration: totalDuration)
        timeSlider.value = Float(toSecound / totalDuration)
        currentTimeL.text = targetTime
    }
    
    func setForOrBackSeekToView(_ forword: Bool = false, to toSecound: TimeInterval, total totalDuration:TimeInterval, isAdd: Bool) {
        seekToView.isHidden = false
        seekToL.text = HPPlayer.secondsToFormat(toSecound, duration: totalDuration)
        
        if let _ = self.player?.currentPosition {
            let offset: TimeInterval = forword ? 15 : -15
            offsetToL.text  = "\(offset > 0 ? "+ " : "- ")\(HPPlayer.secondsToFormat(offset, duration: totalDuration))"
        }
                
        let targetTime = HPPlayer.secondsToFormat(toSecound, duration: totalDuration)
        timeSlider.value = Float(toSecound / totalDuration)
        currentTimeL.text = targetTime
        if seekToView.isHidden == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                self.seekToView.isHidden = true
            }
        }
    }
    
    // MARK: - UI update related function
    /**
     Update UI details when player set with the resource
     
     - parameter resource: video resouce
     - parameter index:    defualt definition's index
     */
    func prepareUI(for resource: PlayerResource, currentIndex index: Int) {
        self.resource = resource
        self.currentIndex = index
        titleL.text = resource.name
        upDatedefChooseViewUI()
        dismissControlAnimation()
    }
    
    func playStateDidChange(isPlaying: Bool) {
        dismissControlAnimation()
        playButton.isSelected = isPlaying
        playMiddleBtn.isSelected = isPlaying
    }
    
    /**
     auto fade out controll view with animtion
     */
    func dismissControlAnimation() {
        cancelAnimation()
        delayItem = DispatchWorkItem { [weak self] in
            if self?.playerState != .end {
                self?.controlShowAnimation(isShowing: false)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + PlayerManager.share.animateDelayInterval,
                                      execute: delayItem!)
    }
    
    /**
     cancel auto fade out controll view with animtion
     */
    func cancelAnimation() {
        delayItem?.cancel()
    }
    
    func controlShowAnimation(isShowing: Bool) {
        self.showing = isShowing
        
        UIView.animate(withDuration: 0.24, animations: {
            self.topView.snp.remakeConstraints {
                $0.top.equalTo(self.baseView).offset(isShowing ? 0 : (self.isFullscreen ? -58 : -44))
                $0.left.right.equalTo(self.baseView)
                $0.height.equalTo(self.isFullscreen ? 58 : 44)
            }
            
            self.bottomView.snp.remakeConstraints {
                $0.bottom.equalTo(self.baseView).offset(isShowing ? 0 : (self.isFullscreen ? 200 : 50))
                $0.left.right.equalTo(self.baseView)
                $0.height.equalTo(self.isFullscreen ? 200 : 50)
            }
           
            self.centerContentView.snp.remakeConstraints {
                $0.center.equalToSuperview()
                $0.height.equalTo(56)
                $0.width.equalTo(220)
            }

            if isShowing, self.player?.isFaceBook == false {
                self.centerContentView.alpha = 1.0
                if self.isFullscreen {
                    self.lockButton.isHidden = false
                }
            } else {
                self.centerContentView.alpha = 0
                self.lockButton.isHidden = true
            }
            self.baseView.backgroundColor = UIColor(white: 0, alpha: isShowing ? (self.isFullscreen ? 0.65 : 0.16) : 0)
            self.layoutIfNeeded()
        }) { (_) in
            self.dismissControlAnimation()
        }
    }
    
    func showCoverWithLink(_ cover:String) {
        self.showCover(url: URL(string: cover))
    }
    
    func showCover(url: URL?) {
        if let url = url {
            DispatchQueue.global(qos: .default).async { [weak self] in
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async(execute: { [weak self] in
                    guard let self = self else { return }
                    if let data = data {
                        self.ImageView.image = UIImage(data: data)
                    } else {
                        self.ImageView.image = nil
                    }
                    //                    self.hideLottie()
                });
            }
        }
    }
    
    func hideCoverImageView() {
        self.ImageView.isHidden = true
    }
    
    func upDatedefChooseViewUI() {
        guard let resource = resource else {
            return
        }
        for item in defChooseView.subviews {
            item.removeFromSuperview()
        }
        
        for i in 0..<resource.definitions.count {
            //            let button = BMPlayerClearityChooseButton()
            let button = UIButton()
            if i == 0 {
                button.tag = currentIndex
            } else if i <= currentIndex {
                button.tag = i - 1
            } else {
                button.tag = i
            }
            
            button.setTitle("\(resource.definitions[button.tag].definition)", for: UIControl.State())
            defChooseView.addSubview(button)
            button.addTarget(self, action: #selector(self.clickDefinitionAction(_:)), for: UIControl.Event.touchUpInside)
            button.snp.makeConstraints({ (make) in
                //                guard let `self` = self else { return }
                make.top.equalTo(defChooseView.snp.top).offset(35 * i)
                make.width.equalTo(50)
                make.height.equalTo(25)
                make.centerX.equalTo(defChooseView)
            })
            
            if resource.definitions.count == 1 {
                button.isEnabled = false
                button.isHidden = true
            }
        }
    }
    
    func distroyPrepare() {
        self.delayItem = nil
    }
    
    func showLottie() {
        loadingView.isHidden = false
        loadingView.show()
    }
    
    func hideLottie() {
        loadingView.isHidden = true
        loadingView.dismiss()
    }
    
    func hideSeekToView() {
        seekToView.isHidden = true
    }
    // MARK: - Action Response
    /**
     Call when some action button Pressed
     
     - parameter button: action Button
     */
    @objc func clickBtnAction(_ button: UIButton) {
        dismissControlAnimation()
        if let type = HPButtonType(rawValue: button.tag) {
            switch type {
            case .play, .replay:
                break
            case .lock:
                self.lockButton.isSelected = !self.lockButton.isSelected
                PlayerManager.share.isLock = self.lockButton.isSelected
                self.setLockStatus(self.lockButton.isSelected)
            default:
                break
            }
        }
        delegate?.controlView(view: self, didPressButton: button)
    }
    
    private func setLockStatus(_ lock: Bool = false) {
        self.topView.isHidden = lock
        self.centerContentView.isHidden = lock
        self.bottomView.isHidden = lock
//        self.backButton.isEnabled = !lock
//        self.nexHPutton.isEnabled = !lock
//        self.ccButton.isEnabled = !lock
//        self.epsButton.isEnabled = !lock
//        self.fullButton.isEnabled = !lock
//        self.playButton.isEnabled = !lock
//        self.playMiddleBtn.isEnabled = !lock
//        self.forwBtn.isEnabled = !lock
//        self.backwBtn.isEnabled = !lock
//        self.timeSlider.isEnabled = !lock
    }
    /**
     Call when the tap gesture tapped
     
     - parameter gesture: tap gesture
     */
    @objc func tapAction(_ gesture: UITapGestureRecognizer) {
        if  playerState == .end {
            return
        }
        controlShowAnimation(isShowing: !showing)
    }
    
    @objc func doubleAction(_ gesture: UITapGestureRecognizer) {
        guard let player = player else { return }
        guard  playerState == .ready ||  playerState == .waiting ||  playerState == .finished else { return }
        
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @objc func leftTapAction(_ gesture: UITapGestureRecognizer) {
        self.backwordAction()
    }
    
    @objc func rightTapAction(_ gesture: UITapGestureRecognizer) {
        self.forword()
    }
    
    func backwordAction() {
        guard let player = player else { return }
        if player.currentPosition > 1 {
            if player.currentPosition > 15 {
                player.seek(player.currentPosition - 15)
            } else {
                player.seek(0)
            }
        }
    }
    
    func forword() {
        guard let player = player else { return }
        if player.totalDuration - player.currentPosition > 15 {
            player.seek(player.currentPosition + 15)
        } else {
            player.seek(player.totalDuration)
        }
    }
    
    // MARK: - handle UI slider actions
    @objc func beginProgressValue(_ sender: UISlider)  {
        self.player?.tempIsPlaying = self.player?.isPlaying ?? true
        self.player?.pause()
        delegate?.controlView(view: self, slider: sender, onSliderEvent: .touchDown)
    }
    
    @objc func changeProgressValue(_ sender: UISlider)  {
        cancelAnimation()
        let currentTime = Double(sender.value) * totalDuration
        currentTimeL.text = HPPlayer.secondsToFormat(currentTime, duration: totalDuration)
        delegate?.controlView(view: self, slider: sender, onSliderEvent: .touchDown)
    }
    
    @objc func endProgressValue(_ sender: UISlider)  {
        dismissControlAnimation()
        delegate?.controlView(view: self, slider: sender, onSliderEvent: .touchUpInside)
    }
    
    @objc func tapProgressSlider(_ sender: UITapGestureRecognizer) {
        dismissControlAnimation()
    }
    
    // MARK: - private functions
    fileprivate func showCaption(from subtitle: HPSubtitles?, at time: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let subtitle = subtitle, let group = subtitle.searchSubtitle(for: time), PlayerManager.share.subtitleOn == true {
                self.captionBgView.isHidden = false
                self.captionL.attributedText = NSAttributedString(string: group.text, attributes: self.subtileAttr)
            } else {
                self.captionBgView.isHidden = true
            }
        }
    }
    
    @objc fileprivate func clickDefinitionAction(_ button:UIButton) {
        let height = isSelectDefinition ? 35 : resource!.definitions.count * 40
        defChooseView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.layoutIfNeeded()
        })
        isSelectDefinition = !isSelectDefinition
        if currentIndex != button.tag {
            currentIndex = button.tag
            delegate?.controlView(view: self, didChooseDefinition: button.tag)
        }
        upDatedefChooseViewUI()
    }
    
    @objc fileprivate func onReplyButtonPressed() {
        //        replayButton.isHidden = true
    }
}

extension HPPlayerControlView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if PlayerManager.share.isLock {
            return false
        }
        return true
    }
}
