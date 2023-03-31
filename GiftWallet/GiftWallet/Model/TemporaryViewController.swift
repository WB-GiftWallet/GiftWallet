//
//  TemporaryViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/31.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TemporaryViewController: UIViewController {
    
    let viewModel = TemporaryViewModel()
    var handle: AuthStateDidChangeListenerHandle?
    var db = Firestore.firestore()
    
    let loginButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("  로  그  인  ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    let idTextField: UITextField = {
        let field = UITextField()
        
        field.placeholder = "ID 입력"
        
        return field
    }()
    
    let passWordTextField: UITextField = {
        let field = UITextField()
        
        field.placeholder = "Password 입력"
        
        return field
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        return stackView
    }()
    
    let logOutButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(" LogOut ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    let addGiftButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(" Make  Gift  Data ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    let printButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(" 출 력 버 튼 ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    let addFireStoreButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(" Add FireStore ", for: .normal)
        button.backgroundColor = .systemBrown
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        
        //MARK: 로그아웃
        if let user = Auth.auth().currentUser {
            print(user)
            
            loginSuccess()
        }
        
        setupLayout()
        buttonAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            print("handler Start")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func setupLayout() {
        
        view.addSubview(stackView)
        
        [idTextField, passWordTextField, loginButton, logOutButton, addGiftButton, printButton, addFireStoreButton].forEach(stackView.addArrangedSubview(_:))
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func buttonAddTarget() {
        loginButton.addTarget(nil, action: #selector(tapLoginButton), for: .touchUpInside)
        logOutButton.addTarget(nil, action: #selector(tapLogoutButton), for: .touchUpInside)
        addGiftButton.addTarget(nil, action: #selector(tapMakeGiftButton), for: .touchUpInside)
        printButton.addTarget(nil, action: #selector(tapPrintButton), for: .touchUpInside)
        addFireStoreButton.addTarget(nil, action: #selector(tapAddFirebaseButton), for: .touchUpInside)
    }
    
    @objc func tapLoginButton() {
        print("Tapped Login Button")
        Auth.auth().signIn(withEmail: idTextField.text!, password: passWordTextField.text!) { [weak self] authResult, error in
            
            if authResult != nil{
                //TODO: 로그인 성공 시 Tabbar Push Logic
                self?.loginSuccess()
            }
            else{
                print("login fail")
            }
        }
    }
    
    func loginSuccess() {
        print("login success")
        print(Auth.auth().currentUser?.email ?? "Not Login User")
        
        self.idTextField.placeholder = "이미 로그인 된 상태입니다."
        self.passWordTextField.placeholder = "이미 로그인 된 상태입니다."
        self.loginButton.setTitle("이미 로그인 된 상태입니다.", for: .normal)
        
        //TODO: Login 후 Tabbar 넘김
        //                let tabbar = MainTabBarController(mainViewModel: MainViewModel(), etcSettingViewModel: EtcSettingViewModel())
        //                self?.navigationController?.pushViewController(tabbar, animated: true)
    }
    
    @objc func tapLogoutButton() {
        print("tapLogOutButton")
        print("------로그아웃Start :", Auth.auth().currentUser?.email ?? "Not Login User")
        FireBaseManager.shared.signOut()
        
        print("------로그아웃End :", Auth.auth().currentUser?.email ?? "Not Login User")
        DispatchQueue.main.async {
            self.idTextField.placeholder = "ID 입력"
            self.passWordTextField.placeholder = "Password 입력."
            self.loginButton.setTitle(" 로   그   인  ", for: .normal)
        }
    }
    @objc func tapMakeGiftButton() {
        print("tapMakeGiftButton")
        try? FireBaseManager.shared.fetchData()
    }
    
    @objc func tapPrintButton() {
        print("tabPrintButton")
//        print(Auth.auth().currentUser?.uid)
//        print("회원가입")
//
//        FireBaseManager.shared.createUser(email: "baem6@naver.com", password: "123456789") { result in
//            switch result {
//                case .success(let uid):
//                    print(uid)
//                case .failure(let error):
//                    print(error)
//            }
//        }
        
//        do {
//            try FireBaseManager.shared.saveData(giftData: Gift(image: UIImage(named: "testImageEDIYA")!, category: nil, brandName: "EDIYA", productName: "커피1리터", memo: "맛난거", expireDate: Date(),useDate: Date()))
//        } catch FireBaseManagerError.dateError {
//            print("dateError")
//        } catch {
//            print("안대 ㅠ")
//        }
    }
    
    @objc func tapAddFirebaseButton() {
        print("tapAddFirebaseButton")
//        try? FireBaseManager.shared.saveData()
//        FireBaseManager.shared.updateData(number: 0)
        FireBaseManager.shared.deleteDate(number: 0)
    }
}
