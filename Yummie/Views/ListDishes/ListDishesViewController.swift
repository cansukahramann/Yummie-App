//
//  ListDishesViewController.swift
//  Yummie
//
//  Created by Cansu Kahraman on 15.08.2023.
//

import UIKit
import ProgressHUD

class ListDishesViewController: UIViewController {
    
    @IBOutlet var tableVİew: UITableView!
    
    var category: DishCategory!
    var dishes: [Dish] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        
        title = category.title
        regesiterCell()
        
        ProgressHUD.show()
        NetworkService.shared.fetchCategoryDishes(categoryId: category.id ?? "") { [weak self] (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let dishes):
                    ProgressHUD.dismiss()
                    self?.dishes = dishes
                    self?.tableVİew.reloadData()
                case.failure(let error):
                    ProgressHUD.showError(error.localizedDescription)
                }
            }
        }
    }

    private func regesiterCell(){
        tableVİew.register(UINib(nibName: "DishListTableViewCell", bundle: nil), forCellReuseIdentifier: DishListTableViewCell.identifer)
    }
}

extension ListDishesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DishListTableViewCell.identifer) as! DishListTableViewCell
        cell.setup(dish: dishes[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DishDetailViewController.instantiate()
        controller.dish = dishes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

