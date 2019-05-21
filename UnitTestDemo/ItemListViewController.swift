//
//  ItemListViewController.swift
//  UnitTestDemo
//
//  Created by KuanWei on 2018/11/30.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!

    let itemManager = ItemManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataProvider = ItemListDataProvider() as (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)

        dataProvider.itemManager = itemManager

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider

        let itemCellNib = UINib(nibName: String(describing: ItemCell.self), bundle: nil)
        tableView.register(itemCellNib, forCellReuseIdentifier: String(describing: ItemCell.self))

        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem = addBarButtonItem

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showDetails(sender:)),
            name: NSNotification.Name("ItemSelectedNotification"),
            object: nil)
    }

    @objc func showDetails(sender: NSNotification) {
        guard let index = sender.userInfo?["index"] as? Int else { fatalError() }

        let detailVC = DetailViewController()
        detailVC.itemInfo = (itemManager, index)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    @objc func addItem(sender: UIBarButtonItem) {

        let inputVC = InputViewController()
        inputVC.itemManager = itemManager
        present(inputVC, animated: true, completion: nil)
    }

}
