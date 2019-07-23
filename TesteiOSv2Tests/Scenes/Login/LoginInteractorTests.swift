//
//  LoginInteractorTests.swift
//  TesteiOSv2Tests
//
//  Created by Lucas  N Santana on 23/07/19.
//  Copyright © 2019 Lucas. All rights reserved.
//
@testable import TesteiOSv2
import UIKit
import XCTest

class LoginInteractorTests: XCTestCase {

    // MARK: - Subject under test
    var sut: LoginInteractor!
    
    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setupLoginInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupLoginInteractor() {
        sut = LoginInteractor()
    }
    
    
    class LoginPresentationLogicSpy: LoginPresentationLogic {
        
        // MARK: Method call expectations
        var presentFetchUserCalled = false
        var presentFetchUserErrorCalled = false
        
        // MARK: Spied methods
        func presentFetchUser(response: FetchUsers.FetchUsers.Response){
            presentFetchUserCalled = true
        }
        
        func presentFetchUserError(response: String){
            presentFetchUserErrorCalled = true
        }
        
    }
    
    
    class LoginWorkerSpy : LoginWorker {
        
        // MARK: Method call expectations
        var requestUserCalled = false
        var getCalled = false
        
        
        // MARK: Spied methods
        override func requestUser(_ request: FetchUsers.UserFormFields,completionHandler: @escaping (User?, String?) -> Void) {
            requestUserCalled = true
            let user = User(["userId":1 as NSObject,
                          "name":"Jose da Silva Teste" as NSObject,
                         "bankAccount":"2050" as NSObject,
                         "agency":"012314564" as NSObject,
                         "balance":3.3445 as NSObject])
            completionHandler(user,nil)
            
        }
        
        override func get() -> String? {
            getCalled = true
            return ""
        }
    }
    
    // MARK: - Test password wrong
    
    func testFormatPasswordEmptyShouldAskPresenterToPresentFetchUserError()
    {
        // Given
        let loginPresentationLogicSpy = LoginPresentationLogicSpy()
        sut.presenter = loginPresentationLogicSpy
        
        // When
        let request = FetchUsers.FetchUsers.Request(userFormFields: FetchUsers.UserFormFields(user: "abc", password: ""))
        sut?.login(request: request)
        
        // Then
        XCTAssert(loginPresentationLogicSpy.presentFetchUserErrorCalled, "Presenting an password error should ask presenter to do it")
    }
    
    // MARK: - Test password wrong
    
    func testFormatPasswordUpcasedShouldAskPresenterToPresentFetchUserError()
    {
        // Given
        let loginPresentationLogicSpy = LoginPresentationLogicSpy()
        sut.presenter = loginPresentationLogicSpy
        
        // When
        let request = FetchUsers.FetchUsers.Request(userFormFields: FetchUsers.UserFormFields(user: "abc", password: "A"))
        sut?.login(request: request)
        
        // Then
        XCTAssert(loginPresentationLogicSpy.presentFetchUserErrorCalled, "Presenting an password error should ask presenter to do it")
    }
    
    // MARK: - Test password wrong
    
    func testFormatPasswordLowercasedShouldAskPresenterToPresentFetchUserError()
    {
        // Given
        let loginPresentationLogicSpy = LoginPresentationLogicSpy()
        sut.presenter = loginPresentationLogicSpy
        
        // When
        let request = FetchUsers.FetchUsers.Request(userFormFields: FetchUsers.UserFormFields(user: "abc", password: "a"))
        sut?.login(request: request)
        
        // Then
        XCTAssert(loginPresentationLogicSpy.presentFetchUserErrorCalled, "Presenting an password error should ask presenter to do it")
    }
    
    // MARK: - Test password wrong
    
    func testFormatPasswordNumberShouldAskPresenterToPresentFetchUserError()
    {
        // Given
        let loginPresentationLogicSpy = LoginPresentationLogicSpy()
        sut.presenter = loginPresentationLogicSpy
        
        // When
        let request = FetchUsers.FetchUsers.Request(userFormFields: FetchUsers.UserFormFields(user: "abc", password: "1"))
        sut?.login(request: request)
        
        // Then
        XCTAssert(loginPresentationLogicSpy.presentFetchUserErrorCalled, "Presenting an password error should ask presenter to do it")
    }
    
    // MARK: - Test password Right
    
    func testFormatPasswordRightShouldAskPresenterToPresentFetchUserError()
    {
        // Given
        let loginPresentationLogicSpy = LoginPresentationLogicSpy()
        sut.presenter = loginPresentationLogicSpy
        let loginWorkerSpy = LoginWorkerSpy()
        sut.worker = loginWorkerSpy
        
        
        // When
        let request = FetchUsers.FetchUsers.Request(userFormFields: FetchUsers.UserFormFields(user: "abc", password: "Aa@2"))
        sut?.login(request: request)
        
        // Then
        XCTAssert(loginPresentationLogicSpy.presentFetchUserCalled, "Presenting an password success should ask presenter to do it")
        XCTAssert(loginWorkerSpy.requestUserCalled, "Presenting an password success should ask presenter to do it")
    }
  
    func testGetLastLoginShouldAskToWorker(){
        // Given
        let loginWorkerSpy = LoginWorkerSpy()
        sut.worker = loginWorkerSpy
        
        
        // When
        sut?.lastLogin()
        
        // Then
        XCTAssert(loginWorkerSpy.getCalled, "Presenting an password success should ask presenter to do it")
    }
}
