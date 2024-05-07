//
//  HPKey.swift
//  HPlayer
//
//  Created by HF on 2024/1/3.
//

import Foundation

let Head_bundleId = "apbdh"
let Head_uuid = "auufz"
let Head_version = "fhpm"

let Para_topicId = "ahlWkGlkmc"
let Para_page = "AGZD"
let Para_pageSize = "wCAwERZk"
let Para_fuzzy_match = "wsmRLRwgT"

let Mod_id = "pGWTQSachU"
let Mod_topic = "yRC"
let Mod_topicId = "ahlWkGlkmc"
let Mod_title = "sIZNe"
let Mod_cover = "itmOlze"
let Mod_horizontal_cover = "KiGSV"
let Mod_rate = "HXNnDWwh"
let Mod_quality = "tzPd"
let Mod_type = "eoiOvwB"
let Mod_time = "zQukdR"
let Mod_name = "YjvhnCLwjQ"
let Mod_list = "lPpzBuLr"
let Mod_pubDate = "XlvguzG"
let Mod_eps_num = "GLNLM"
let Mod_short_name = "hRx"
let Mod_display_name = "tmow"
let Mod_s3_address = "OfgiUMmRw"
let Mod_tv_show_id = "UQG"
let Mod_tv_show_season_id = "AOxbN"

let Mod_celebrity_list = "pQAVRsTqg"
let Mod_genre_list = "eNTV"
let Mod_year_list = "NUHyZQq"
let Mod_country_list = "WQUSU"
let Mod_caption_list = "wGdcRLxf"

let Mod_genre = "kmKXPDHJ"
let Mod_year = "yxOdFSb"
let Mod_country = "hFBQyi"

let Mod_data_list = "NSVHoWHs"
let Mod_detail = "NiHkWzM"
let Mod_video = "rZBdd"
let Mod_description = "LgghDQW"

class HPKey {
    static let isUser = "isUser"
    static let isVip = "isVip"
    
    static let email = "mihayescwtu@hotmail.com"
    
    static let app_version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static let HPLogs = "HPLogs"
    static let lastIpCountryCode = "last_ip_country_code"
    static let lastIp = "lastIp"
    static let advertiseKey = "advertiseKey"
    static let history = "history"
    static let appOpen = "appOpen"
    
    static let product_id = "product_id"
    static let expires_date_ms = "expires_date_ms"
    static let auto_renew_status = "auto_renew_status"
    
    static let install = "install"
    
    static let Noti_NetStatus = NSNotification.Name(rawValue: "netStatus")
    static let Noti_CcRefresh = NSNotification.Name(rawValue: "captionRefresh")
    static let Noti_VipStatusChange = NSNotification.Name(rawValue: "vipStatusChange")
    static let Noti_CaptionRefresh = NSNotification.Name(rawValue: "captionRefresh")
    static let Noti_PushAPNS = NSNotification.Name(rawValue: "PushAPNS")
}
