//
//  BaseModel.swift
//  HPlayer
//
//  Created by HF on 2024/1/8.
//

import HandyJSON

protocol BaseModelProtocol: HandyJSON {

}

class BaseModel: HandyJSON {
    required init() {}
    func mapping(mapper: HelpingMapper) {

    }
}
