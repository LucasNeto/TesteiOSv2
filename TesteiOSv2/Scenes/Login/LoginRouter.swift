//
//  LoginRouter.swift
//  TesteiOSv2
//
//  Created by Lucas Santana on 22/02/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit

@objc protocol LoginRoutingLogic
{
    func routeToStatements(segue: UIStoryboardSegue?)
}
protocol LoginDataPassing
{
    var dataStore: LoginDataStore? { get }
}
class LoginRouter : NSObject , LoginRoutingLogic , LoginDataPassing{
    
    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?
    
    
    // MARK: Routing
    
    func routeToStatements(segue: UIStoryboardSegue?) {
        guard let destinationVC = viewController?.storyboard?
            .instantiateViewController(withIdentifier: "StatementsViewController")
            as? StatementsViewController else { return }
        var destinationDS = destinationVC.router!.dataStore!
        passDataToStatements(source: self.dataStore!, destination: &destinationDS)
        navigateToStatements(source: viewController!, destination: destinationVC)
    }
    
    private func navigateToStatements(source: LoginViewController, destination: StatementsViewController){
        source.show(destination, sender: nil)
    }
    
    
    // MARK: Passing data
    
    func passDataToStatements(source: LoginDataStore, destination: inout StatementsDataStore) {
        destination.user = source.user
    }
    
}
