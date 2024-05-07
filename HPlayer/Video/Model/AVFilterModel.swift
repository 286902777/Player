//
//  AVFilterModel.swift
//  HPlayer
//
//  Created by HF on 2023/12/29.
//

import Foundation
import HandyJSON

class AVFilterCategoryModel: BaseModel {
    var type_list: [String] = ["All", "Movies", "TV Series"]
    var genre_list:[String] = []
    var year_list:[String] = []
    var country_list:[String] = []
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &genre_list, name: Mod_genre_list)
        mapper.specify(property: &year_list, name: Mod_year_list)
        mapper.specify(property: &country_list, name: Mod_country_list)
    }
}

class AVFilterCategoryInfoModel: BaseModel {
    var title: String = ""
    var width: CGFloat {
        get {
            let w = title.getStrW(font: .systemFont(ofSize: 17), h: 20)
            return max(w, 40)
        }
    }
    var isSelect: Bool = false
}
