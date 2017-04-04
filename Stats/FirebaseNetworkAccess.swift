//
//  FirebaseNetworkAccess.swift
//  Amanda's Recipes
//
//  Created by Ben Norris on 4/11/16.
//  Copyright © 2016 OC Tanner. All rights reserved.
//

import Foundation
import Firebase
import Marshal

enum FirebaseError: Error {
    case nilUser
    case userRetrievalFailed(userId: String)
    case incorrectlyFormedData
}

struct FirebaseNetworkAccess {
    
    static let sharedInstance = FirebaseNetworkAccess()
    
    // MARK: - Properties
    
    let storageRef = FIRStorage.storage().reference()
    let rootRef = FIRDatabase.database().reference()
    var core = App.core
    
    func setValue(at ref: FIRDatabaseReference, parameters: JSONObject, completion: ResultCompletion?) {
        ref.setValue(parameters) { error, ref in
            if let error = error {
                completion?(Result.failure(error))
            } else {
                completion?(Result.success(JSONObject()))
            }
        }
    }
    
    func createNewAutoChild(at ref: FIRDatabaseReference, parameters: JSONObject, completion: @escaping ResultCompletion) {
        ref.childByAutoId().setValue(parameters) { error, ref in
            if let error = error {
                completion(Result.failure(error))
            } else {
                let responseJSON: JSONObject = ["ref": ref]
                completion(Result.success(responseJSON))
            }
        }
    }
    
    
    // Retrieve
    
    func getData(at ref: FIRDatabaseReference, completion: ResultCompletion?) {
        ref.observeSingleEvent(of: .value, with: { snap in
            if let snapJSON = snap.value as? JSONObject , snap.exists() {
                completion?(Result.success(snapJSON))
            } else {
                completion?(Result.failure(FirebaseError.incorrectlyFormedData))
            }
        })
    }
    
    func getObject<T: Identifiable>(at ref: FIRDatabaseReference, completion: ((Result<T>) -> Void)?) {
        ref.observeSingleEvent(of: .value, with: { snap in
            if let snapJSON = snap.value as? JSONObject, let object = try? T(object: snapJSON) {
                completion?(Result.success(object))
            } else {
                completion?(Result.failure(FirebaseError.incorrectlyFormedData))
            }
        })
    }
    
    func getKeys(at ref: FIRDatabaseReference, completion: @escaping ((Result<[String]>) -> Void)) {
        ref.observeSingleEvent(of: FIRDataEventType.value, with: { snap in
            if let usernames = (snap.value as AnyObject).allKeys as? [String] , snap.exists() {
                completion(Result.success(usernames))
            } else {
                completion(Result.failure(FirebaseError.incorrectlyFormedData))
            }
        })
    }
    
    func getData(withQuery query: FIRDatabaseQuery, completion: ResultCompletion?) {
        query.observeSingleEvent(of: .value, with: { snap in
            if snap.exists(), let json = snap.value as? JSONObject {
                completion?(.success(json))
            } else {
                completion?(.failure(FirebaseError.incorrectlyFormedData))
            }
        })
    }
    
    
    // Update
    
    func updateObject(at ref: FIRDatabaseReference, parameters: JSONObject, completion: ResultCompletion?) {
        ref.updateChildValues(parameters) { error, firebase in
            if let error = error {
                completion?(Result.failure(error))
            } else {
                completion?(Result.success(JSONObject()))
            }
        }
    }
    
    func addObject(at ref: FIRDatabaseReference, parameters: JSONObject, completion: ResultCompletion?) {
        ref.updateChildValues(parameters) { error, ref in
            if let error = error {
                completion?(Result.failure(error))
            } else {
                completion?(Result.success(JSONObject()))
            }
        }
    }
    
    
    // Delete
    
    func deleteObject(at ref: FIRDatabaseReference, completion: ResultCompletion?) {
        ref.removeValue { error, ref in
            if let error = error {
                completion?(Result.failure(error))
            } else {
                completion?(Result.success(JSONObject()))
            }
        }
    }
    
    
    // MARK: - Subscriptions
    
    func subscribe(to ref: FIRDatabaseReference, completion: @escaping ResultCompletion) {
        ref.observe(.value, with: { snap in
            if let snapJSON = snap.value as? JSONObject, snap.exists() {
                completion(Result.success(snapJSON))
            } else {
                completion(Result.failure(FirebaseError.incorrectlyFormedData))
            }
        })
    }
    
    func subscribe(to query: FIRDatabaseQuery, completion: @escaping ResultCompletion) {
        query.observe(.value, with: { snap in
            if let snapJSON = snap.value as? JSONObject, snap.exists() {
                completion(Result.success(snapJSON))
            } else {
                completion(Result.failure(FirebaseError.incorrectlyFormedData))
            }
        })
    }
    
    func subscribeToReachability(completion: @escaping (Bool?) -> Void) {
        FIRDatabase.database().reference(withPath: ".info/connected").observe(.value, with: { snapshot in
            completion(snapshot.value as? Bool)
        })
    }
    
    func unsubscribe(from ref: FIRDatabaseReference) {
        ref.removeAllObservers()
    }
    
    // MARK: Storage
    
    func uploadData(_ data: Data, toRef ref: FIRStorageReference, with metadata: FIRStorageMetadata? = nil, completion: @escaping (Result<URL>) -> Void) {
        ref.put(data, metadata: metadata) { metadata, error in
            if let url = metadata?.downloadURL(), error == nil {
                completion(.success(url))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
}
