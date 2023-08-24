//
//  DishDetailViewController.swift
//  Yummie
//
//  Created by Cansu Kahraman on 15.08.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

class DishDetailViewController: UIViewController {
    
    @IBOutlet var dishImageView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var caloriesLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var nameField: UITextField!
    
    var dish: Dish!
    
    private func populateView(){
        dishImageView.kf.setImage(with: dish.image?.asURL)
        titleLbl.text = dish.name
        descriptionLbl.text = dish.description
        caloriesLbl.text = dish.formattedCalories
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
    }
    
    @IBAction func placeOrderBtnClicked(_ sender: UIButton) {
        guard let name = nameField.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
            ProgressHUD.showError("Please enter your name!")
            return
        }
        
        ProgressHUD.show("Placing Order...")
        NetworkService.shared.placeOrder(dishId: dish.id ?? "" , name: name) { (result) in
            switch result {
            case .success(_):
                ProgressHUD.showSuccess("You order has been received. 👩🏼‍🍳")
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            }
        }
        
    }

}
