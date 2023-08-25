//
//  ListOrdersViewController.swift
//  Yummie
//
//  Created by Cansu Kahraman on 16.08.2023.
//

import UIKit
import ProgressHUD

class ListOrdersViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    
    var orders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Orders"
        registerCells()
        
        ProgressHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
      
        
        NetworkService.shared.fetchOrders { [weak self] (result) in
            DispatchQueue.main.async {
                switch result{
                case.success(let orders):
                    ProgressHUD.dismiss()
                    
                    self?.orders = orders
                    self?.tableView.reloadData()
                case.failure(let error):
                    ProgressHUD.showError(error.localizedDescription)
                }
            }
        }
    }

    private func registerCells(){
        tableView.register(UINib(nibName: "DishListTableViewCell", bundle: nil), forCellReuseIdentifier: DishListTableViewCell.identifer)
    }
}

 
extension ListOrdersViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DishListTableViewCell.identifer) as! DishListTableViewCell
            cell.setup(order: orders[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DishDetailViewController.instantiate()
        controller.dish = orders[indexPath.row].dish
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

