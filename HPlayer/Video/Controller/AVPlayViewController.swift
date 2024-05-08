//
//  AVPlayViewController.swift
//  HPlayer
//
//  Created by HF on 2024/1/23.
//

import UIKit
import AVFoundation
import Adjust
import FBSDKCoreKit

class AVPlayViewController: UIViewController {
    private var model: AVModel = AVModel()
    private var from: PlayFrom = .index
    private var videoModel: AVModel = AVModel()
    private var infoModel: AVMoreModel = AVMoreModel()
    
    private let videoHeight = kScreenWidth * 9 / 16
    private var controller = HPPlayerControlView()
    private var player: HPPlayer!
    private var currentTime: TimeInterval = Date().timeIntervalSince1970
    var isAdsPlaying: Bool = false
    private var getSourceDate : TimeInterval?
    private var readyDate : TimeInterval?
    
    private var id: String = ""
    private var ssnId: String = ""
    private var midSsnId: String = ""
    private var epsId: String = "" {
        didSet {
            self.controller.isMovie = epsId.count == 0
        }
    }
    private var epsName: String = ""
    private var isScreenFull = false
    private var ssn_eps: String = ""
    private var FailedView: HPPlayerFailView = HPPlayerFailView.view()
    private var captions: HPSubtitles? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.controller.update(subtitles: self?.captions)
            }
        }
    }
    
    private var catptionList: [AVCaption] = []
    private let AVPlayHeadCellID = "AVPlayHeadCell"
    private let AVPlayHeadInfoCellID = "AVPlayHeadInfoCell"
    private let AVPlayLikeCellID = "AVPlayLikeCell"
    private let HPPlayEpsListCellID = "HPPlayEpsListCell"
    private var showInfo: Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.bounces = false
        table.backgroundColor = .clear
        table.register(UINib(nibName: String(describing: AVPlayHeadCell.self), bundle: nil), forCellReuseIdentifier: AVPlayHeadCellID)
        table.register(UINib(nibName: String(describing: AVPlayHeadInfoCell.self), bundle: nil), forCellReuseIdentifier: AVPlayHeadInfoCellID)
        table.register(UINib(nibName: String(describing: AVPlayLikeCell.self), bundle: nil), forCellReuseIdentifier: AVPlayLikeCellID)
        table.register(UINib(nibName: String(describing: HPPlayEpsListCell.self), bundle: nil), forCellReuseIdentifier: HPPlayEpsListCellID)
        table.isHidden = true
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    private var seekTime: Double = 0 {
        didSet {
            self.player.seek(seekTime)
        }
    }
    
    private var statusH = kStatusBarHeight
    private var currentPlayTime: Int = 30
    private var timer: Timer?
    private var playLock: Bool = false
    private var epsView: HPPlayerSelectEpsView?
    private var captionView: HPPlayerCaptionFullSetView?
    private var captionVC: HPPlayerCaptionSetView?
    private var isFirst: Bool = true

    init(model: AVModel, from: PlayFrom) {
        self.model = model
        self.id = self.model.id
        self.ssnId = self.model.ssn_id
        self.epsId = self.model.eps_id
        self.from = from
        super.init(nibName: nil, bundle: nil)
    }
    private var tempPlay: Bool = true
    private var isPlayStatus: Bool = true
    private var errorInfo: String = "play failed"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        configPlayerManager()
        setPlayResource()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadPushVideo), name: HPKey.Noti_PushAPNS, object: nil)

        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            let device = UIDevice.current
            if device.orientation == .landscapeLeft || device.orientation == .landscapeRight{
                self.isScreenFull = true
                self.screenOrientationChanged(isLand: true)
            } else if device.orientation == .portrait || device.orientation == .portraitUpsideDown {
                if self.playLock == false {
                    self.isScreenFull = false
                    self.screenOrientationChanged(isLand: false)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self, let _ = self.player else { return }
            self.player.pause()
            self.screenOrientationChanged(isLand: self.isScreenFull)
            let name = self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.title
            
            HPLog.tb_movie_play_len(movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: name ?? "", movie_type: "\(self.model.type)", watch_len: String(Int(ceil(Date().timeIntervalSince1970 - self.currentTime))))
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            guard HPConfig.topVC()?.isKind(of: AVPlayViewController.self) == true else {
                return
            }
            HPConfig.share.showADS(type: .open) { success in
                if success {
                    self.isAdsPlaying = true
                    if let _ = self.player {
                        self.player.pause()
                    }
                }
            }
            HPADManager.share.tempDismissComplete = {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isAdsPlaying = false
                    if let _ = self.player {
                        if self.tempPlay {
                            self.player.play()
                        }
                    }
                    if let _ = self.readyDate {
                        
                    } else {
                        self.getSourceDate = Date().timeIntervalSince1970
                    }
                    self.currentTime = Date().timeIntervalSince1970
                }
                HPADManager.share.tempDismissComplete = nil
            }
            
            if let _ = self.player {
                if self.tempPlay {
                    self.player.play()
                }
            }
            
            if let _ = self.readyDate {
                
            } else {
                self.getSourceDate = Date().timeIntervalSince1970
            }
            self.currentTime = Date().timeIntervalSince1970
        }
        
        NotificationCenter.default.addObserver(forName: HPKey.Noti_CcRefresh, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            if let model = DBManager.share.selectAVData(id: self.id, ssn_id: self.ssnId, eps_id: self.epsId) {
                if let m = model.captions.first(where: {$0.short_name == PlayerManager.share.getLanguage()}) {
                    m.isSelect = true
                } else {
                    if let dm = model.captions.first(where: {$0.short_name == PlayerManager.share.defaultLanguage}) {
                        dm.isSelect = true
                    } else {
                        model.captions.first?.isSelect = true
                    }
                }
                self.catptionList = model.captions
                if let caption = model.captions.first(where: { $0.isSelect == true}) {
                    if let url = URL(string: "\(caption.local_address)") {
                        self.captions = HPSubtitles(url: url)
                    }
                }
            }
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard let _ = parent else {
            self.controller.isReadyToPlayed = false
            HPConfig.share.showADS(type: .play) { _ in
                
            }
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate  {
            appdelegate.allow = true
        }
        self.currentTime = Date().timeIntervalSince1970
      
        let device = UIDevice.current
        if device.orientation == .landscapeLeft || device.orientation == .landscapeRight{
            isScreenFull = true
            self.screenOrientationChanged(isLand: true)
        } else if device.orientation == .portrait || device.orientation == .portraitUpsideDown {
            if self.playLock == false {
                isScreenFull = false
                self.screenOrientationChanged(isLand: false)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        HPProgressHUD.dismiss()
        if self.navigationController == nil {
            if let appdelegate = UIApplication.shared.delegate as? AppDelegate  {
                appdelegate.allow = false
                appdelegate.lock = false
            }
            self.controller.isReadyToPlayed = false
            if let _ = self.player {
                self.player.removeFromSuperview()
                self.player = nil
            }
   
            deinitTimer()
            NotificationCenter.default.removeObserver(self)
        }
        let name = self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.title

        if self.videoModel.title.count > 0 || name?.count ?? 0 > 0 {
            HPLog.tb_movie_play_len(movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: name ?? "", movie_type: "\(self.model.type)", watch_len: String(Int(ceil(Date().timeIntervalSince1970 - self.currentTime))))
        }
    }
    
    deinit {
        print("player deinit")
    }
    
    func initUI() {
        view.backgroundColor = UIColor.hexColor("#141414")
        player = HPPlayer(customControlView: controller)
        view.addSubview(player)
        player.sourceKey = self.id
        player.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(statusH)
            make.height.equalTo(self.videoHeight)
        }
        
        view.addSubview(FailedView)
        FailedView.snp.makeConstraints { make in
            make.center.equalTo(player)
            make.width.equalTo(280)
            make.height.equalTo(120)
        }
        
        FailedView.clickBlock = { [weak self] in
            guard let self = self else { return }
            self.setPlayResource()
        }
        player.vc = self
        player.delegate = self
        player.backBlock = { [weak self] isFullScreen in
            guard let self = self else { return }
            self.tableView.isHidden = isFullScreen
            if isFullScreen {
                self.player.fullScreenButtonPressed()
            } else {
                self.controller.isReadyToPlayed = false
                self.navigationController?.popViewController(animated: true)
                HPConfig.share.showADS(type: .play) { _ in
                    
                }
            }
        }
        player.exitFullScreen = { [weak self] full in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.isHidden = full
            }
        }
        view.addSubview(self.tableView)
        tableView.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.player.snp.bottom)
        }
        self.seekTime = self.model.playedTime
        self.controller.isMovie = epsId.count == 0
        self.view.layoutIfNeeded()
    }
    
    func setPlayResource() {
        self.currentTime = Date().timeIntervalSince1970
        self.getSourceDate = Date().timeIntervalSince1970
        self.readyDate = nil
        self.tempPlay = true
        self.tableView.isHidden = true
        self.catptionList.removeAll()
        controller.ccButton.isEnabled = false
        self.controller.playRate = 1.0
        self.player.playerLayer?.player?.rate = 1.0
        self.FailedView.isHidden = true
        self.player.isFaceBook = false
        if self.isFirst == false, let _ = self.player {
            self.player.playerLayer?.distroyPrepare()
        }
        self.controller.captionBgView.isHidden = true
        self.isFirst = false
        let videoSize = UserDefaults.standard.object(forKey: "videoGravity") as? Bool ?? false
        self.player.videoGravity = videoSize ? .resizeAspectFill : .resizeAspect
        
        self.controller.isReadyToPlayed = false
        var asset: PlayerResource?
        HPConfig.share.showADS(type: self.player.isFullScreen ? .other : .play) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.isAdsPlaying = true
                if let _ = self.player, self.player.isPlaying {
                    self.player.pause()
                }
            }
        }
        var requestResult: Bool = true
        HPProgressHUD.show()
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue.global()
        group.enter()
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            PlayerNetAPI.share.AVInfoData(isMovie: self.model.type == 1 ? true : false, id: self.id) { success, model in
                if success {
                    self.videoModel = model
                    self.videoModel.ssn_list = self.model.ssn_list
                    self.videoModel.eps_list = self.model.eps_list
                    if self.model.type == 2 {
                        self.videoModel.video = self.model.video
                        if let list = self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.caption_list {
                            self.model.caption_list = list
                            self.videoModel.caption_list = list
                            self.videoModel.captions = self.model.midCaptions
                        }
                    } else {
                        self.videoModel.caption_list = model.caption_list
                        self.videoModel.captions = model.midCaptions
                    }
                    self.videoModel.cover = model.cover
                    self.videoModel.type = self.model.type
                    self.model.captions = self.videoModel.captions
                    self.getCcptionData()
                                
                    if self.model.type == 2 {
                        self.videoModel.ssn_list.first(where: {$0.id == self.ssnId})?.isSelect = true
                        self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.isSelect = true
                        self.epsName = self.videoModel.eps_name
                    }
                } else {
                    requestResult = false
                }
                group.leave()
            }
        }
        group.enter()
        dispatchQueue.async {[weak self] in
            guard let self = self else { return }
            PlayerNetAPI.share.AVMoreInfoData(isMovie: self.model.type == 1 ? true : false, id: self.id) { success, model in
                if success {
                    self.infoModel = model
                } else {
                    requestResult = false
                }
                group.leave()
            }
        }
        if self.model.type == 2, self.videoModel.ssn_list.count == 0 {
            group.enter()
            dispatchQueue.async {[weak self] in
                guard let self = self else { return }
                PlayerNetAPI.share.AVTVSsnData(id: self.id) { success, list in
                    if success, let mod = list.last {
                        self.ssnId = mod.id
                        self.model.ssn_list = list
                        self.videoModel.ssn_list = list
                        if self.videoModel.eps_list.count == 0 {
                            PlayerNetAPI.share.AVTVEpsData(id: self.id, ssnId: mod.id) { success, epslist in
                                if success {
                                    if self.epsId.count == 0 {
                                        if let epsModel = epslist.first {
                                            self.epsId = epsModel.id
                                            self.videoModel.video = epsModel.video
                                        }
                                    } else {
                                        if let url = epslist.first(where: {$0.id == self.epsId})?.video
                                        {
                                            self.videoModel.video = url
                                        }
                                    }
                                    epslist.first(where: {$0.id == self.epsId})?.isSelect = true
                                    self.model.eps_list = epslist
                                    self.videoModel.eps_list = epslist
                                } else {
                                    requestResult = false
                                }
                                group.leave()
                            }
                        } else {
                            group.leave()
                        }
                    } else {
                        requestResult = false
                    }
                }
            }
        }
        group.notify(queue: dispatchQueue){ [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                HPProgressHUD.dismiss()
                self.infoModel.pub_date = self.videoModel.pub_date
                self.infoModel.country = self.videoModel.country
                self.tableView.isHidden = false
                self.tableView.reloadData()
                if self.videoModel.type == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    }
                }

                let name = self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.title

                if let url = URL(string: self.videoModel.video), requestResult {
                    self.FailedView.isHidden = true
                    self.player.isFaceBook = false
                    asset = PlayerResource(name: self.videoModel.title, definitions: [HPPlayerResourceConfig(url: url, definition: "480p")], cover: nil, subtitles: self.captions)
                    HPLog.tb_movie_play_sh(movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.videoModel.type == 1 ? "" : self.epsId, eps_name: (self.videoModel.type == 1 ? "" : name) ?? "", source: "\(self.from.rawValue)", movie_type: "\(self.videoModel.type)")
                    self.player.setVideo(resource: asset!, sourceKey: self.id)
                } else {
                    self.tableView.isHidden = true
                    self.FailedView.isHidden = false
                    self.player.isFaceBook = true
                }
            }
        }
        HPADManager.share.tempDismissComplete = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            self.isAdsPlaying = false
            if let _ = self.player, self.tempPlay {
                self.player.play()
            }
            HPADManager.share.tempDismissComplete = nil
        }
    }
    
    func getCcptionData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            HPCaptionManager.share.downLoadCaptions(self.model)
        }
    }
    
    func configPlayerManager() {
        PlayerManager.share.allowLog = false
        PlayerManager.share.autoPlay = true
        PlayerManager.share.topBarInCase = .always
    }
    
    func playerTransed(isFull: Bool) {
        if let vc = self.captionVC, isFull {
            vc.dismiss(animated: false) { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.changeScreenInterfaceOrientation(isFull)
                }
            }
        } else {
            self.changeScreenInterfaceOrientation(isFull)
        }
    }
    
    func changeScreenInterfaceOrientation(_ isFull: Bool) {
        self.player.snp.remakeConstraints { (make) in
            if isFull {
                make.edges.equalToSuperview()
            } else {
                make.leading.trailing.equalToSuperview()
                make.top.equalToSuperview().offset(statusH)
                make.height.equalTo(self.videoHeight)
            }
        }
        
        let device = UIDevice.current
        if isFull == false {
//            HPADManager.share.hplayeraddAds(type: .play)
            if let view = self.epsView {
                view.dismissSelf()
            }
            if let view = self.captionView {
                view.dismissSelf()
            }
            if #available(iOS 16.0, *) {
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                let scene = UIApplication.shared.connectedScenes.first
                guard let window = scene as? UIWindowScene else { return }
                let dirction: UIInterfaceOrientationMask =  UIInterfaceOrientationMask.portrait
                
                let geometryPreferencesIOS = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: dirction)
                window.requestGeometryUpdate(geometryPreferencesIOS) { error in
                    print("geometryPreferencesIOS error: \(error)")
                }
            } else {
                if device.orientation == .portrait {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.portraitUpsideDown.rawValue, forKey: "orientation")
                }
            }
        } else {
//            HPADManager.share.hplayeraddAds(type: .other)
            if #available(iOS 16.0, *) {
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                let scene = UIApplication.shared.connectedScenes.first
                guard let window = scene as? UIWindowScene else { return }
                var dirction: UIInterfaceOrientationMask =  UIInterfaceOrientationMask.landscapeLeft

                if device.orientation == .landscapeLeft {
                    dirction = .landscapeRight
                } else {
                    dirction = .landscapeLeft
                }
                
                let geometryPreferencesIOS = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: dirction)
                window.requestGeometryUpdate(geometryPreferencesIOS) { error in
                    print("geometryPreferencesIOS error: \(error)")
                }
            } else {
                if device.orientation == .landscapeLeft {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                }
            }
        }
    }
    
    
    func screenOrientationChanged(isLand: Bool) {
        if self.playLock == false, let _ = self.player {
            self.player.isFullScreen = isLand
            self.playerTransed(isFull: isLand)
            self.player.reSetUI(isLand)
            self.tableView.isHidden = isLand
        }
    }
    
    // tv播放下一集
    func playerNextAction() {
        let _ = self.videoModel.ssn_list.map({$0.isSelect = false})
        self.videoModel.ssn_list.first(where: {$0.id == self.ssnId})?.isSelect = true
        HPProgressHUD.show()
        PlayerNetAPI.share.AVTVEpsData(id: self.id, ssnId: self.ssnId) { [weak self] success, list in
            guard let self = self else { return }
            HPProgressHUD.dismiss()
            list.first(where: {$0.id == self.epsId})?.isSelect = true
            self.model.eps_list = list
            self.videoModel.eps_list = list
            self.addNextResource()
        }
    }
    
    func addNextResource() {
        for (index, m) in self.videoModel.eps_list.enumerated() {
            if self.epsId == m.id {
                m.isSelect = false
                if index == self.videoModel.eps_list.count - 1 {
                    for (ssnIdx, ssnItem) in self.videoModel.ssn_list.enumerated() {
                        if self.ssnId == ssnItem.id {
                            if let model = self.videoModel.ssn_list.indexOfSafe(ssnIdx + 1) {
                                self.ssnId = model.id
                                HPProgressHUD.show()
                                PlayerNetAPI.share.AVTVEpsData(id: self.id, ssnId: self.ssnId) { [weak self] success, epsList in
                                    guard let self = self else { return }
                                    HPProgressHUD.dismiss()
                                    if let first = epsList.first  {
                                        first.isSelect = true
                                        self.epsId = first.id
                                        self.epsName = first.title
                                        self.model.eps_list = epsList
                                        self.model.video = first.video
                                        self.setPlayResource()
                                        let _ = self.videoModel.ssn_list.map({$0.isSelect = false})
                                        self.videoModel.ssn_list.first(where: {$0.id == self.ssnId})?.isSelect = true
                                        HPLog.tb_movie_play_cl(kid: "2", movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: self.epsName)
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                                                guard let self = self else { return }
                                                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .none, animated: false)
                                            }
                                        }
                                    }
                                }
                                return
                            } else {
                                if let mod = DBManager.share.selectAVData(id: self.id, ssn_id: self.ssnId, eps_id: self.epsId) {
                                    mod.playedTime = 0
                                    mod.playProgress = 0
                                    self.model.video = mod.video
                                    HPLog.tb_movie_play_cl(kid: "2", movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: mod.eps_name)
                                    DBManager.share.updatePlayData(model)
                                    self.setPlayResource()
                                    return
                                }
                            }
                        }
                    }
                } else {
                    if let model = self.videoModel.eps_list.indexOfSafe(index + 1) {
                        self.epsId = model.id
                        self.epsName = model.title
                        self.model.video = model.video
                        let _ = self.videoModel.eps_list.map({$0.isSelect = false})
                        self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.isSelect = true
                        HPLog.tb_movie_play_cl(kid: "2", movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: self.epsName)
                        self.setPlayResource()
                        return
                    }
                }
            }
        }
    }
    func initPlayerTimer() {
        currentPlayTime = 30
        if let _ = timer {
            
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTime), userInfo: nil, repeats: true)
            if let t = timer {
                RunLoop.main.add(t, forMode: .common)
            }
        }
    }
    
    @objc func countTime() {
        currentPlayTime -= 1
        if currentPlayTime == 0 {
            deinitTimer()
            self.player.playerLayer?.distroyPrepare()
            self.FailedView.isHidden = false
            self.player.isFaceBook = true
        }
    }
    
    func deinitTimer() {
        self.controller.hideLottie()
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    //MARK: - Push APNS
    @objc func loadPushVideo(_ info: Notification) {
        if let pl = self.player, let p = pl.playerLayer {
            self.tempPlay = true
            p.pause()
            p.seekTime = 0
            p.playerLayer?.removeFromSuperlayer()
        }
        if let u = info.userInfo as? [String: Any], let mod = apnsModel.deserialize(from: u) {
            let m = AVModel()
            m.id = mod._id
            m.type = mod.type
            self.id = mod._id
            DBManager.share.updateData(m)
            self.getVideoData(self.id) { [weak self] vMod in
                guard let self = self else { return }
                self.model = vMod
                self.videoModel = vMod
                self.from = .push
                self.showSeekTime()
            }
        }
    }
}

extension AVPlayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell: AVPlayHeadCell = tableView.dequeueReusableCell(withIdentifier: AVPlayHeadCellID) as! AVPlayHeadCell
                cell.setModel(self.infoModel, moreSelect: self.showInfo) { [weak self] show in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.showInfo = show
                    }
                } refreshBlock: { [weak self] in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
                
                return cell
            } else {
                let cell: AVPlayHeadInfoCell = tableView.dequeueReusableCell(withIdentifier: AVPlayHeadInfoCellID) as! AVPlayHeadInfoCell
                cell.setModel(self.infoModel)
                return cell
            }
        } else {
            if self.model.type == 1 {
                let cell: AVPlayLikeCell = tableView.dequeueReusableCell(withIdentifier: AVPlayLikeCellID) as! AVPlayLikeCell
                if let smodel = self.infoModel.related_list.indexOfSafe(indexPath.row) {
                    cell.setModel(smodel) { [weak self] index in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            if let mod = smodel.data_list.indexOfSafe(index) {
                                DBManager.share.updateData(mod)
                                self.getVideoData(mod.id) { m in
                                    self.model = m
                                    self.videoModel = m
                                    self.model.title = mod.title
                                    self.videoModel.title = mod.title
                                    self.from = .play
                                    HPLog.tb_movie_play_cl(kid: "1", movie_id: self.id, movie_name: mod.title, eps_id: self.epsId, eps_name: self.epsName)
                                    self.showSeekTime()
                                }
                            }
                        }
                    }
                }
                return cell
            } else {
                let cell:HPPlayEpsListCell = tableView.dequeueReusableCell(withIdentifier: HPPlayEpsListCellID) as! HPPlayEpsListCell
                if let model = self.videoModel.eps_list.indexOfSafe(indexPath.row) {
                    cell.model = model
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.model.type == 2, section != 0 {
            let view = AVPlaySsnHeadView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 68))
            view.setModel(self.videoModel.ssn_list) { [weak self] id in
                guard let self = self else { return }
                self.midSsnId = id
                self.getTVData(id, section: section)
            }
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0, let model = self.videoModel.eps_list.indexOfSafe(indexPath.row) {
            self.epsId = model.id
            if self.midSsnId.count > 0 {
                self.ssnId = self.midSsnId
            }
            self.model.ssn_id = self.ssnId
            self.model.eps_id = self.epsId
            self.model.playProgress = 0
            self.model.playedTime = 0

            DBManager.share.updateData(self.model)
            let _ = self.videoModel.eps_list.map({$0.isSelect = false})
            model.isSelect = true
            self.model.video = model.video
            self.showSeekTime()
            self.from = .selectTV
            self.epsName = model.title
            HPLog.tb_movie_play_cl(kid: "3", movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: model.title)
            self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.model.type == 2, section != 0 {
            return 68
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.showInfo ? 2 : 1
        } else {
            if self.model.type == 1 {
                return self.infoModel.related_list.count
            } else {
                return self.videoModel.eps_list.count
            }
        }
    }
    
    
    func getVideoData(_ vid: String, _ completion: @escaping (_ model: AVModel) -> ()) {
        if let vModel = DBManager.share.selectAVData(id: vid) {
            if vModel.type == 1 {
                let mod: AVModel = AVModel()
                mod.id = vModel.id
                self.id = vModel.id
                self.ssnId = ""
                self.epsId = ""
                self.epsName = ""
                mod.cover = vModel.cover
                mod.type = vModel.type
                completion(mod)
            } else {
                HPProgressHUD.show()
                PlayerNetAPI.share.AVTVSsnData(id: vid) { [weak self] success, ssnList in
                    guard let self = self else { return }
                    HPProgressHUD.dismiss()
                    if success, let mod = ssnList.last {
                        PlayerNetAPI.share.AVTVEpsData(id: vModel.id, ssnId: mod.id) { success, epsList in
                            if let epsM = epsList.first {
                                DispatchQueue.main.async {
                                    let avModel = AVModel()
                                    avModel.id = vModel.id
                                    avModel.title = vModel.title
                                    avModel.cover = vModel.cover
                                    avModel.rate = vModel.rate
                                    avModel.video = epsM.video
                                    avModel.ssn_eps = vModel.ssn_eps
                                    avModel.country = vModel.country
                                    avModel.ssn_id = mod.id
                                    avModel.ssn_name = mod.title
                                    avModel.eps_id = epsM.id
                                    avModel.eps_num = epsM.eps_num
                                    avModel.eps_name = epsM.title
                                    avModel.type = 2
                                    avModel.eps_list = epsList
                                    avModel.ssn_list = ssnList
                                    self.ssnId = mod.id
                                    self.epsId = epsM.id
                                    self.epsName = epsM.title
                                    DBManager.share.updateData(avModel)
                                    completion(avModel)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getTVData(_ ssnId: String, section: Int) {
        if let _ = self.videoModel.ssn_list.first(where: {$0.isSelect == true && $0.id == ssnId}) {
            return
        } else {
            let _ = self.videoModel.ssn_list.map({$0.isSelect = false})
            self.videoModel.ssn_list.first(where: {$0.id == ssnId})?.isSelect = true
        }
        PlayerNetAPI.share.AVTVEpsData(id: self.id, ssnId: ssnId) { [weak self] success, list in
            guard let self = self else { return }
            if let m = list.first(where: {$0.id == self.epsId}) {
                m.isSelect = true
            }
            self.model.eps_list = list
            self.videoModel.eps_list = list
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for (index, item) in self.videoModel.eps_list.enumerated() {
                    if item.isSelect {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.tableView.scrollToRow(at: IndexPath(row: index, section: section), at: .none, animated: false)
                        }
                    }
                }
            }
        }
    }
    
    func showSeekTime() {
        let name = self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.title
        HPLog.tb_movie_play_len(movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: name ?? "", movie_type: "\(self.model.type)", watch_len: String(Int(ceil(Date().timeIntervalSince1970 - self.currentTime))))
        self.setPlayResource()
        if let db = DBManager.share.selectAVData(id: self.id, ssn_id: self.ssnId, eps_id: self.epsId) {
            self.seekTime = db.playedTime
        }
    }
}

// MARK: - HPPlayerDelegate
extension AVPlayViewController: HPPlayerDelegate {
    // Call when player orinet changed
    func player(player: HPPlayer, playerOrientChanged isFullscreen: Bool) {
        player.snp.remakeConstraints { (make) in
            if isFullscreen {
                make.edges.equalToSuperview()
            } else {
                make.leading.trailing.equalToSuperview()
                make.top.equalToSuperview().offset(statusH)
                make.height.equalTo(self.videoHeight)
            }
        }
    }
    
    func player(player: HPPlayer, playerIsPlaying playing: Bool) {
        print("playing: \(playing)")
    }
    
    func player(player: HPPlayer, playerStateDidChange state: PlayerState) {
        print("play-state: \(state)")
        switch state {
        case .ready:
            if let _ = self.readyDate {
                
            } else {
                self.readyDate = Date().timeIntervalSince1970
                let name = self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.title
                
                if let oldTime = self.getSourceDate, let ready = self.readyDate {
                    let time = abs(Int(ready - oldTime))
                    HPLog.tb_playback_status(movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: name ?? "", source: "\(self.from.rawValue)", movie_type: "\(self.model.type)", cache_len: "\(time)", if_success: "1", errorinfo: "")
                }
            }
            self.isPlayStatus = true
        case .waiting:
            self.initPlayerTimer()
        case .end:
            self.deinitTimer()
            self.playerNextAction()
        case .finished:
            var event = ADJEvent(eventToken: "y7ntfn")
            #if DEBUG
            #else
            event = ADJEvent(eventToken: "d3h40b")
            #endif
            Adjust.trackEvent(event)
            AppEvents.shared.logEvent(AppEvents.Name.viewedContent)
            
            if self.isAdsPlaying || HPConfig.topVC()?.isKind(of: AVPlayViewController.self) == false   {
                if let p = self.player {
                    p.pause()
                }
            }
            self.deinitTimer()
        case .error:
            self.isPlayStatus = false
            if let error = player.playerLayer?.playerItem?.error?.localizedDescription {
                self.errorInfo = error
                let name = self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.title
                
                if let oldTime = self.getSourceDate {
                    let time = abs(Int(Date().timeIntervalSince1970 - oldTime))
                    HPLog.tb_playback_status(movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: name ?? "", source: "\(self.from.rawValue)", movie_type: "\(self.model.type)", cache_len: "\(time)", if_success: "2", errorinfo: self.errorInfo)
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.FailedView.isHidden = false
                self.player.isFaceBook = true
            }
        default:
            break
        }
    }
    
    func player(player: HPPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        let model: AVModel = AVModel()
        model.id = self.id
        model.ssn_id = self.ssnId
        model.eps_id = self.epsId
        model.totalTime = Double(totalTime)
        model.title = self.videoModel.title
        model.cover = self.videoModel.cover
        model.type = self.model.type
        var ssn_num: String = ""
        for (index, item) in self.videoModel.ssn_list.enumerated() {
            if item.isSelect {
                ssn_num = "\(index + 1)"
            }
        }
        if let epsModel = self.videoModel.eps_list.filter({$0.isSelect == true}).first {
            let num = "\(epsModel.eps_num)"
            model.ssn_eps = "S\(ssn_num.changeToNum()) E\(num.changeToNum())"
            model.eps_name = epsModel.title
        }
        model.playedTime = Double(currentTime)
        model.playProgress = Double(currentTime) / Double(totalTime)
        
        DBManager.share.updatePlayData(model)
    }
    
    func player(player: HPPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func playerShowEpsView() {
        self.epsView = HPPlayerSelectEpsView.view()
        view.addSubview(epsView!)
        epsView?.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
//        let _ = self.videoModel.ssn_list.map({$0?.isSelect = false})
//        self.videoModel.ssn_list.filter({$0?.id == self.ssnId}).first??.isSelect = true
        epsView?.setModel(self.id, self.videoModel.ssn_list, self.videoModel.eps_list, self.epsId) { [weak self] epsList, ssnId, epsId in
            guard let self = self else { return }
            self.model.eps_list = epsList
            self.ssnId = ssnId
            self.epsId = epsId
            self.from = .selectTV
            let name = epsList.first(where: {$0.id == epsId})?.title
            self.epsName = name ?? ""
            HPLog.tb_movie_play_cl(kid: "3", movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: self.epsName)
            self.setPlayResource()
        }
    }
    
    func playerNext() {
        self.from = .nextTV
        self.playerNextAction()
    }
    
    func playerIsPlaying(_ play: Bool) {
        self.tempPlay = play
    }
    
    func playerChangeVideoGravity() {
        let name = self.videoModel.eps_list.first(where: {$0.id == self.epsId})?.title
        HPLog.tb_movie_play_cl(kid: "4", movie_id: self.id, movie_name: self.videoModel.title, eps_id: self.epsId, eps_name: name ?? "")
    }
    
    func playerShowCaptionView(_ isfull: Bool) {
        if isfull {
            self.captionView = HPPlayerCaptionFullSetView.view()
            view.addSubview(self.captionView!)
            self.captionView?.snp.makeConstraints { make in
                make.left.right.top.bottom.equalToSuperview()
            }
            self.captionView?.setModel(self.catptionList, view: view)
            self.captionView?.clickBlock = {[weak self] address in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let caption = self.catptionList.first(where: { $0.local_address == address}) {
                        if let url = URL(string: "\(caption.local_address)") {
                            self.captions = HPSubtitles(url: url)
                        }
                    }
                }
            }
        } else {
            let vc = HPPlayerCaptionSetView(list: self.catptionList)
            if self.player.isPlaying {
                self.player.pause()
            }
            vc.dismissBlock = {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if self.tempPlay {
                        self.player.play()
                    }
                }
            }
            vc.clickItemBlock = { [weak self] address in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let caption = self.catptionList.first(where: { $0.local_address == address}) {
                        if let url = URL(string: "\(caption.local_address)") {
                            self.captions = HPSubtitles(url: url)
                        }
                    }
                }
            }

            vc.modalPresentationStyle = .overFullScreen
            self.captionVC = vc
            self.present(vc, animated: false)
        }
    }
    
    func playerScreenLock(_ lock: Bool) {
        self.playLock = lock
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate  {
            appdelegate.lock = lock
        }
        if lock {
            let device = UIDevice.current
            if #available(iOS 16.0, *) {
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                let scene = UIApplication.shared.connectedScenes.first
                guard let windowScene = scene as? UIWindowScene else { return }
                var dirction: UIInterfaceOrientationMask =  UIInterfaceOrientationMask.landscapeLeft
                
                if device.orientation == .landscapeRight {
                    dirction = .landscapeLeft
                } else {
                    dirction = .landscapeRight
                }
                let geometryPreferencesIOS = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: dirction)
                windowScene.requestGeometryUpdate(geometryPreferencesIOS) { error in
                    print("geometryPreferencesIOS error: \(error)")
                }
            } else {
                if device.orientation == .landscapeLeft {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                }
            }
        }
    }
}
