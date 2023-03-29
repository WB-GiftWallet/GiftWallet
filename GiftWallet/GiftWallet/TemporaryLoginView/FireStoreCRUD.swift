//
//  FireStoreCRUD.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/28.
//

import FirebaseFirestore
import FirebaseAuth

class FireStoreCRUD {
    static let shared = FireStoreCRUD()
    
    private var db = Firestore.firestore()
    private var userID = Auth.auth().currentUser?.uid
    
    private init() {}
    
    
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            print(authResult)
            print(error)
        }
    }
    
    
}
