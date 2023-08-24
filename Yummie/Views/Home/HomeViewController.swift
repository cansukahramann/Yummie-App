//
//  HomeViewController.swift
//  Yummie
//
//  Created by Cansu Kahraman on 10.08.2023.
//

import UIKit
import ProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet var CategoryCollectionView: UICollectionView!
    @IBOutlet var PopularCollectionView: UICollectionView!
    @IBOutlet var SpecialsCollectionView: UICollectionView!
    
    var categories: [DishCategory] = []
    var populars: [Dish] = []
    var specials: [Dish] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        CategoryCollectionView.dataSource = self
        CategoryCollectionView.delegate = self
        
        ProgressHUD.show()
        
        navigationItem.backButtonTitle = ""
        
        NetworkService.shared.fetchAllCategories { [weak self] (result) in
            switch result{
            case .success(let allDishes):
                ProgressHUD.dismiss()
                self?.categories = allDishes.categories ?? []
                self?.populars = allDishes.populars ?? []
                self?.specials = allDishes.specials ?? []
                
                self?.CategoryCollectionView.reloadData()
                self?.PopularCollectionView.reloadData()
                self?.SpecialsCollectionView.reloadData()
                
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
    private func registerCell(){
        CategoryCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifer, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifer)
        PopularCollectionView.register(UINib(nibName: DishPortraitCollectionViewCell.identifer, bundle: nil), forCellWithReuseIdentifier: DishPortraitCollectionViewCell.identifer)
        SpecialsCollectionView.register(UINib(nibName: DishLandscapeCollectionViewCell.identifer, bundle: nil), forCellWithReuseIdentifier: DishLandscapeCollectionViewCell.identifer)
    }
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case CategoryCollectionView:
           return categories.count
        case PopularCollectionView:
           return populars.count
        case SpecialsCollectionView:
            return specials.count
        default: return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case CategoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifer, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(category: categories[indexPath.row])
            return cell
        case PopularCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishPortraitCollectionViewCell.identifer, for: indexPath) as! DishPortraitCollectionViewCell
            cell.setup(dish: populars[indexPath.row])
            return cell
        case SpecialsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishLandscapeCollectionViewCell.identifer, for: indexPath) as! DishLandscapeCollectionViewCell
            cell.setup(dish: specials[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CategoryCollectionView{
            let controller = ListDishesViewController.instantiate()
            controller.category = categories[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }else {
            let controller = DishDetailViewController.instantiate()
            controller.dish = collectionView == PopularCollectionView ? populars[indexPath.row] :
                specials[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
