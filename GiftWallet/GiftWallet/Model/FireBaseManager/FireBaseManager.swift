//
//  FireBaseManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/28.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseCore
import FirebaseAuth
import UIKit

class FireBaseManager {
    static let shared = FireBaseManager()
    
    //MARK: FireBase Property
    private var db = Firestore.firestore()
    private let storage = Storage.storage()
    //    private let storageReference: StorageReference = Storage.storage().reference()
    private var CurrentuserID = Auth.auth().currentUser?.uid
    
    private var maxItemNumber = 0
    
    private init() {
        self.initializingItemNumber()
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<String, FireBaseManagerError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion(.failure(.createUserFail))
                return
            }
            
            guard let userUid = authResult?.user.uid else {
                completion(.failure(.invaildUserID))
                return
            }
            
            completion(.success(userUid))
            self.initializingItemNumber()
        }
    }
    
    func existingLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            self?.initializingItemNumber()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //TODO: Gift Data Return
    func fetchData(completion: @escaping ([Gift]) -> Void) throws {
        guard let id = Auth.auth().currentUser?.uid else {
            throw FireBaseManagerError.notHaveID
        }
        
        db.collection(id.description).getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                var giftData = [Gift]()
                for document in snapshot!.documents {
                    //TODO: [Gift] Return
                    guard let gift = self.changeGiftData(document) else { return }
                    giftData.append(gift)
                }
                
                completion(giftData)
            } else {
                print("FireBase Fetch Error")
            }
        }
    }
    
    func saveData(giftData: Gift) throws {
        guard let id = Auth.auth().currentUser?.uid else {
            print("throw FireBaseManagerError.notHaveID")
            throw FireBaseManagerError.notHaveID
        }
        
        guard let imageData = giftData.image.pngData() else {
            print("FireBaseManagerError.invalidImage")
            throw FireBaseManagerError.invalidImage
        }
        
        let categoryData = giftData.category?.rawValue ?? "Nil"
        
        guard let brandName = giftData.brandName,
              let productName = giftData.productName,
              let memo = giftData.memo else {
            throw FireBaseManagerError.giftDataNotChangeString
        }
        
        guard let giftExpireDate = giftData.expireDate,
              let giftUseDate = giftData.useDate else {
            throw FireBaseManagerError.dateError
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let expireDate = dateFormatter.string(from: giftExpireDate)
        let useDate = dateFormatter.string(from: giftUseDate)
        
        upLoadImageData(imageData: imageData, userID: id, dataNumber: maxItemNumber) { url in
            self.db.collection(id.description).document((self.maxItemNumber + 1).description).setData(["image":url.absoluteString,
                                                                                                  "category":categoryData,
                                                                                                  "brandName":brandName,
                                                                                                  "productName":productName,
                                                                                                  "memo":memo,
                                                                                                  "useableState": true,
                                                                                                  "expireDate": expireDate,
                                                                                                  "useDate": useDate,
                                                                                                 ])
            self.maxItemNumber += 1
            print(self.maxItemNumber)
            print("완료")
        }
    }
    
    func updateData(_ giftData: Gift) throws {
        guard let current = Auth.auth().currentUser?.uid else {
            return
        }
        
        let dataNumber = giftData.number
        
        //TODO: ImageData Encoding
        //        guard let imageData = giftData.image.pngData() else {
        //            print("FireBaseManagerError.invalidImage")
        //            throw FireBaseManagerError.invalidImage
        //        }
        //        let image = imageData.base64EncodedString
        let image = "imageData"
        
        let categoryData = giftData.category?.rawValue ?? "Nil"
        
        guard let brandName = giftData.brandName,
              let productName = giftData.productName,
              let memo = giftData.memo else {
            throw FireBaseManagerError.giftDataNotChangeString
        }
        
        guard let giftExpireDate = giftData.expireDate,
              let giftUseDate = giftData.useDate else {
            throw FireBaseManagerError.dateError
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let expireDate = dateFormatter.string(from: giftExpireDate)
        let useDate = dateFormatter.string(from: giftUseDate)
        
        db.collection(current).document(String(dataNumber)).updateData(["image":image,
                                                                        "category":categoryData,
                                                                        "brandName":brandName,
                                                                        "productName":productName,
                                                                        "memo":memo,
                                                                        "useableState":giftData.useableState,
                                                                        "expireDate": expireDate,
                                                                        "useDate": useDate,
                                                                       ]) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func deleteDate(_ number: Int) {
        guard let current = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection(current).document(number.description).delete { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
}

extension FireBaseManager {
    //TODO: 시간 당겨지는현상 해결 [2023-04-01] -> [2023-03-31 15:00:00 +0000]
    private func changeGiftData(_ document: QueryDocumentSnapshot) -> Gift? {
        guard let image = UIImage(systemName: "applelogo"),
              let brandName = document["brandName"] as? String,
              let productName = document["productName"] as? String,
              let memo = document["memo"] as? String,
              let useableState = document["useableState"] as? Bool,
              let expireDateString = document["expireDate"] as? String,
              let useDateString = document["useDate"] as? String
        else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyyMMdd"
        
        guard let expireDate = formatter.date(from: expireDateString),
              let useDate = formatter.date(from: useDateString)
        else {
            return nil
        }
        
        let gift = Gift(
            image: image,
            category: Category(rawValue: document["category"] as! String),
            brandName: brandName,
            productName: productName,
            memo: memo,
            useableState: useableState,
            expireDate: expireDate,
            useDate: useDate
        )
        
        return gift
    }
}

//MARK: -Item Number Setting Method
extension FireBaseManager {
    
    private func initializingItemNumber() {
        self.fetchMostRecentNumber { result in
            switch result {
                case .success(let number):
                    self.maxItemNumber = number
                case .failure(let error):
                    print(error.localizedDescription)
                    print("ERROR: FetchMostRecentNumber")
            }
        }
    }
    
    private func fetchMostRecentNumber(completion: @escaping (Result<Int, FireBaseManagerError>) -> Void) {
        var recentNumber = 0
        guard let id = Auth.auth().currentUser?.uid else {
            completion(.failure(.invaildUserID))
            return
        }
        
        db.collection(id.description).getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    guard let docuNumber = Int(document.documentID) else {
                        return
                    }
                    recentNumber = max(recentNumber, docuNumber)
                }
                completion(.success(recentNumber))
            } else {
                print("FireBase Fetch Error")
            }
        }
    }
}

//MARK: -FireStorage
extension FireBaseManager {
    
    private func upLoadImageData(imageData: Data, userID: String, dataNumber: Int, completion: @escaping (URL) -> Void) {
        let storageReference = storage.reference()
        
        print(dataNumber)
        let imageReference = storageReference.child("image").child("USER_\(userID)").child("image_\(dataNumber).png")
        
        let _ = imageReference.putData(imageData, metadata: nil) { (_, error) in
            imageReference.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                
                completion(downloadURL)
            }
        }
    }
    
    private func downLoadImageData() {
        
    }
}
