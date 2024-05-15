//
//  NetManager.swift
//  HPlayer
//
//  Created by HF on 2024/4/11.
//

import Foundation
import Alamofire
import HandyJSON

enum NetworkResponse<T> {
    case success(_ object: T?)
    case failure(_ error: Swift.Error)
}
typealias OptionResponseBlock<T> = (NetworkResponse<T>) -> ()

enum ResponseError: Int {
    case    unkown      =    0
    case    success     =   200
    case    failure     =   500
    case    expaired    =   401
    case    beOffLine   =   402
}

protocol RequestBaseParam :Encodable{
    var page        :   Int { get }
    var limit       :   Int {get}
}

protocol ResponseBaseParam: BaseModel{
    
    var total       :   Int?{ get }
    var per_page    :   Int?{ get }
    var curent_page :   Int{ get set }
    var last_page   :   Int?{ get }
}

struct ResponseDefault: HandyJSON {}

struct ResponseData: HandyJSON{
    var code    :   Int?
    var msg     :   String?
    var data    :   Any?
}

struct ResponseModel<T:HandyJSON>{
    var status          :   ResponseError = .unkown
    var errorMessage    :   String = "network connection failed"
    var model           :   T?
    var models          :   [T?]?
    var resultData      :   Any?
}

class NetManager {
    static let share: NetManager = NetManager()

    var contentType: String = "application/x-www-form-urlencoded"
    
    /// 接口地址
#if DEBUG
    let Host: String = "https://test.movietrackiosapp.com/"
#else
    let Host: String = "https://prod.movietrackiosapp.com/"
#endif
        
    /// 参数编码方式
    let ParameterEncoder : ParameterEncoder = URLEncodedFormParameterEncoder.default
}

extension NetManager{
    
    fileprivate class func InitDataRequest<Parameters: Encodable>(url:String,
                                                                  method:HTTPMethod = .post,
                                                                  parameters:Parameters? = nil
    ) -> DataRequest{
        var headers : HTTPHeaders = HTTPHeaders()
        
        headers.add(name: Head_bundleId, value: HPConfig.SafeBUNDLEID)
        headers.add(name: Head_uuid, value: HPConfig.share.getDistinctId())
        headers.add(name: Head_version, value: HPConfig.app_version)

        let encoder : ParameterEncoder = NetManager.share.ParameterEncoder
        let requestUrl = url.jointHost()

        let request : DataRequest = AF.request(requestUrl, method: method, parameters: parameters, encoder: encoder, headers: headers, interceptor: nil, requestModifier: { $0.timeoutInterval = 15 })
        return request
    }
}

typealias ResponseBlock<T:HandyJSON> = (_ responseModel:ResponseModel<T>) -> ()

extension NetManager{
    ///可无参数，无模型数据返回
    class func request(url:String,
                       method:HTTPMethod = .post,
                       parametersDic:[String:String]? = [:],
                       resultBlock:ResponseBlock<ResponseDefault>?){
        self.request(url: url, method: method, parametersDic: parametersDic, modelType: ResponseDefault.self, resultBlock: resultBlock)
    }
    /// 可无参数
    class func request<T:HandyJSON>(url:String,
                                    method:HTTPMethod = .post,
                                    parametersDic:[String:String]? = [:],
                                    modelType:T.Type,
                                    resultBlock:ResponseBlock<T>?){
        self.request(url: url, method: method, parameters: parametersDic, modelType: modelType, resultBlock: resultBlock)
    }
    /// 无模型数据返回
    class func request<Parameters: Encodable>(url:String,
                                              method:HTTPMethod = .post,
                                              parameters:Parameters,
                                              resultBlock:ResponseBlock<ResponseDefault>?){
        self.request(url: url, method: method, parameters: parameters, modelType: ResponseDefault.self, resultBlock: resultBlock)
    }
    
    /// 数据模型返回
    class func request<T:HandyJSON,Parameters: Encodable>(url:String,
                                                          method:HTTPMethod = .post,
                                                          parameters:Parameters,
                                                          modelType:T.Type,
                                                          resultBlock:ResponseBlock<T>?)
    {
        NetManager.InitDataRequest(url: url, method: method, parameters: parameters)
            .responseString { string in
                self.response(modelType, string.value, resultBlock)
            }
    }
    
    class func requestSearch(url: String, method:HTTPMethod = .get,
                          parameters: [String:String]? = [:], resultBlock: @escaping (String) ->()) {
        NetManager.InitDataRequest(url: url, method: .get ,parameters: parameters)
            .responseString { string in
                resultBlock(string.value ?? "")
            }
    }
    

    class func cancelAllRequest() {
        AF.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    fileprivate class func response<T:HandyJSON>
    (
        _ modelType:T.Type,
        _ responseData:String?,
        _ resultBlock:ResponseBlock<T>?
    ){
        guard let resultBlock = resultBlock else {
            return
        }
        guard modelType != ResponseDefault.self else {
            return
        }
        var responseModel = ResponseModel<T>()
        let baseModel = ResponseData.deserialize(from: NetManager.share.codeToJson(responseData))
        
        guard let baseModel = baseModel else {
            return resultBlock(responseModel)
        }
        responseModel.status = ResponseError(rawValue: baseModel.code ?? 0) ?? .unkown
        if let _ = baseModel.msg{
            responseModel.errorMessage = baseModel.msg!
        }
        responseModel.resultData = baseModel.data
        
        // 当被转模型数据不存在,停止转模型.
        guard let data = baseModel.data else {
            return resultBlock(responseModel)
        }
        if let dataArr = data as? [Any]{          // 解析数组
            responseModel.models = [T].deserialize(from: dataArr)
            return resultBlock(responseModel)
        }
        else if let data = data as? [String : Any]{     //解析字典
            responseModel.model = T.deserialize(from: data)
            return resultBlock(responseModel)
        }
        else{   //原样返回Data数据
            return resultBlock(responseModel)
        }
    }
    
    fileprivate func codeToJson(_ text: String?) -> String? {
//        if let str = text, str.count > 42 {
//            let s = str.substring(to: str.count - 42)
//            let result = s.map({$0.isUppercase ? $0.lowercased() : $0.uppercased()})
//            let data = Data(base64Encoded: String(result.joined())) ?? Data()
//            let json = String(data: data, encoding: String.Encoding.utf8)
//            return json
//        }
        if let str = text, str.count > 5 {
            let s = str.substring(from: 5)
            let data = Data(base64Encoded: String(s.reversed())) ?? Data()
            let json = String(data: data, encoding: String.Encoding.utf8)
            return json
        }
        return nil
    }
}

extension String{
    fileprivate func jointHost() -> String{
        let host = NetManager.share.Host
        guard !self.isEmpty else {
            return host
        }
        guard !self.contains("http") else {
            return self
        }
        return host + self
    }
}
