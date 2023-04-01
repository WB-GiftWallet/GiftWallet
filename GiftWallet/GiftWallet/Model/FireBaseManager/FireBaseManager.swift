//
//  FireBaseManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/28.
//

import FirebaseFirestore
import FirebaseAuth
import UIKit

class FireBaseManager {
    static let shared = FireBaseManager()
    
    private var db = Firestore.firestore()
    private var CurrentuserID = Auth.auth().currentUser?.uid
    
    private init() {}
    
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
        }
    }
    
    func existingLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
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
    
    func saveData(number: Int,giftData: Gift) throws {
        guard let id = Auth.auth().currentUser?.uid else {
            print("throw FireBaseManagerError.notHaveID")
            throw FireBaseManagerError.notHaveID
        }
        
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
        
        db.collection(id.description).document(number.description).setData(["image":image,
                                                                            "category":categoryData,
                                                                            "brandName":brandName,
                                                                            "productName":productName,
                                                                            "memo":memo,
                                                                            "useableState":giftData.useableState,
                                                                            "expireDate": expireDate,
                                                                            "useDate": useDate,
                                                                           ])
        print("완료")
    }
    
    func updateData(number: Int/*, _ giftData: Gift */) {
        let number = 0
        guard let current = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection(current).document(number.description).updateData(["brandName" : "고쳐졍"]) { error in
            print(error?.localizedDescription)
        }
    }
    
    func deleteDate(number: Int) {
        let number = 0
        guard let current = Auth.auth().currentUser?.uid else {
            return
        }
        db.collection(current).document(number.description).delete { error in
            print(error?.localizedDescription)
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

extension FireBaseManager {
    func fetchMostRecentNumber(completion: @escaping (Result<Int, FireBaseManagerError>) -> Void) {
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
