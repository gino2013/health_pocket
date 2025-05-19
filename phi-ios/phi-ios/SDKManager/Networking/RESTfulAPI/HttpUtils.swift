//
//  HttpUtils.swift
//  SDK
//
//  Created by Kenneth on 2023/10/5.
//

import Foundation

/**
 HTTP method definitions.
 
 See https://tools.ietf.org/html/rfc7231#section-4.3
 */
public enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

enum PHIAPI_Error: Error {
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case badRequest
    case unknownError(code: Int, message: String)
}

class HttpUtils {
    fileprivate static func request(_ httpMethod: Method,
                                    url: String,
                                    headerEntries: Dictionary<String, String>? = nil,
                                    jsonData: Any? = nil,
                                    completion: @escaping (_ responseStatus: Bool, _ data: Data?, _ error: Error?) -> Void) {
        let url: URL = URL(string: url)!
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.addValue("phi-ios", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if headerEntries != nil {
            for (k, v) in headerEntries! {
                request.addValue(v, forHTTPHeaderField: k)
            }
        }
        
        switch httpMethod {
        case .POST, .PUT:
            if let data = jsonData as? Data {
                request.httpBody = data
            }
        default:
            break
        }
        
        /*
        if let data = jsonData as? Data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("request: \(request), data: \(json)")
        }
        */
        
        if let data = jsonData as? Data {
            printJSON(data: data)
        }
        
        let config = URLSessionConfiguration.noCacheConfigurationWithTimeout(59)
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request, completionHandler: { data, response, err in
            let error = err as NSError?
            guard error?.domain != NSURLErrorDomain else {
                print("Error URL: \(url)")
                print("Error Code: \(String(describing: error?.code))")
                print("Error description: \(String(describing: error?.localizedDescription))")
                completion(false, nil, error)
                return
            }
            guard error == nil else {
                completion(false, data, error)
                return
            }
            
            let httpResponse = response! as? HTTPURLResponse
            let responseCode = httpResponse!.statusCode
            
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("response: \(httpResponse!), data: \(json)")
            }
            
            switch responseCode {
            case 401:
                completion(false, data, PHIAPI_Error.unauthorized)
            case 400:
                completion(false, data, PHIAPI_Error.badRequest)
            case 403:
                completion(false, data, PHIAPI_Error.forbidden)
            case 404:
                completion(false, data, PHIAPI_Error.notFound)
            // case 500, 503:
            case 503:
                completion(false, data, PHIAPI_Error.serverError)
            case 0, 502, 555:
                completion(false, data, PHIAPI_Error.unknownError(code: responseCode, message: "Server Error"))
            default:
                completion(true, data, nil)
            }
            session.invalidateAndCancel()
        }).resume()
    }
    
    static func get(url: String, headerEntries: Dictionary<String, String>? = nil, completion: @escaping (Bool, Data?, Error?) -> Void) {
        /*
         let timestamp = String(format: "%.0f", floor(Date().timeIntervalSince1970 * 1000))
         let concateSymbol = url.contains("?") ? "&" : "?"
         let url = url + concateSymbol + "_=\(timestamp)"
         */
        request(.GET,
                url: url,
                headerEntries: headerEntries,
                jsonData: nil,
                completion: completion)
    }
    
    static func post(url: String, headerEntries: Dictionary<String, String>? = nil, jsonData: Any? = nil, completion: @escaping (Bool, Data?, Error?) -> Void) {
        request(.POST,
                url: url,
                headerEntries: headerEntries,
                jsonData: jsonData,
                completion: completion)
    }
    
    static func put(url: String, headerEntries: Dictionary<String, String>? = nil, jsonData: Any? = nil, completion: @escaping (Bool, Data?, Error?) -> Void) {
        request(.PUT,
                url: url,
                headerEntries: headerEntries,
                jsonData: jsonData,
                completion: completion)
    }
    
    static func delete(url: String, headerEntries: Dictionary<String, String>? = nil, completion: @escaping (Bool, Data?, Error?) -> Void) {
        request(.DELETE,
                url: url,
                headerEntries: headerEntries,
                jsonData: nil,
                completion: completion)
    }
    
    static func printJSON(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            // 嘗試將 JSON 轉換為陣列
            if let jsonArray = jsonObject as? [[String: Any]] {
                print("JSON Array of Dictionaries: \(jsonArray)")
                for dictionary in jsonArray {
                    print("Dictionary: \(dictionary)")
                }
            }
            // 嘗試將 JSON 轉換為字典
            else if let jsonDict = jsonObject as? [String: Any] {
                print("JSON Dictionary: \(jsonDict)")
            }
            // 處理無法識別的情況
            else {
                print("Unknown JSON format")
            }
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }
    
    /*
    static func printJSON_2023(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let jsonArray = jsonObject as? [Any] {
                print("JSON Array: \(jsonArray)")
                for item in jsonArray {
                    if let dictionary = item as? [String: Any] {
                        print("Dictionary: \(dictionary)")
                    } else {
                        print("Item is not a dictionary: \(item)")
                    }
                }
            } else if let jsonDict = jsonObject as? [String: Any] {
                print("JSON Dictionary: \(jsonDict)")
            } else {
                print("Unable to cast JSON to expected types")
            }
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }
    */
}
