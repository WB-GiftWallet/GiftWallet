//
//  FireBaseManager.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/28.
//

import FirebaseFirestore
import FirebaseAuth

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
            if error != nil {
                self?.createUser(email: email, password: password, completion: { _ in
                    self?.existingLogin(email: email, password: password)
                })
            }
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
    func fetchData() throws {
        guard let id = Auth.auth().currentUser?.uid else {
            throw FireBaseManagerError.notHaveID
        }
        
        db.collection(id.description).getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    print(document.data())
                }
            } else {
                // error. do something
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

//private extension  {
//    func
//}

/*
 extension CoreDataManager {
     private func fetchMostRecentNumber(context: NSManagedObjectContext) -> Int16 {
         let request: NSFetchRequest<GiftData> = GiftData.fetchRequest()
         request.sortDescriptors = [NSSortDescriptor(keyPath: \GiftData.number,
                                                     ascending: false)]
         request.fetchLimit = 1
         if let lastGift = try? context.fetch(request).first {
             let gift = GiftData(context: context)
             gift.number = lastGift.number
             return gift.number
         } else {
             return 0
         }
     }
 }

 */


extension FireBaseManager {
    func signInWithCredential(authCredential: AuthCredential, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(with: authCredential, completion: completion)
    }
    
    func makeAppleAuthProviderCredential(idToken: String, rawNonce: String) -> OAuthCredential {
        return OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: rawNonce)
    }
    
}
