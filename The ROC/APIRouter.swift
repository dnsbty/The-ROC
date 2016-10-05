//
//  APIRouter.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/26/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import Foundation
import Alamofire

public enum Router : URLRequestConvertible {
    static let baseURLString = "https://api.therocapp.com"
    
    case registerForNotifications(String)
    case schedule()
    
    public func asURLRequest() throws -> URLRequest {
        let result: (path: String, method: HTTPMethod, parameters: Parameters?) = {
            switch self {
            case let .registerForNotifications(token):
                let params = ["token": token, "type": "ios"]
                return ("/devices/", .post, params)
            case .schedule():
                return ("/json/schedule.json", .get, nil)
            }
        }()
        
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = result.method.rawValue
        urlRequest.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
