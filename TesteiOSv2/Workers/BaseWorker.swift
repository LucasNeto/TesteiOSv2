//
//  BaseWorker.swift
//  TesteiOSv2
//
//  Created by Lucas Santana on 22/02/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//
import Foundation

class BaseWorker {
    
    var URL_SERVER : String { return "https://bank-app-test.herokuapp.com/api" }
    
    func doRequest(url: URL,body:Data?, method: URLMethod, completionHandler: @escaping (Bool,String) -> Void){
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        if let body = body {
            request.httpBody = body
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("URL:\(method) \(url)\nERRO:\(String(describing: error))")
            if let error = error {
                completionHandler(false,error.localizedDescription)
            }else{
                guard let data = data, let rsp = String(data: data, encoding: .utf8) else {
                    completionHandler(false,self.getErrorFromStatusCode(response))
                    return
                }
                print("RESPONSE:\(rsp)")
                completionHandler(true,rsp)
            }
            }.resume()
    }
 
    func getDictionaryFromJSON(_ json: String?) -> [String:NSObject]? {
        guard let json = json else { return nil }
        guard let data = json.data(using: .utf8) else { return nil }
        
        do{
            return try JSONSerialization
                    .jsonObject(with: data,
                                options: .mutableContainers) as? [String:NSObject]
        }catch{
            print(error)
        }
        
        return nil
    }
    
    private func getErrorFromStatusCode(_ response: URLResponse?) -> String {
        var error = "Erro na requisição."
        if let rspCode = (response as? HTTPURLResponse)?.statusCode {
            error += " \(rspCode)"
        }
        return error
    }
}

enum URLMethod : String {
    case GET,
    POST,
    PUT,
    DELETE
}
