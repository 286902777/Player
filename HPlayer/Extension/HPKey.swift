//
//  HPKey.swift
//  HPlayer
//
//  Created by HF on 2024/4/15.
//

import Foundation

let Head_bundleId = "phy"
let Head_uuid = "sujql"
let Head_version = "neftj"

let Para_topicId = "FZRrXq"
let Para_page = "vonXQ"
let Para_pageSize = "UClFAE"
let Para_fuzzy_match = "gKCIbgpv"

let Mod_id = "lYNV"
let Mod_data = "thJgsU"
let Mod_topic = "CLrMwgFIS"
let Mod_topicId = "FZRrXq"
let Mod_title = "VKPVUuH"
let Mod_cover = "zXb"
let Mod_horizontal_cover = "CwDUWxh"
let Mod_rate = "BgRBswKXCf"
let Mod_quality = "NTPltSnHN"
let Mod_type = "GRfAslp"
let Mod_time = "iJLJDwvY"
let Mod_name = "qshY"
let Mod_list = "tfruGLL" // related_list
let Mod_pubDate = "VIrbZoqwd"
let Mod_eps_num = "YErZX"
let Mod_short_name = "ajIRUb"
let Mod_display_name = "OJbxsRrg"
let Mod_s3_address = "MQbZwk"
let Mod_tv_show_id = "sKkGpajzf"
let Mod_tv_show_season_id = "pTGbi"

let Mod_celebrity_list = "LOcnDnUk"
let Mod_genre_list = "AvqHyZDM"
let Mod_year_list = "dHEmcl"
let Mod_country_list = "iPzMdwg"
let Mod_caption_list = "WOQ"

let Mod_genre = "yifHX"
let Mod_year = "xvmIon"
let Mod_country = "zmPsBpR"

let Mod_data_list = "LsXpRNPt"
let Mod_detail = "iAob"
let Mod_video = "Fgljuy"
let Mod_description = "RQL"
let Mod_gender = "DFDIZsnE"
let Mod_biography = "iMKdh"
let Mod_birthday = "riBGgvE"
let Mod_place_of_birth = "WJnceDF"
let Mod_trailer = "DaVISHE"
let Mod_images = "OUrNxse"
let Mod_url = "HfRKFhWol"
let Mod_img_mode = "DfYBlpMF"
let Mod_cast = "TDKBBooA"
let Mod_overview = "ggtvcQ"
let Mod_runtime = "LqFRJV"

class HPKey {
    static let privacy = "https://movietrackiosapp.com/privacy/"
    static let terms = "https://movietrackiosapp.com/terms/"
    static let gHostUrl = "https://suggestqueries.google.com/complete/search?client=firefox&hl=en&q="
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
