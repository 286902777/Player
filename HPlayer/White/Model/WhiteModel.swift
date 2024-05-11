//
//  WhiteModel.swift
//  HPlayer
//
//  Created by HF on 2024/5/11.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import Foundation
import HandyJSON

enum IndexDataType: Int {
    case banner
    case list
    case people
}
class IndexModel: BaseModel {
    var title: String = ""
    var type: IndexDataType = .banner
    var data: [IndexDataModel] = []
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &data, name: Mod_data)
    }
}

class IndexDataModel: BaseModel {
    enum TimeType: String, HandyJSONEnum {
        case today = "Today"
        case week = "This week"
    }
    var title: TimeType = .today
    var data_list: [IndexDataListModel] = []
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &data_list, name: Mod_data_list)
    }
}
class IndexDataListModel: BaseModel {
    enum GenderType: Int, HandyJSONEnum {
        case girl = 1
        case boy
    }
    var id: String = ""
            
    var title: String = ""
    
    var cover: String = ""

    var rate: String = ""

    var type: Int = 1
    
    var horizontal_cover: String = ""
    
    var storage_timestamp: TimeInterval = 0

    var name: String = ""
    var gender: GenderType = .girl
    var biography: String = ""
    var birthday: String = ""
    var place_of_birth: String = ""
    var isLike: Bool = false
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &id, name: Mod_id)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &cover, name: Mod_cover)
        mapper.specify(property: &rate, name: Mod_rate)
        mapper.specify(property: &type, name: Mod_type)
        mapper.specify(property: &horizontal_cover, name: Mod_horizontal_cover)
        mapper.specify(property: &storage_timestamp, name: Mod_time)
        mapper.specify(property: &name, name: Mod_name)
        mapper.specify(property: &gender, name: Mod_gender)
        mapper.specify(property: &biography, name: Mod_biography)
        mapper.specify(property: &birthday, name: Mod_birthday)
        mapper.specify(property: &place_of_birth, name: Mod_place_of_birth)
    }
}
