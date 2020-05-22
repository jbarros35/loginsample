//
//  RESTClient.swift
//  loxy4-arch
//
//  Created by Jose on 04/06/2018.
//  Copyright © 2018 SatcomInt. All rights reserved.
//

import UIKit
import Alamofire

extension String: ParameterEncoding {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - urlRequest: <#urlRequest description#>
    ///   - parameters: <#parameters description#>
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

/// <#Description#>
public enum Router {
    
    case users
    case wrongPath
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func asURL() throws -> String {
        var relative: String
        switch self {
            case .users: relative = "/users"
            case .wrongPath: relative = ""
        }
        let urlString = "\(relative)"
        return urlString
    }
}

/// <#Description#>
///
/// - GET: <#GET description#>
/// - PUT: <#PUT description#>
/// - POST: <#POST description#>
/// - DELETE: <#DELETE description#>
public enum Method: String {
    case GET
    case PUT
    case POST
    case DELETE
}

// MARK: common service errors mapping that can be thrown based on HTTP status
/// <#Description#>
///
/// - BadRequest: <#BadRequest description#>
/// - InternalError: <#InternalError description#>
/// - UnAuthorized: <#UnAuthorized description#>
/// - NotFound: <#NotFound description#>
/// - Success: <#Success description#>
/// - 400:returnRESTError.BadRequest: <#400:returnRESTError.BadRequest description#>
/// - 401:returnRESTError.UnAuthorized: <#401:returnRESTError.UnAuthorized description#>
/// - 500:returnRESTError.InternalError: <#500:returnRESTError.InternalError description#>
/// - 404:returnRESTError.NotFound: <#404:returnRESTError.NotFound description#>
/// - "unauthorized":returnRESTError.UnAuthorized: <#"unauthorized":returnRESTError.UnAuthorized description#>
/// - "invalid_token":returnRESTError.UnAuthorized: <#"invalid_token":returnRESTError.UnAuthorized description#>
/// - "BadRequest":returnRESTError.BadRequest: <#"BadRequest":returnRESTError.BadRequest description#>
public enum RESTError: Error {
    case BadRequest(String, [String]?)
    case InternalError(String)
    case UnAuthorized(String, [String]?)
    case NotFound(String)
    case Success
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - code: <#code description#>
    ///   - message: <#message description#>
    ///   - globalErrors: <#globalErrors description#>
    /// - Returns: <#return value description#>
    public static func fromCode(code: Int, message: String, globalErrors: [String]? = nil) -> RESTError {
        switch code {
            case 400: return RESTError.BadRequest(message, globalErrors)
            case 401: return RESTError.UnAuthorized(message, globalErrors)
            case 500: return RESTError.InternalError(message)
            case 404: return RESTError.NotFound(message)
            default: break
        }
        return RESTError.Success
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - code: <#code description#>
    ///   - message: <#message description#>
    ///   - globalErrors: <#globalErrors description#>
    /// - Returns: <#return value description#>
    public static func fromCode(code: String, message: String, globalErrors: [String]? = nil) -> RESTError {
        switch code {
            case "unauthorized": return RESTError.UnAuthorized(message, globalErrors)
            case "invalid_token": return RESTError.UnAuthorized(message, globalErrors)
            case "Bad Request": return RESTError.BadRequest(message, globalErrors)
            default: return RESTError.InternalError(message)
        }
    }
}

/// <#Description#>
public class RESTClient: NSObject {
    
    public typealias Parameters = [String: Any]
    public static let shared = RESTClient()
    // MARK: authentication headers
    public var header: Dictionary<String, String>?
    public var preValidation: ((URLRequest, @escaping (URLRequest?)->()) -> ())?
    public var refreshToken: ((URLRequest, @escaping ([String : AnyObject])->(), @escaping ((RESTError) -> ())) -> ())?
    private override init() {}
    public var serverEndpoint: String? = {
        return Utils.readInfoVar(key: "server_endpoint") as? String
    }()
    public var timeOut: Double = 60.0
    // https://jsonplaceholder.typicode.com
    
    // REMARK: make post, optional parameters or body string.
    ///
    /// - Parameters:
    ///   - urlRequest: <#urlRequest description#>
    ///   - errorHandler: <#errorHandler description#>
    ///   - handler: <#handler description#>
    public func alamofireRequest(_ urlRequest: URLRequest, _ errorHandler: @escaping (RESTError) -> (), _ handler: @escaping (Any?) -> ()) {
        Alamofire.request(urlRequest)
            .validate(statusCode: 200...500)
            .responseJSON(completionHandler: { (response: (DataResponse<Any>)) in
                if let statusCode = response.response?.statusCode {
                    if statusCode != 200 {
                        // call handler errors function with specific message
                        if let arrayDictionary = response.result.value as? Dictionary<String,AnyObject> {
                            var error: RESTError?
                            if let code = arrayDictionary["status"] as? Int {
                                let message = arrayDictionary["message"] as? String ?? "<no message>"
                                let globalErrors = arrayDictionary["globalErrors"] as? [String]
                                error = RESTError.fromCode(code: code, message: message, globalErrors: globalErrors)
                            } else {
                                // Build from error message without code.
                                let message = arrayDictionary["error_description"] as! String
                                let codeMsg = arrayDictionary["error"] as! String
                                let globalErrors = arrayDictionary["globalErrors"] as? [String]
                                if codeMsg == "invalid_token" && message.starts(with: "Access token expired") {
                                    #if DEBUG
                                    print("token expired, refreshing")
                                    #endif
                                    self.refreshToken?(urlRequest, handler, errorHandler)
                                    return
                                } else {
                                    error = RESTError.fromCode(code: codeMsg, message: message, globalErrors: globalErrors)
                                }
                            }
                            if let _ = error {
                                errorHandler(error!)
                            } else {
                                errorHandler(RESTError.InternalError("Internal API rest error."))
                            }
                        } else {
                            errorHandler(RESTError.fromCode(code: statusCode, message: ""))
                        }
                    } else {
                        handler(response.result.value)
                    }
                } else {
                    if let error = response.error {
                        errorHandler(RESTError.InternalError(error.localizedDescription))
                    }
                }
            })
        
    }
    /// Requests for LOXY backend
    ///
    /// - Parameters:
    ///   - route: <#route description#>
    ///   - parameters: <#parameters description#>
    ///   - queryString: <#queryString description#>
    ///   - body: <#body description#>
    ///   - method: <#method description#>
    ///   - handler: <#handler description#>
    ///   - errorHandler: <#errorHandler description#>
    /// - Throws: <#throws value description#>
    public func makeRequest(route: Router..., parameters: Parameters? = nil, queryString: String? = nil, body: String? = nil, method: Method? = .POST, handler: @escaping (Any?) -> (), errorHandler: @escaping (RESTError) -> ()) throws {
        do {
            var url = serverEndpoint
            route.forEach({
                do {
                    try url!.append($0.asURL())
                } catch {
                    print("Invalid route url \(error)")
                }
            })
            if let query = queryString {
                url = "\(url!)?query=\(query)"
            }
            var urlRequest = URLRequest(url: URL(string: url!)!)
            urlRequest.httpMethod = method!.rawValue
            if let requestParameters = parameters {
                let requested = try JSONSerialization.data(withJSONObject: requestParameters, options: [])
                urlRequest.httpBody = requested
            }
            if let requestBody = body {
                let data = (requestBody.data(using: .utf8))! as Data
                urlRequest.httpBody = data
            }
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            header?.forEach({(arg: (key: String, value: String)) in
                let (key, value) = arg
                urlRequest.addValue(value, forHTTPHeaderField: key)
            })
            self.alamofireRequest(urlRequest, errorHandler, handler)
        } catch {
            throw RESTError.InternalError("API Internal error.")
        }
    }
}
