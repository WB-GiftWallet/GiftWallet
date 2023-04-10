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
    var currentUserID = Auth.auth().currentUser?.uid
    
    private var maxItemNumber = 0
    
    private init() {
        self.initializingItemNumber()
    }
    
    //MARK: Login, Logout, createUser Method
    private func createUser(email: String, password: String, completion: @escaping (Result<String, FireBaseManagerError>) -> Void) {
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
    
    //MARK: FireBase CRUD
    func fetchData(completion: @escaping  (Result<[Gift], FireBaseManagerError>) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else {
            return completion(.failure(.notHaveID))
        }
        
        db.collection(id.description).getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                var giftData = [Gift]()
                for document in snapshot!.documents {
                    guard let gift = self.changeGiftData(document) else { return }
                    giftData.append(gift)
                }
                
                completion(.success(giftData))
            } else {
                completion(.failure(.fetchDataError))
            }
        }
    }
    
    func saveData(giftData: Gift) throws {
        guard let id = Auth.auth().currentUser?.uid else {
            throw FireBaseManagerError.notHaveID
        }
        
        guard let imageData = giftData.image.pngData() else {
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
                                                                                                       "number":self.maxItemNumber + 1,
                                                                                                       "category":categoryData,
                                                                                                       "brandName":brandName,
                                                                                                       "productName":productName,
                                                                                                       "memo":memo,
                                                                                                       "useableState": true,
                                                                                                       "expireDate": expireDate,
                                                                                                       "useDate": useDate,
                                                                                                      ])
            self.maxItemNumber += 1
        }
    }
    
    func updateData(_ giftData: Gift) throws {
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        let dataNumber = giftData.number
        
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
        
        upLoadImageData(imageData: imageData, userID: id, dataNumber: giftData.number) { url in
            self.db.collection(id.description).document(String(dataNumber)).updateData(["image":url.absoluteString,
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
        guard let imageURL = document["image"] as? String,
              let number = document["number"] as? Int,
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
            //TODO: image 받아오기
            image: UIImage(systemName: "applelogo")!,
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
    
    private func downLoadImageData(dataNumber: Int, completion: @escaping (Data) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        let storageRef = storage.reference()
        let imageReference = storageRef.child("image").child("USER_\(id)").child("image_\(dataNumber).png")
        
        imageReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("Image Get Data ERROR")
            }
            
            guard let data = data else {
                return
            }
            
            completion(data)
        }
    }
}

extension FireBaseManager {
    func signInWithCredential(authCredential: AuthCredential, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(with: authCredential, completion: completion)
    }
    
    func makeAppleAuthProviderCredential(idToken: String, rawNonce: String) -> OAuthCredential {
        return OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: rawNonce)
    }
    
}
