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

// MARK: 프로퍼티
class FireBaseManager {
    static let shared = FireBaseManager()
    
    //MARK: FireBase Property
    private var db = Firestore.firestore()
    private let storage = Storage.storage()
    var currentUserID = Auth.auth().currentUser?.uid
    
    private init() { }
}

//MARK: FirebaseAuthentification 관련
extension FireBaseManager {
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
        }
    }
    
    func signInWithEmail(email: String, password: String, completion: @escaping ([Gift]) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                self?.createUser(email: email, password: password) { result in
                    // 필요시, 추가 액선
                }
            } else {
                self?.fetchData(completion: { result in
                    switch result {
                    case .success(let gifts):
                        completion(gifts)
                    case .failure(let error):
                        print(error)
                    }
                })
            }
        }
    }
    
    func signInWithCredential(authCredential: AuthCredential, completion: @escaping ([Gift]) -> Void) {
        Auth.auth().signIn(with: authCredential) { [weak self] authResult, error in
            if error == nil {
                self?.fetchData { result in
                    switch result {
                    case .success(let gifts):
                        completion(gifts)
                    case .failure(let error):
                        print(error)
                    }
                }
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
}

//MARK: FireStoreDatabase CRUD 관련
extension FireBaseManager {
    func fetchData(completion: @escaping  (Result<[Gift], FireBaseManagerError>) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else {
            return completion(.failure(.notHaveID))
        }
        
        let dispatchGroup = DispatchGroup()
        
        db.collection(id.description).getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                var giftData = [Gift]()
                for document in snapshot!.documents {
                    dispatchGroup.enter()
                    self.changeGiftData(document) { gift in
                        giftData.append(gift)
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(.success(giftData))
                }
            } else {
                completion(.failure(.fetchDataError))
            }
        }
    }
    
    func saveData(giftData: Gift, number: Int) throws {
        guard let id = Auth.auth().currentUser?.uid else {
            throw FireBaseManagerError.notHaveID
        }
        
        // 선택값 프로퍼티
        let category = giftData.category?.rawValue
        let memo = giftData.memo
        
        
        // 필수값 프로퍼티
        let imageData = giftData.image
        
        guard let brandName = giftData.brandName,
              let productName = giftData.productName else {
            throw FireBaseManagerError.giftDataNotChangeString
        }
        
        guard let giftExpireDate = giftData.expireDate else {
            throw FireBaseManagerError.dateError
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let expireDate = dateFormatter.string(from: giftExpireDate)
        
        var strUseDate: String? = nil
        if let useDate = giftData.useDate {
            strUseDate = dateFormatter.string(from: useDate)
        }
        
        upLoadImageData(imageData: imageData, userID: id, dataNumber: number) { url in
            self.db.collection(id.description).document((number).description).setData(["image":url.absoluteString,
                                                                                       "number":number,
                                                                                       "category":category,
                                                                                       "brandName":brandName,
                                                                                       "productName":productName,
                                                                                       "memo":memo,
                                                                                       "useableState": giftData.useableState,
                                                                                       "expireDate": expireDate,
                                                                                       "useDate": strUseDate
                                                                                      ])
        }
    }
    
    func updateData(_ giftData: Gift) throws {
        guard let id = currentUserID else {
            return
        }
        
        let dataNumber = giftData.number
        let category = giftData.category?.rawValue
        let memo = giftData.memo
        var useDate: String? = nil
        let imageData = giftData.image
        guard let brandName = giftData.brandName,
              let productName = giftData.productName else {
            throw FireBaseManagerError.giftDataNotChangeString
        }
        
        guard let giftExpireDate = giftData.expireDate else {
            throw FireBaseManagerError.dateError
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let expireDate = dateFormatter.string(from: giftExpireDate)
        
        if let giftUseDate = giftData.useDate {
            useDate = dateFormatter.string(from: giftUseDate)
        }
        
        upLoadImageData(imageData: imageData, userID: id, dataNumber: giftData.number) { url in
            let data: [AnyHashable: Any] = ["image":url.absoluteString,
                                            "category": category,
                                            "brandName":brandName,
                                            "productName":productName,
                                            "memo":memo,
                                            "useableState":giftData.useableState,
                                            "expireDate": expireDate,
                                            "useDate": useDate
            ]
            
            self.db.collection(id.description).document(String(dataNumber)).updateData(data) { error in
                if let error = error {
                    print("업데이트에러확인용:", error.localizedDescription)
                }
            }
        }
    }
    
    func updateUseableState(_ giftData: Gift) {
        guard let id = currentUserID else { return }
        
        let data: [AnyHashable: Any] = ["useableState": giftData.useableState]
        
        self.db.collection(id.description).document(String(giftData.number)).updateData(data) { error in
            if let error = error {
                print("업데이트에러용", error.localizedDescription)
            }
        }
    }
    
    func updateMemoAndUseableState(_ giftData: Gift) {
        guard let id = currentUserID else { return }
        
        let data: [AnyHashable: Any] = [
            "useableState": giftData.useableState,
            "memo": giftData.memo
        ]
        
        self.db.collection(id.description).document(String(giftData.number)).updateData(data) { error in
            if let error = error {
                print("업데이트에러용", error.localizedDescription)
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

// MARK: 내부처리 지역함수
extension FireBaseManager {
    //TODO: 시간 당겨지는현상 해결 [2023-04-01] -> [2023-03-31 15:00:00 +0000]
    private func changeGiftData(_ document: QueryDocumentSnapshot, completion: @escaping (Gift) -> Void) {
        // 필수값 프로퍼티
        guard let number = document["number"] as? Int,
              let brandName = document["brandName"] as? String,
              let productName = document["productName"] as? String,
              let useableState = document["useableState"] as? Bool,
              let expireDateString = document["expireDate"] as? String else { return }
        // 선택값 프로퍼티
        let category = document["category"] as? Category?
        let memo = document["memo"] as? String?
        let useDateString = document["useDate"] as? String?
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyyMMdd"
        
        var useDate: Date? = nil
        if let dateString = useDateString {
            useDate = formatter.date(from: dateString!)
        }
        
        guard let expireDate = formatter.date(from: expireDateString) else { return }
        
        self.downLoadImageData(dataNumber: number) { data in
            if let image = UIImage(data: data) {
                let gift = Gift(
                    image: image,
                    category: category as? Category,
                    brandName: brandName,
                    productName: productName,
                    memo: memo as? String,
                    useableState: useableState,
                    expireDate: expireDate,
                    useDate: useDate
                )
                completion(gift)
            }
        }
    }
}

//MARK: FireStorage 다운로드 + 업로드 관련
extension FireBaseManager {
    private func upLoadImageData(imageData: UIImage, userID: String, dataNumber: Int, completion: @escaping (URL) -> Void) {
        let storageReference = storage.reference()
        let imageReference = storageReference.child("image").child("USER_\(userID)").child("image_\(dataNumber)")
        
        guard let compressedData = compressImage(imageData, value: 1) else { return }
        
        let _ = imageReference.putData(compressedData, metadata: nil) { (_, error) in
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
        let imageReference = storageRef.child("image").child("USER_\(id)").child("image_\(dataNumber)")
        
        imageReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                
                completion(data)
            }
        }
    }
    
    private func compressImage(_ image: UIImage, value: Double) -> Data? {
        guard let compressedImage = image.jpegData(compressionQuality: value) else { return nil }
        let maxCapacity = 1048576 // 1MB
        
        if compressedImage.count > maxCapacity {
            return compressImage(image, value: value - 0.1)
        }
        
        return compressedImage
    }
}

// MARK: AppleLogin시, Credential 생성 관련 함수
extension FireBaseManager {
    func makeAppleAuthProviderCredential(idToken: String, rawNonce: String) -> OAuthCredential {
        return OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: rawNonce)
    }
}
