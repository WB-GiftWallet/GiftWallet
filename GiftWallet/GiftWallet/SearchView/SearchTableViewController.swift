//
//  SearchTableViewController.swift
//  GiftWallet
//
//  Created by Baem on 2023/03/01.
//

import UIKit

final class SearchTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "giftCustomCell")
    }
}
