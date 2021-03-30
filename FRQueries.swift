//
//  FRQueries.swift
//  FirebaseLoginPOC
//
//  Created by hitesh on 23/03/21.
//

import Foundation
import Firebase
import CodableFirebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

class FRQueries {
    static let db = Firestore.firestore()
    
    static let collectionName = "collectionName"
    static let documentID = "collectionName"
    
    // document link for reference - https://firebase.google.com/docs/firestore/query-data/queries#swift
    
    // MARK:- Add
    class func addData(){
        // 1. Query which adds a new document to a collection with an auto generated document id
        let data : [String:Any] = [:] // this should be [String : Any]
        db.collection(collectionName).addDocument(data:data) { (err) in
            if err != nil {
            } else {
                
            }
        }
    }
    
    // MARK:- Update
    class func updateData(){
        // 1. Query which updates an existing document
        let data : [String:Any] = [:] // this should be [String : Any] , all fields that we send in this data will be updated
        db.collection(collectionName).document(documentID).updateData(data) { (err) in
            if err != nil {
            } else {
                
            }
        }
    }
    
    // MARK:- Set
    class func setData(){
        // 1. Query which sets a document with the desired id needed
        let data : [String:Any] = [:] // this should be [String : Any]
        db.collection(collectionName).document(documentID).setData(data) { (err) in
            if err != nil {
            } else {
                
            }
        }
    }
    
    // MARK:- Delete
    class func deleteDocument(){
        // 1. Query which deletes a document, you cant delete a collection as a whole
        db.collection(collectionName).document(documentID).delete { (err) in
            if err != nil {
            } else {
                
            }
        }
    }
    
    // MARK:- Get data (single time)
    class func getAllDataInCollection<T:Codable>(result:@escaping(_ resultArr:[T], _ error:String?) -> Void){
        db.collection(collectionName).getDocuments { (snap, err) in
            if let error = err {
                result([], error.localizedDescription)
            } else {
                guard let snaps = snap else {
                    return
                }
                var arr = [T]()
                for document in snaps.documents {
                    do {
                        let model = try FirestoreDecoder().decode(T.self, from: document.data())
                        arr.append(model)
                    }
                    catch let error {
                        print(error)
                    }
                }
                result(arr, nil)
            }
        }
    }
    
    // MARK:- Get data (and listen for changes)
    class func getAllDataInCollectionAndListenForChanges<T:Codable>(result:@escaping(_ resultArr:[T], _ error:String?) -> Void){
        db.collection(collectionName).addSnapshotListener { (snap, err) in
            if let error = err {
                result([], error.localizedDescription)
            } else {
                guard let snaps = snap else {
                    return
                }
                var arr = [T]()
                for document in snaps.documents {
                    do {
                        let model = try FirestoreDecoder().decode(T.self, from: document.data())
                        // add conditions here what to do, like delete data, merge with existing data etc acc to required scenario
                        arr.append(model)
                    }
                    catch let error {
                        print(error)
                    }
                }
                result(arr, nil)
            }
        }
    }
    
    // MARK:- Get a document data in a collection (one time)
    class func getDocumentData<T:Codable>(result:@escaping(_ resultArr:T?, _ error:String?) -> Void){
        db.collection(collectionName).document(documentID).getDocument { (snap, err) in
            if let error = err {
                result(nil, error.localizedDescription)
            } else {
                guard let snapsData = snap?.data() else {
                    return
                }
                do {
                    let model = try FirestoreDecoder().decode(T.self, from: snapsData)
                    result(model, nil)
                }
                catch let error {
                    print(error)
                    result(nil, error.localizedDescription)
                }
            }
        }
    }
    
    // MARK:- Get a document data in a collection (and observe changes)
    class func getDocumentDataAndListenForChange<T:Codable>(result:@escaping(_ resultArr:T?, _ error:String?) -> Void){
        db.collection(collectionName).document(documentID).addSnapshotListener { (snap, err) in
            if let error = err {
                result(nil, error.localizedDescription)
            } else {
                guard let snapsData = snap?.data() else {
                    return
                }
                do {
                    let model = try FirestoreDecoder().decode(T.self, from: snapsData)
                    result(model, nil)
                }
                catch let error {
                    print(error)
                    result(nil, error.localizedDescription)
                }
            }
        }
    }
    
    // MARK:- Get data with queries
    class func getDataWithEqualQuery<T:Codable>(fieldToMatch:String, value:Any, result:@escaping(_ resultArr:[T]?, _ error:String?) -> Void){
        // will return all documents in a collection where this condition is met
        db.collection(collectionName).whereField(fieldToMatch, isEqualTo: value).getDocuments { (snap, err) in
            if let error = err {
                result(nil, error.localizedDescription)
            } else {
                guard let snaps = snap else {
                    return
                }
                var arr = [T]()
                for document in snaps.documents {
                    do {
                        let model = try FirestoreDecoder().decode(T.self, from: document.data())
                        arr.append(model)
                    }
                    catch let error {
                        print(error)
                    }
                }
                result(arr, nil)
            }
        }
    }
    
    class func getDataWithUnEqualQuery<T:Codable>(fieldToMatch:String, value:Any, result:@escaping(_ resultArr:[T]?, _ error:String?) -> Void){
        // will return all documents in a collection where this condition is met
        db.collection(collectionName).whereField(fieldToMatch, isNotEqualTo: value).getDocuments { (snap, err) in
            if let error = err {
                result(nil, error.localizedDescription)
            } else {
                guard let snaps = snap else {
                    return
                }
                var arr = [T]()
                for document in snaps.documents {
                    do {
                        let model = try FirestoreDecoder().decode(T.self, from: document.data())
                        arr.append(model)
                    }
                    catch let error {
                        print(error)
                    }
                }
                result(arr, nil)
            }
        }
    }
    
    class func getDataWithLessThanQuery<T:Codable>(fieldToMatch:String, value:Any, result:@escaping(_ resultArr:[T]?, _ error:String?) -> Void){
        // will return all documents in a collection where this condition is met
        db.collection(collectionName).whereField(fieldToMatch, isLessThan: value).getDocuments { (snap, err) in
            if let error = err {
                result(nil, error.localizedDescription)
            } else {
                guard let snaps = snap else {
                    return
                }
                var arr = [T]()
                for document in snaps.documents {
                    do {
                        let model = try FirestoreDecoder().decode(T.self, from: document.data())
                        arr.append(model)
                    }
                    catch let error {
                        print(error)
                    }
                }
                result(arr, nil)
            }
        }
    }
    
    class func getDataWithGreaterThanQuery<T:Codable>(fieldToMatch:String, value:Any, result:@escaping(_ resultArr:[T]?, _ error:String?) -> Void){
        // will return all documents in a collection where this condition is met
        db.collection(collectionName).whereField(fieldToMatch, isGreaterThan: value).getDocuments { (snap, err) in
            if let error = err {
                result(nil, error.localizedDescription)
            } else {
                guard let snaps = snap else {
                    return
                }
                var arr = [T]()
                for document in snaps.documents {
                    do {
                        let model = try FirestoreDecoder().decode(T.self, from: document.data())
                        arr.append(model)
                    }
                    catch let error {
                        print(error)
                    }
                }
                result(arr, nil)
            }
        }
    }
    
    class func arrayContainsSingleValue<T:Codable>(fieldToMatch:String, value:Any, result:@escaping(_ resultArr:[T]?, _ error:String?) -> Void){
        // This query returns every document where the fieldToMatch field is an array that contains value. If the array has multiple instances of the value you query on, the document is included in the results only once.
        db.collection(collectionName).whereField(fieldToMatch, arrayContains: value).getDocuments { (snap, err) in
            if let error = err {
                result(nil, error.localizedDescription)
            } else {
                guard let snaps = snap else {
                    return
                }
                var arr = [T]()
                for document in snaps.documents {
                    do {
                        let model = try FirestoreDecoder().decode(T.self, from: document.data())
                        arr.append(model)
                    }
                    catch let error {
                        print(error)
                    }
                }
                result(arr, nil)
            }
        }
    }
    
    class func arrayContainsInQuery<T:Codable>(fieldToMatch:String, value:[Any], result:@escaping(_ resultArr:[T]?, _ error:String?) -> Void){
        // This query returns every document where the fieldToMatch field is set value. In this case value will be an array
        db.collection(collectionName).whereField(fieldToMatch, in: value).getDocuments { (snap, err) in
            if let error = err {
                result(nil, error.localizedDescription)
            } else {
                guard let snaps = snap else {
                    return
                }
                var arr = [T]()
                for document in snaps.documents {
                    do {
                        let model = try FirestoreDecoder().decode(T.self, from: document.data())
                        arr.append(model)
                    }
                    catch let error {
                        print(error)
                    }
                }
                result(arr, nil)
            }
        }
    }
    
    class func arrayContainsAnyQuery<T:Codable>(fieldToMatch:String, value:[Any], result:@escaping(_ resultArr:[T]?, _ error:String?) -> Void){
        // This query returns every document where the fieldToMatch field is an array that contains any value present in value.
        db.collection(collectionName).whereField(fieldToMatch, arrayContainsAny: value).getDocuments { (snap, err) in
            if let error = err {
                result(nil, error.localizedDescription)
            } else {
                guard let snaps = snap else {
                    return
                }
                var arr = [T]()
                for document in snaps.documents {
                    do {
                        let model = try FirestoreDecoder().decode(T.self, from: document.data())
                        arr.append(model)
                    }
                    catch let error {
                        print(error)
                    }
                }
                result(arr, nil)
            }
        }
        
    }
}

// MARK:- Sample on How to call the methods
class CallingExample {
    
    
    struct SampleModel : Codable {
        let key1:String?
        let key2:Int?
    }
    
    func sample(){
        // any model can be passed in this and it will return data for that model
        FRQueries.getDocumentData { (model:SampleModel?, err) in
            print(model)
        }
    }
}
