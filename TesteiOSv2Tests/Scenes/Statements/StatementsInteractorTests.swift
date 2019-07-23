//
//  StatementsInteractorTests.swift
//  TesteiOSv2Tests
//
//  Created by Lucas  N Santana on 23/07/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

@testable import TesteiOSv2
import UIKit
import XCTest


class StatementsInteractorTests: XCTestCase {
    
    // MARK: - Subject under test
    var sut: StatementsInteractor!
    
    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setupStatementsInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupStatementsInteractor() {
        sut = StatementsInteractor()
    }
    
    
    
    class StatementsPresentationLogicSpy :  StatementsPresentationLogic {
        var presentFetchedStatementsCalled = false
        
        func presentFetchedStatements(response: ListStatements.FetchStatements.Response){
            presentFetchedStatementsCalled = true
        }
    }
    
    class StatementsWorkerSpy : StatementsWorker {
        
        var requestStatementsCalled = false
        
        override func requestStatements(_ request: ListStatements.FetchStatements.Request, completionHandler: @escaping ([Statement]) -> Void){
            requestStatementsCalled = true
            completionHandler([])
        }
    }
    
    func testFetchStatementsShouldAskStatementWorkerToFetchStatementsAndPresenterResult()
    {
        // Given
        let statementsPresentationLogicSpy = StatementsPresentationLogicSpy()
        sut.presenter = statementsPresentationLogicSpy
        let statementsWorkerSpy = StatementsWorkerSpy()
        sut.worker = statementsWorkerSpy
        
        // When
        let user = User(["userId":1 as NSObject,
                         "name":"Jose da Silva Teste" as NSObject,
                         "bankAccount":"2050" as NSObject,
                         "agency":"012314564" as NSObject,
                         "balance":3.3445 as NSObject])
        let request = ListStatements.FetchStatements.Request(user: user)
        sut.listStatements(request: request)
        
        // Then
        XCTAssert(statementsWorkerSpy.requestStatementsCalled, "listStatements() should ask Statements Worker to fetch statements")
        XCTAssert(statementsPresentationLogicSpy.presentFetchedStatementsCalled, "listStatements() should ask presenter to format statements result")
    }
}
