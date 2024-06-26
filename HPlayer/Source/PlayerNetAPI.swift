//
//  PlayerNetAPI.swift
//  HPlayer
//
//  Created by HF on 2023/12/21.
//

import Foundation
enum AVNetAPI: String {
    /// 首页
    case AVIndexApi = "NzFzHk/iSM/NfCUKew"
    /// banner
    case AVBannerApi = "lfIHLAXbZQ/uGjdxuUQVs/GeiwvPOt"
    /// 更多
    case AVMoreListApi = "hVaGQuI/BauTCfa"
    /// 搜索TopData
    case AVSearchTopApi = "YNawcSJTX/oeRqNCaNf"
    /// filter head
    case AVFilterHeadApi = "pGfiuRvgy/KbYUmQO"
    /// filter
    case AVFilterApi = "PUTDlH/IfqvFuaF/fgMJkQO"
    /// tveps
    case AVTvEpsApi = "deUBnDWtN/daZLK/wbvRvyf"
    /// tvssn
    case AVTvSsnApi = "hEz/KgJmHx"
    /// AV,tvInfo
    case AVInfoApi = "tlqOBIE/WHXFgWnOU"
    /// AV More Info
    case AVMoreInfoApi = "gqbRSXaW/itFFKq"
    /// SearchClickCount
    case AVSearchClickCountApi = "YOpRgNvAn/QVN/mpqDGp"
}

class PlayerNetAPI {
    static let share = PlayerNetAPI()
    let pageSize: Int = 30
    
    func AVIndexList(_ completion: @escaping (_ success: Bool, _ list: [AVHomeModel]) -> ()) {
        let currentTime: TimeInterval = Date().timeIntervalSince1970
        let para: [String: String] = [:]
        HPLog.tb_home_sh(loadsuccess: "2", errorinfo: "")
        NetManager.request(url: AVNetAPI.AVIndexApi.rawValue, method: .get, parameters: para, modelType: AVHomeModel.self) { responseModel in
            if responseModel.status == .success {
                if let list = responseModel.models as? [AVHomeModel] {
                    HPLog.tb_home_sh_result(loadsuccess: "1", errorinfo: "", cache_len: String(Int(ceil(Date().timeIntervalSince1970 - currentTime))))
                    completion(responseModel.status == .success, list)
                } else {
                    HPLog.tb_home_sh_result(loadsuccess: "2", errorinfo: responseModel.errorMessage, cache_len: String(Int(ceil(Date().timeIntervalSince1970 - currentTime))))
                    completion(false, [AVHomeModel()])
                }
            }else {
                HPLog.tb_home_sh_result(loadsuccess: "2", errorinfo: responseModel.errorMessage, cache_len: "15")
                completion(false, [AVHomeModel()])
            }
        }
    }
    
    func AVBannerList(_ completion: @escaping (_ success: Bool, _ list: [AVDataInfoModel]) -> ()) {
        let para: [String: String] = [:]
        NetManager.request(url: AVNetAPI.AVBannerApi.rawValue, method: .get, parameters: para, modelType: AVDataInfoModel.self) { responseModel in
            if let list = responseModel.models as? [AVDataInfoModel] {
                completion(responseModel.status == .success, list)
            } else {
                completion(false, [AVDataInfoModel()])
            }
        }
    }
    
    func AVMoreList(id: String, page: Int = 1, _ completion: @escaping (_ success: Bool, _ list: [AVDataInfoModel]) -> ()) {
        var para: [String: String] = [:]
        para[Para_topicId] = id
        para[Para_page] = "\(page)"
        para[Para_pageSize] = "\(self.pageSize)"
        
        NetManager.request(url: AVNetAPI.AVMoreListApi.rawValue, method: .post, parameters: para, modelType: AVDataInfoModel.self) { responseModel in
            if let list = responseModel.models as? [AVDataInfoModel] {
                completion(responseModel.status == .success, list)
            } else {
                completion(false, [AVDataInfoModel()])
            }
        }
    }
    
    func AVSearchTopData(from: String, _ completion: @escaping (_ success: Bool, _ list: [AVSearchTopDataModel]) -> ()) {
        let para: [String: String] = [:]
        HPLog.tb_search_sh(statuses: "2", source: from)
        let currentTime: TimeInterval = Date().timeIntervalSince1970
        NetManager.request(url: AVNetAPI.AVSearchTopApi.rawValue, method: .get, parameters: para, modelType: AVSearchTopDataModel.self) { responseModel in
            if responseModel.status == .success {
                if let list = responseModel.models as? [AVSearchTopDataModel] {
                    completion(responseModel.status == .success, list)
                    HPLog.tb_search_sh_result(loadsuccess: "1", errorinfo: "", cache_len: String(Int(ceil(Date().timeIntervalSince1970 - currentTime))))
                } else {
                    HPLog.tb_search_sh_result(loadsuccess: "2", errorinfo: responseModel.errorMessage, cache_len: String(Int(ceil(Date().timeIntervalSince1970 - currentTime))))
                    completion(false, [AVSearchTopDataModel()])
                }
            } else {
                HPLog.tb_search_sh_result(loadsuccess: "2", errorinfo: responseModel.errorMessage, cache_len: "15")
                completion(false, [AVSearchTopDataModel()])
            }
        }
    }
    
    func AVSearchClickInfo(_ id: String, _ completion: @escaping (_ success: Bool, _ model: AVFilterCategoryModel) -> ()) {
        var para: [String: String] = [:]
        para[Mod_id] = id
        NetManager.request(url: AVNetAPI.AVSearchClickCountApi.rawValue, method: .post, parameters: para, modelType: ResponseDefault.self) { responseModel in
            print(responseModel.status)
        }
    }
    
    func AVFilterHeadInfo( _ completion: @escaping (_ success: Bool, _ model: AVFilterCategoryModel) -> ()) {
        let para: [String: String] = [:]
        NetManager.request(url: AVNetAPI.AVFilterHeadApi.rawValue, method: .get, parameters: para, modelType: AVFilterCategoryModel.self) { responseModel in
            if let mod = responseModel.model {
                completion(responseModel.status == .success, mod)
            } else {
                completion(false, AVFilterCategoryModel())
            }
        }
    }
    
    
    func AVFilterInfoData(genre: String = "", year: String = "", cntyno: String = "", type: String = "", page: Int = 1, key: String = "", from: String = "1", _ completion: @escaping (_ success: Bool, _ list: [AVDataInfoModel]) -> ()) {
        var para: [String: String] = [:]
        para[Mod_country] = cntyno
        para[Mod_genre] = genre
        para[Mod_year] = year
        para[Mod_type] = type
        para[Para_page] = "\(page)"
        para[Para_pageSize] = "\(self.pageSize)"
        para[Para_fuzzy_match] = key
        if key.count == 0 {
            HPLog.tb_explore_sh(loadsuccess: "2")
        }
        let currentTime: TimeInterval = Date().timeIntervalSince1970
        NetManager.request(url: AVNetAPI.AVFilterApi.rawValue, method: .post, parameters: para, modelType: AVDataInfoModel.self) { responseModel in
            if responseModel.status == .success {
                if let list = responseModel.models as? [AVDataInfoModel] {
                    if key.count == 0 {
                        HPLog.tb_explore_sh_result(loadsuccess: "1", errorinfo: "", cache_len: String(Int(ceil(Date().timeIntervalSince1970 - currentTime))))
                    } else {
                        HPLog.tb_search_result_sh_result(loadsuccess: list.count > 0 ? "1" : "2", errorinfo: "", cache_len: String(Int(ceil(Date().timeIntervalSince1970 - currentTime))))
                    }
                    completion(responseModel.status == .success, list)
                } else {
                    if key.count == 0 {
                        HPLog.tb_explore_sh_result(loadsuccess: "2", errorinfo: responseModel.errorMessage, cache_len: String(Int(ceil(Date().timeIntervalSince1970 - currentTime))))
                    } else {
                        HPLog.tb_search_result_sh_result(loadsuccess: "3", errorinfo: responseModel.errorMessage, cache_len: String(Int(ceil(Date().timeIntervalSince1970 - currentTime))))
                    }
                    completion(false, [AVDataInfoModel()])
                }
            } else {
                if key.count == 0 {
                    HPLog.tb_explore_sh_result(loadsuccess: "2", errorinfo: responseModel.errorMessage, cache_len: "15")
                } else {
                    HPLog.tb_search_result_sh_result(loadsuccess: "3", errorinfo: responseModel.errorMessage, cache_len: "15")
                }
                completion(false, [AVDataInfoModel()])
            }
        }
    }
    //MARK: - AV,TV data Info
    func AVInfoData(isMovie: Bool = true, id: String, _ completion: @escaping (_ success: Bool, _ model: AVModel) -> ()) {
        var para: [String: String] = [:]
        para[Mod_type] = isMovie ? "1" : "2"
        para[Mod_id] = id
        NetManager.request(url: AVNetAPI.AVInfoApi.rawValue, method: .post, parameters: para, modelType: AVModel.self) { responseModel in
            if let model = responseModel.model {
                completion(responseModel.status == .success, model)
            } else {
                completion(false, AVModel())
            }
        }
    }
    
    func AVMoreInfoData(isMovie: Bool = true, id: String, _ completion: @escaping (_ success: Bool, _ model: AVMoreModel) -> ()) {
        var para: [String: String] = [:]
        para[Mod_type] = isMovie ? "1" : "2"
        para[Mod_id] = id
        NetManager.request(url: AVNetAPI.AVMoreInfoApi.rawValue, method: .post, parameters: para, modelType: AVMoreModel.self) { responseModel in
            if let model = responseModel.model {
                completion(responseModel.status == .success, model)
            } else {
                completion(false, AVMoreModel())
            }
        }
    }
    
    //MARK: - TV
    func AVTVEpsData(id: String, ssnId: String, _ completion: @escaping (_ success: Bool, _ list: [AVEpsModel]) -> ()) {
        var para: [String: String] = [:]
        para[Mod_tv_show_id] = id
        para[Mod_tv_show_season_id] = ssnId
        
        NetManager.request(url: AVNetAPI.AVTvEpsApi.rawValue, method: .post, parameters: para, modelType: AVEpsModel.self) { responseModel in
            if let list = responseModel.models as? [AVEpsModel] {
                completion(responseModel.status == .success, list)
            } else {
                completion(false, [AVEpsModel()])
            }
        }
    }
    func AVTVSsnData(id: String, _ completion: @escaping (_ success: Bool, _ list: [AVInfoSsnlistModel]) -> ()) {
        var para: [String: String] = [:]
        para[Mod_tv_show_id] = id
        NetManager.request(url: AVNetAPI.AVTvSsnApi.rawValue, method: .post, parameters: para, modelType: AVInfoSsnlistModel.self) { responseModel in
            if let list = responseModel.models as? [AVInfoSsnlistModel] {
                completion(responseModel.status == .success, list)
            } else {
                completion(false, [AVInfoSsnlistModel()])
            }
        }
    }
}
