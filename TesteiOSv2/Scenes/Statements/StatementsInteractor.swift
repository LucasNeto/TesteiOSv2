//
//  StatementsInteractor.swift
//  TesteiOSv2
//
//  Created by Lucas Santana on 24/02/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import Foundation

protocol StatementsBusinessLogic {
    func listStatements(request: ListStatements.FetchStatements.Request)
}

protocol StatementsDataStore {
    var user: User! { get set }
}

class StatementsInteractor : StatementsBusinessLogic, StatementsDataStore {
    var user: User!
    
    var worker : StatementsWorker?
    var presenter: StatementsPresentationLogic?
    
    func listStatements(request: ListStatements.FetchStatements.Request) {
        self.requestListStatements(request: request)
    }
    
    private func requestListStatements(request: ListStatements.FetchStatements.Request){
        worker?.requestStatements(request, completionHandler: { (statements) in
            self.presenter?
                .presentFetchedStatements(response:
                    ListStatements.FetchStatements.Response(statements: statements))
        })
    }
}
