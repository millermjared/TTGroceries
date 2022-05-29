//
//  GroceryPickerRouter.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/17/22.
//

import Foundation
import UIKit

extension GroceryPickerViewController: GroceryPickerPresenterOutput {}
extension GroceryPickerPresenter: GroceryPickerInteractorOutput {}
extension GroceryPickerInteractor: GroceryPickerViewOutput {}

enum GroceryPickerRouter {
    case PickerView
    
    func targetViewController(groceryListService: GroceryListService? = nil) -> UIViewController? {
        switch self {
        case .PickerView:
            guard let service = groceryListService else {
                print("An instance of GroceryListService is required to construct this interaction")
                return nil
            }
            let viewController = GroceryPickerViewController()
            let presenter = GroceryPickerPresenter(output: viewController)
            let interactor = GroceryPickerInteractor(output: presenter, service: service)
            viewController.interactor = interactor
            let navController = UINavigationController(rootViewController: viewController)
            return navController
        }
    }
}
