//
//  LoginWorker.swift
//  TesteiOSv2
//
//  Created by Lucas Santana on 22/02/2019.
//  Copyright © 2019 Lucas. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class LoginWorker : BaseWorker {
    
    private let USER_MODEL = "UserModel"
    
    func requestUser(_ request: FetchUsers.UserFormFields,completionHandler: @escaping (User?, String?) -> Void) {
        if let url = URL(string: "\(URL_SERVER)/login") ,
            let data = request.getBody().data(using: .utf8) {
            doRequest(url: url, body: data, method: .POST) { (success, response) in
                if let dic = self.getDictionaryFromJSON(response){
                    if let userAccount : [String:NSObject] = dic["userAccount"] as? [String:NSObject],
                        userAccount.count > 0 {
                        DispatchQueue.main.async {
                            completionHandler(User(userAccount), nil)
                        }
                        return
                        
                    }else if let error :  [String:NSObject] = dic["error"] as?  [String:NSObject],
                        let errorMessage = error["message"] as? String {
                        DispatchQueue.main.async {
                            completionHandler(nil, errorMessage)
                        }
                        return
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(nil, "Erro ao buscar dados")
                }
            }
        }
    }
    
    
    
    
    
    func save(_ login : String){
        if #available(iOS 10.0, *) {
            guard let context = getContext() else {return}
            let entity = NSEntityDescription.entity(forEntityName: USER_MODEL, in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(1, forKey: "id")
            newUser.setValue(login, forKey: "login")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func get() -> String? {
        if #available(iOS 10.0, *) {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: USER_MODEL)
            request.predicate = NSPredicate(format: "id = %@", "1")
            request.returnsObjectsAsFaults = false
            
            do {
                let result = try self.getContext()?.fetch(request)
                if let results = result as? [NSManagedObject],
                    let login: String = results.first?.value(forKey: "login") as? String {
                    return login
                }
            } catch {
                print("Failed")
            }
        }
        return nil
    }
    private func getContext() -> NSManagedObjectContext? {
        if #available(iOS 10.0, *) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            guard let context = appDelegate.persistentContainer?.viewContext else {return nil}
            return context
        }
        return nil
    }

}
