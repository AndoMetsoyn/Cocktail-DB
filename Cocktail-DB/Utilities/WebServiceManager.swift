//
//  WebServiceManager.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/26/21.
//

import Foundation
import Moya



enum ApiInfo {
    case categories
    case categoryFilter(category: String)
}

extension ApiInfo: TargetType {
    var baseURL: URL {
        return ApiEnvironment.startingURL.baseURL
    }
    
    var path: String {
        switch self {
            case .categories:
                return "list.php"
            case .categoryFilter:
                return "filter.php"
        }
    }
    
    //MARK: - method
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameters: [String: Any] {
        switch self {
        case .categories:
            return ["c": "list"]
        case .categoryFilter(let category):
            return ["c": category]
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: self.parameters, encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

struct NetworkAdapter {
    static let provider = MoyaProvider<ApiInfo>()
    
    static func request(target: ApiInfo, success successCallback: @escaping (Response) -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (String) -> Void) {
        
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    successCallback(response)
                } else {
                    let error = NSError(domain:"com.haba.networkLayer", code:0, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"])
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback("error \(error.localizedDescription)")
            }
        }
    }
}
