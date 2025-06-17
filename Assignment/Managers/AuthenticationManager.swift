//
//  AuthenticationManager.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import CoreData

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {}
    
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<Firebase.User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No client ID found"])))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"])))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let firebaseUser = authResult?.user {
                    self?.saveUserToCoreData(firebaseUser: firebaseUser)
                    completion(.success(firebaseUser))
                }
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
    }
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    private func saveUserToCoreData(firebaseUser: Firebase.User) {
        let context = CoreDataManager.shared.context
        
        // Check if user already exists using NSFetchRequest with entity name
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", firebaseUser.uid)
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            if existingUsers.isEmpty {
                // Create new user entity
                let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
                let user = NSManagedObject(entity: entity, insertInto: context)
                
                user.setValue(firebaseUser.uid, forKey: "uid")
                user.setValue(firebaseUser.email, forKey: "email")
                user.setValue(firebaseUser.displayName, forKey: "displayName")
                user.setValue(firebaseUser.photoURL?.absoluteString, forKey: "photoURL")
                
                try context.save()
                print("User saved to Core Data successfully")
            } else {
                print("User already exists in Core Data")
            }
        } catch {
            print("Error saving user to Core Data: \(error)")
        }
    }
    
    func getCurrentUser() -> NSManagedObject? {
        guard let currentFirebaseUser = Auth.auth().currentUser else { return nil }
        
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", currentFirebaseUser.uid)
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Error fetching user from Core Data: \(error)")
            return nil
        }
    }
}
