//
//  StatementsWorker.swift
//  TesteiOSv2
//
//  Created by Lucas Santana on 24/02/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import Foundation

class StatementsWorker : BaseWorker {
    func requestStatements(_ request: ListStatements.FetchStatements.Request, completionHandler: @escaping ([Statement]) -> Void) {
        if let url = URL(string: "\(URL_SERVER)/statements/\(request.user.userId)") {
            doRequest(url: url, body: nil, method: .GET) { (success, response) in
                var statementListRsp = [Statement]()
                if let dic = self.getDictionaryFromJSON(response){
                    if let statementList : [[String:NSObject]] = dic["statementList"] as? [[String:NSObject]] {
                        for s in statementList{
                            statementListRsp.append(Statement(s))
                        }
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(statementListRsp)
                }
            }
        }
    }
}
