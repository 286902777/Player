//
//  AVModel.swift
//  HPlayer
//
//  Created by HF on 2024/4/3.
//

import Foundation
import HandyJSON

class apnsModel: BaseModel {
    var _id: String = ""
    var type: Int = 1
}

class AVEpsModel: BaseModel {
    var id: String = ""
    
    var video: String = ""
    
    var title: String = ""
    
    var eps_num: String = ""

    var isSelect: Bool = false

    var caption_list: [AVCaptionModel] = []
    
    var cover: String = ""
    
    var overview: String = ""
    
    var runtime: Int = 0
    
    var storage_timestamp: TimeInterval = 0
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &id, name: Mod_id)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &video, name: Mod_video)
        mapper.specify(property: &caption_list, name: Mod_caption_list)
        mapper.specify(property: &eps_num, name: Mod_eps_num)
        mapper.specify(property: &cover, name: Mod_cover)
        mapper.specify(property: &overview, name: Mod_overview)
        mapper.specify(property: &runtime, name: Mod_runtime)
        mapper.specify(property: &storage_timestamp, name: Mod_time)
    }
}

class AVModel: BaseModel {
    var id: String = ""
        
    var type: Int = 1
    
    var eps_id: String = ""
    
    var ssn_id: String = ""
    
    var eps_num: String = ""
    
    var ssn_name: String = ""
    
    var eps_name: String = ""

    var ssn_eps: String = ""
    
    var video: String = ""
    
    var title: String = ""
    
    var description: String = ""
    
    var pub_date: String = ""
    
    var country: String = ""
    
    var rate: String = ""
    
    var eps_list: [AVEpsModel] = []
    
    var ssn_list: [AVInfoSsnlistModel] = []

    var genre_list: [String] = []
        
    var cover: String = ""
    
    var uploadTime: String = ""
    
    var totalTime: Double = 0
    
    var playedTime: Double = 0
    
    var playProgress: Double = 0
    
    var dataSize: String = ""
    
    var updateTime: Double = 0
    
    var format: String = ""
    
    var quality: String = ""

    var isSelect: Bool = false

    var caption_list: [AVCaptionModel] = []

    var trailer: String = ""
    
    var images: [AVImageModel] = []
    
    var midCaptions: [AVCaption] {
        set {
            self.captions = newValue
        }
        get {
            var list: [AVCaption] = []
            for item in caption_list {
                let model = AVCaption()
                model.captionId = item.captionId
                model.name = item.name
                model.short_name = item.short_name
                model.display_name = item.display_name
                model.s3_address = item.s3_address
                list.append(model)
            }
            return list
        }
    }
    
    var captions: [AVCaption] = []
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &id, name: Mod_id)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &video, name: Mod_video)
        mapper.specify(property: &country, name: Mod_country)
        mapper.specify(property: &description, name: Mod_description)
        mapper.specify(property: &rate, name: Mod_rate)
        mapper.specify(property: &genre_list, name: Mod_genre_list)
        mapper.specify(property: &caption_list, name: Mod_caption_list)
        mapper.specify(property: &pub_date, name: Mod_pubDate)
        mapper.specify(property: &eps_num, name: Mod_eps_num)
        mapper.specify(property: &cover, name: Mod_cover)
        mapper.specify(property: &trailer, name: Mod_trailer)
        mapper.specify(property: &images, name: Mod_images)
    }
}

class AVImageModel: BaseModel {
    enum ModeType: Int, HandyJSONEnum {
        case horizontal
        case vertical
    }

    var url: String = ""
    var img_mode: ModeType = .horizontal
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &url, name: Mod_url)
        mapper.specify(property: &img_mode, name: Mod_img_mode)
    }
}


class AVCaptionModel: BaseModel {
    var captionId: String = ""
    
    var name: String = ""
        
    var short_name: String = ""
    
    var display_name: String = ""

    var s3_address: String = ""
    
    var local_address: String = ""
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &name, name: Mod_name)
        mapper.specify(property: &short_name, name: Mod_short_name)
        mapper.specify(property: &display_name, name: Mod_display_name)
        mapper.specify(property: &s3_address, name: Mod_s3_address)
    }
}

public class AVCaption: NSObject, NSSecureCoding{
    public static var supportsSecureCoding: Bool {
        return true
    }
    public var captionId: String = ""

    public var name: String = ""
    
    public var short_name: String = ""

    public var display_name: String = ""
    
    public var s3_address: String = ""
    
    public var local_address: String = ""
    
    public var isSelect: Bool = false
     // 编码成object
    public func encode(with coder: NSCoder) {
        coder.encode(captionId, forKey: "caption_id")
        coder.encode(name, forKey: "video_name")
        coder.encode(short_name, forKey: "short_name")
        coder.encode(display_name, forKey: "display_name")
        coder.encode(local_address, forKey: "local_address")
        coder.encode(s3_address, forKey: "s3_address")
    }
    
    public required init?(coder: NSCoder) {
        captionId = (coder.decodeObject(of: [NSString.self], forKey: "caption_id") as? String) ?? ""

        name = (coder.decodeObject(of: [NSString.self], forKey: "video_name") as? String) ?? ""
        short_name = (coder.decodeObject(of: [NSString.self], forKey: "short_name") as? String) ?? ""
        display_name = (coder.decodeObject(of: [NSString.self], forKey: "display_name") as? String) ?? ""
        local_address = (coder.decodeObject(of: [NSString.self], forKey: "local_address") as? String) ?? ""
        s3_address = (coder.decodeObject(of: [NSString.self], forKey: "s3_address") as? String) ?? ""
    }
    
    public override init() {
        super.init()
    }
}


class AVMoreModel: BaseModel {
    var id: String = ""
        
    var video: String = ""
    
    var title: String = ""
    
    var description: String = ""
            
    var rate: String = ""
    
    var genre_list: [String] = []
    
    var celebrity_list: [AVCastsModel] = []
    
    var cast: [IndexDataListModel] = []
    
    var related_list: [AVMoreListModel] = []
    
    var pub_date: String = ""
    
    var country: String = ""
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &id, name: Mod_id)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &video, name: Mod_video)
        mapper.specify(property: &description, name: Mod_description)
        mapper.specify(property: &rate, name: Mod_rate)
        mapper.specify(property: &genre_list, name: Mod_genre_list)
        mapper.specify(property: &celebrity_list, name: Mod_celebrity_list)
        mapper.specify(property: &related_list, name: Mod_list)
        mapper.specify(property: &cast, name: Mod_cast)
    }
}

class AVMoreListModel: BaseModel {
    var title: String = ""
    var data_list: [AVDataInfoModel] = []
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &data_list, name: Mod_data_list)
    }
}

class AVCastsModel: BaseModel {
    var cover = ""
    var name = ""
    var id = ""
    var detail = ""

    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &id, name: Mod_id)
        mapper.specify(property: &cover, name: Mod_cover)
        mapper.specify(property: &name, name: Mod_name)
        mapper.specify(property: &detail, name: Mod_detail)
    }
}

class AVInfoSsnlistModel: BaseModel {
    var id: String = ""
    var title: String = ""
    var cover: String = ""
    var isSelect: Bool = false
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        mapper.specify(property: &title, name: Mod_title)
        mapper.specify(property: &id, name: Mod_id)
        mapper.specify(property: &cover, name: Mod_cover)
    }
}

class AVSubtitleListModel: BaseModel {
    var subtitle: [AVSubtitleModel] = []
}

class AVDownloaderCaptionModel: BaseModel {
    var data: AVSubtitleListModel = AVSubtitleListModel()
}

class AVSubtitleModel: BaseModel {
    var sub = ""
    var l_display = ""
    var l_short = ""
    var t_name = ""
    var lang = ""
}

class PremiuModel: BaseModel {
    var auto_renew_status: String {
        return entity.pending_renewal_info.first?.auto_renew_status ?? "0"
    }
    var entity: PremiuEntityModel = PremiuEntityModel()
    var expires_date_ms: TimeInterval {
        return entity.latest_receipt_info.first?.expires_date_ms ?? 0
    }
    var product_id: String {
        return entity.latest_receipt_info.first?.product_id ?? ""
    }
    var checks: [String] = []
}

class PremiuEntityModel: BaseModel {
    var receipt = ""
    var environment = ""
    var status = 0
    var latest_receipt_info: [ReceiptInfo] = []
    var device_id = ""
    var ok: Bool = false
    var pending_renewal_info: [RenewalInfo] = []
}

class ReceiptModel: BaseModel {
    var version_external_identifier = 0
    var receipt_creation_date = ""
    var receipt_creation_date_ms: TimeInterval = 0
    var receipt_creation_date_pst = ""
    var adam_id = 0
    var app_item_id = 0
    var in_app: [ReceiptInfo] = []
    var bundle_id = ""
    var application_version = ""
    var download_id = 0
    var original_purchase_date_ms: TimeInterval = 0
    var original_purchase_date = ""
    var request_date = ""
    var receipt_type = ""
    var original_purchase_date_pst = ""
    var original_application_version = ""
    var request_date_ms: TimeInterval = 0
    var request_date_pst = ""
}

class ReceiptInfo: BaseModel {
    var transaction_id = ""
    var original_transaction_id = ""
    var quantity = ""
    var product_id = ""
    var is_trial_period = ""
    var is_in_intro_offer_period = ""
    var original_purchase_date_pst = ""
    var expires_date_ms: TimeInterval = 0
    var expires_date = ""
    var expires_date_pst = ""
    var web_order_line_item_id = ""
    var subscription_group_identifier = ""
    var in_app_ownership_type = ""
    var purchase_date_pst = ""
    var original_purchase_date_ms: TimeInterval = 0
    var original_purchase_date = ""
    var purchase_date_ms: TimeInterval = 0
    var purchase_date = ""
}

class RenewalInfo: BaseModel {
    var auto_renew_status = ""
    var original_transaction_id = ""
}

