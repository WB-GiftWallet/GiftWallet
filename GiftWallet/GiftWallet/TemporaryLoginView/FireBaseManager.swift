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
    
    func saveData() throws {
        guard let id = Auth.auth().currentUser?.uid else {
            throw FireBaseManagerError.notHaveID
        }

        // 현재 Number = number
        let number = 0
        
        db.collection(id.description).document(number.description).setData(["image":"엔제리너스",
                                                                            "category":"엔제리너스",
                                                                            "brandName":"엔제리너스",
                                                                            "productName":"엔제리너스",
                                                                            "memo":"엔제리너스",
                                                                            "useableState":"엔제리너스",
                                                                            "expireDate":"엔제리너스",
                                                                            "useDate":"엔제리너스",
                                                                           ])
        
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
