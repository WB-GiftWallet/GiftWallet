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
    var data = [Gift]()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        return stackView
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
    
    let loginButton = UIButton(name: " 로그인 ")
    let logOutButton = UIButton(name: " 로그아웃 ")
    let createUserButton = UIButton(name: " 회원가입 ")
    
    lazy var loginStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginButton, logOutButton, createUserButton])
        
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    lazy var tempStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addGiftButton, statePrintButton, tempButton])
        
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    let addGiftButton = UIButton(name: "데이터추가")
    let statePrintButton = UIButton(name: "상태출력")
    let tempButton = UIButton(name: "임시버튼")
    
    lazy var CRUDStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createButton, readButton, updateButton, deleteButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        return stackView
    }()
    
    let createButton = UIButton(name: "CREATE")
    let readButton = UIButton(name: "READ")
    let updateButton = UIButton(name: "UPDATE")
    let deleteButton = UIButton(name: "DELETE")
    
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
            if let _ = Auth.auth().currentUser {
                self.view.backgroundColor = .systemGray4
            } else {
                self.view.backgroundColor = .systemPink
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func setupLayout() {
        
        view.addSubview(stackView)
        
        [idTextField, passWordTextField, loginStack, tempStackView, CRUDStack].forEach(stackView.addArrangedSubview(_:))
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func buttonAddTarget() {
        loginButton.addTarget(nil, action: #selector(tapLoginButton), for: .touchUpInside)
        logOutButton.addTarget(nil, action: #selector(tapLogoutButton), for: .touchUpInside)
        createUserButton.addTarget(nil, action: #selector(tapCreateUserButton), for: .touchUpInside)
        
        addGiftButton.addTarget(nil, action: #selector(tapAddGiftButton), for: .touchUpInside)
        statePrintButton.addTarget(nil, action: #selector(tapStatePrintButton), for: .touchUpInside)
        tempButton.addTarget(nil, action: #selector(tapTempButton), for: .touchUpInside)
        
        createButton.addTarget(nil, action: #selector(tapCreateButton), for: .touchUpInside)
        readButton.addTarget(nil, action: #selector(tapReadButton), for: .touchUpInside)
        updateButton.addTarget(nil, action: #selector(tapUpdateButton), for: .touchUpInside)
        deleteButton.addTarget(nil, action: #selector(tapDeleteButton), for: .touchUpInside)
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
    
    @objc func tapCreateUserButton() {
        print("회원가입")
        
        FireBaseManager.shared.createUser(email: idTextField.text!, password: passWordTextField.text!) { result in
            switch result {
                case .success(let uid):
                    print(uid)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    @objc func tapAddGiftButton() {
        print("tapMakeGiftButton")
    }
    
    @objc func tapStatePrintButton() {
        print("tabPrintButton")
        print("Current Email : ", Auth.auth().currentUser?.email ?? "NOT EMAIL")
        print("Current UID : ", Auth.auth().currentUser?.uid ?? "NOT UID")
        
        for (i, v) in data.enumerated() {
            print(i,i,i,i,i,i,i,i,i,i,i,i,i,i)
            print(v.productName!)
            print(v.brandName!)
            print(v.category!)
            print(v.memo!)
            print(v.useableState)
            print(v.expireDate!)
            print(v.useDate!)
        }
    }
    
    @objc func tapTempButton() {
        print("tapTempButton")
    }
    
    @objc func tapCreateButton() {
        print("tapCreateButton")
        do {
            try FireBaseManager.shared.saveData(
                giftData: Gift(
                    image: UIImage(named: "testImageSTARBUCKSSMALL")!,
                    category: .chicken,
                    brandName: "집앞커피점",
                    productName: "나는",
                    memo: "이디양",
                    useableState: false,
                    expireDate: Date(),
                    useDate: Date()
                )
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func tapReadButton() {
        print("tapReadButton")
        
        do {
            try FireBaseManager.shared.fetchData(completion: { giftDatas in
                print(giftDatas)
                self.data = giftDatas
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func tapUpdateButton() {
        print("tapUpdateButton")
        FireBaseManager.shared.updateData(number: 10)
    }
    
    @objc func tapDeleteButton() {
        print("tapDeleteButton")
        FireBaseManager.shared.deleteDate(10)
    }
}

private extension UIButton {
    convenience init(name: String) {
        self.init()
        self.setTitle(name, for: .normal)
        self.backgroundColor = .systemBrown
    }
}