//
//  HGNetwork.swift
//  MLC
//
//  Created by 黄刚 on 2019/12/4.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

import UIKit
//MARK: -- 第三种方法(RxSwift 结合 Moya)
/*
extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    func map<T: ImmutableMappable>(_ type: T.Type) -> PrimitiveSequence<TraitType, T> {
           return self
               .map { (response) -> T in
                 let json = try JSON(data: response.data)
                 guard let code = json[RESULT_CODE].int else { throw RequestError.noCodeKey }
                 if code != StatusCode.success.rawValue { throw RequestError.sysError(statusCode:"\(code)" , errorMsg: json[RESULT_MESSAGE].string) }
                if let data = json[RESULT_DATA].dictionaryObject {
                    return try Mapper<T>().map(JSON: data)
                }else if let data = json[RESULT_RESULT].dictionaryObject {
                    return try Mapper<T>().map(JSON: data)
                }
                 throw RequestError.noDataKey
            }.do(onSuccess: { (_) in
                
            }, onError: { (error) in
                if error is MapError {
                    log.error(error)
                }
            })
        }
}

 
//外界调用
loginService.login().asObservable()
    .subscribe(onNext: {[weak self] (rcmdBranchModel) in
        
        guard let `self` = self else { return }
        self.requestIds = rcmdBranchModel.tab.map{$0.id}
        self.menuTitles += rcmdBranchModel.tab.map{$0.name}
        self.pageController.magicView.reloadData(toPage: 1)
    }).disposed(by: disposeBag)

*/















//MARK: -- 第二种网络请求方法(直接使用Moya)

//初始化请求的provider
let NetProvider = MoyaProvider<NetRequestAPI>()

/**定义请求的endpoints（供provider使用）**/
public enum NetRequestAPI {
    case channels                        //获取频道接口
    case playlist(String)                //获取歌曲接口
    case otherRequest                   // 其他接口,没有参数
}


//请求配置
/*
 baseURL：服务器地址host 处理
 path：根据不同的接口，确定各个请求的具体路径
 method：根据不同的接口，设置请求方式
 headers：统一配置的请求头信息配置
 task：配置内部参数，以及task信息
 */
extension NetRequestAPI: TargetType {
    
    //服务器地址
    public var baseURL: URL {
        switch self {
        case .channels:
            return URL(string: "https://www.douban.com")!
            
        case .playlist(_):
            return URL(string: "https://douban.fm")!
        case .otherRequest:
            return URL(string: "https://douban.fm/default.html")!
        }

    }
    
    // 各个请求的具体路径
    public var path: String {
        switch self {
        case .channels:
            return "/j/app/radio/channels"
            
        case .playlist(_):
            return "/j/mine/playlist"
            
        case .otherRequest:
            return "/default/otherRequest"
        }
    }
    
    
    //请求方式
    public var method: Moya.Method {
        switch self {
        case .channels:
            return .get
            
        case .playlist(_):
            return .get
            
        default:
            return .post
        }
    }
    
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        var param: [String: Any] = [:]
        switch self {
        case .playlist(let channel):
            param["channel"] = channel
            param["type"] = "n"
            param["from"] = "mainsite"
            break
        
        case .channels: break
            
        case .otherRequest:
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: URLEncoding.default)
    }
    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    //做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8, allowLossyConversion: true)!
    }
    
    //请求头设置
    public var headers: [String : String]? {
        return nil
    }
    
}


/*
 MoyaProvider 是此次网络请求的信息提供者
 MoyaProvider 根据模块 NetRequestAPI 设置的信息绑定数据请求
 MoyaProvider 通过调用 request 方法传出此次请求的接口，但是参数需要应用层提供！
 获取回调信息，然后进行 json 序列化!
 最后利用函数式编程思想回调 携带信息的闭包 给应用层
 */

//登录模块管理
class LoginViewModel: NSObject {
    static let manager = LoginViewModel()
    
    //验证码事件
    func getChannel(username: String?, complete:@escaping((Any)-> Void)) {
        let provider = MoyaProvider<NetRequestAPI>()
        
        provider.request(.channels) { (result) in
            switch result {
            case let .success(response):
                let dict = JSON(response.data)
                complete(dict)
                
            case let .failure(error):
                print(error)
                complete("")
            }
        }
    }
}


 
 





/*
//MARK: -- 第一种网络请求方法
//MARK: -- 网络信息能力
enum HGHTTPMethod: String {
    case GET
    case POST
}

protocol HGRequest {
    var host: String { get set }    //协议属性只读
    var path: String { get }
    var method: HGHTTPMethod { get }
    var parameter: [String: Any] { get }
    
    associatedtype Response
    func parse(data: Data) -> Response?
    
}

class HGPerson: NSObject {
    init(data: Data) {
        
    }
}

//MARK: -- 模块信息层
struct HGLoginRequest: HGRequest {
    typealias Response = HGPerson
    let name: String
    
    var host = "http://127.0.0.1:5000"
    var path: String {
        return "/pythonJson/getTeacherInfo/?username=\(name)"
    }
    let method: HGHTTPMethod = .GET
    let parameter: [String : Any] = [:]
    
    func parse(data: Data) -> HGPerson? {
        return HGPerson(data: data)
    }
}


//MARK: -- 网络请求能力
extension HGRequest {
    mutating func send(handler: @escaping (Response?) -> Void) -> Void {
        host.append(path)
        let url = URL(string: host)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
//            if let data = data, let res = self.parse(data: data) {
//                DispatchQueue.main.async {
//                    handler(res)
//                }
//            }else {
//                DispatchQueue.main.async { handler(nil) }
//            }
        }
        
        task.resume()
    }
}

class HGNetwork: NSObject {
    
    

}
*/
