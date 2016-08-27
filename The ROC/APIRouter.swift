//
//  APIRouter.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/26/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import Foundation
import Alamofire

public enum APIRouter: URLRequestConvertible {
    static let baseURL = "https://api.therocapp.com"
    
    case Schedule()
    
    public var URLRequest : NSMutableURLRequest {
        let result : (path: String, method: Alamofire.Method, parameters: [String: AnyObject]?) = {
            switch self {
            case .Schedule():
                return("/json/schedule.json", .GET, nil)
            }
        }()
        
        let URL = NSURL(string: APIRouter.baseURL)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        URLRequest.HTTPMethod = result.method.rawValue
        URLRequest.timeoutInterval = NSTimeInterval(10 * 1000)
        
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: result.parameters).0
    }
}
