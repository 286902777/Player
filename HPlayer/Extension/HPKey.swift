//
//  HPKey.swift
//  HPlayer
//
//  Created by HF on 2024/4/15.
//

import Foundation

let Head_bundleId = "yzihm"
let Head_uuid = "cmc"
let Head_version = "iko"

let Para_topicId = "UOYbnwn"
let Para_page = "nediheRH"
let Para_pageSize = "VVJKPoNklW"
let Para_fuzzy_match = "xKKPHEZl"

let Mod_id = "ngpk"
let Mod_data = "qKcZ"
let Mod_topic = "vss"
let Mod_topicId = "UOYbnwn"
let Mod_title = "tZrmkgg"
let Mod_cover = "VWesjzMPC"
let Mod_horizontal_cover = "rFoiXTkkY"
let Mod_rate = "CyzldAhybr"
let Mod_quality = "XMoar"
let Mod_type = "vUXnW"
let Mod_time = "sQWic"
let Mod_name = "gXzHdjfDz"
let Mod_list = "Bcl"
let Mod_pubDate = "nejFYg"
let Mod_eps_num = "DfcEuQ"
let Mod_short_name = "eBuaxvIeH"
let Mod_display_name = "JzpTBDo"
let Mod_s3_address = "qcfynM"
let Mod_tv_show_id = "mxxHVxi"
let Mod_tv_show_season_id = "GnHWEP"

let Mod_celebrity_list = "TXsNFa"
let Mod_genre_list = "JRGfYemI"
let Mod_year_list = "bIr"
let Mod_country_list = "uEyTN"
let Mod_caption_list = "itNJPwFCJ"

let Mod_genre = "mWq"
let Mod_year = "SsKXZGa"
let Mod_country = "aMobJm"

let Mod_data_list = "kEDkCaYJco"
let Mod_detail = "wTeSPaz"
let Mod_video = "PUmd"
let Mod_description = "qaZwgBhxf"
let Mod_gender = "DdQVoTVn"
let Mod_biography = "itQhqkmWH"
let Mod_birthday = "CPouuFULWi"
let Mod_place_of_birth = "hcSA"

class HPKey {
    static let privacy = "privacy"
    static let terms = "terms"
    static let APPID = "6474994352"
    static let isUser = "isUser"
    static let isVip = "isVip"
    
    static let email = "slihacwtu@hotmail.com"
    
    static let app_version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static let HPLogs = "HPLogs"
    static let advertiseKey = "advertiseKey"
    static let history = "history"
    static let searchRecord = "searchRecord"

    static let appOpen = "appOpen"
    
    static let product_id = "product_id"
    static let expires_date_ms = "expires_date_ms"
    static let auto_renew_status = "auto_renew_status"
    
    static let install = "install"
    
    static let Noti_NetStatus = NSNotification.Name(rawValue: "netStatus")
    static let Noti_CcRefresh = NSNotification.Name(rawValue: "captionRefresh")
    static let Noti_VipStatusChange = NSNotification.Name(rawValue: "vipStatusChange")
    static let Noti_CaptionRefresh = NSNotification.Name(rawValue: "captionRefresh")
    static let Noti_PushAPNS = NSNotification.Name(rawValue: "pushAPNS")
    static let Noti_Like = NSNotification.Name(rawValue: "clickLike")

}
