//
//  AVHomeModel.swift
//  HPlayer
//
//  Created by HF on 2024/1/3.
//

import Foundation
import HandyJSON

class AVHomeModel: BaseModel {
    var id: String = ""
    var name: String = ""
    var type: Int = 1
    var m20: [AVDataInfoModel] = []
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &id, name: Mod_id)
        mapper.specify(property: &name, name: Mod_topic)
        mapper.specify(property: &type, name: Mod_type)
        mapper.specify(property: &m20, name: Mod_list)
    }
}

class AVSearchTopDataModel: BaseModel {
    var title: String = ""
    var data_list: [AVDataInfoModel] = []
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &data_list, name: Mod_data_list)
    }
}

class AVDataInfoModel: BaseModel {
    var id: String = ""
    var rate: String = ""
    var title: String = ""
    var cover: String = ""
    var horizontal_cover: String = ""
    var storage_timestamp: TimeInterval = 0
    var quality: String = ""
    var type: Int = 1
    var order: String = ""
    var stars: String = ""
    var views: String = ""
    var pub_date: String = ""
    var gif: String = ""
    var description: String = ""
    var c_cnts: String = ""
    var medit: Int = 0
    var data_type: String = ""
    var eps_cnts: String = ""
    var ssn_id: String = ""
    var ssn_eps: String = ""
    var eps_list: [String] = []
    var eps_id: String = ""
    var country: String = ""
    var ss_eps: String = ""
    var new_flag: String = ""
    var nw_flag: String = ""
    var best: String = ""
    var sub: String = ""
    var dub: String = ""
    var ep: String = ""
    var age: String = ""
    var video_flag: String = ""
    var playProgress: Double = 0
    var isSelect: Bool = false
    var isDelete: Bool = false
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &id, name: Mod_id)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &cover, name: Mod_cover)
        mapper.specify(property: &horizontal_cover, name: Mod_horizontal_cover)
        mapper.specify(property: &rate, name: Mod_rate)
        mapper.specify(property: &quality, name: Mod_quality)
        mapper.specify(property: &type, name: Mod_type)
        mapper.specify(property: &storage_timestamp, name: Mod_time)
    }
}

