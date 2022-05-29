//
//  GroceryListRouter.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/17/22.
//

import Foundation
import UIKit

extension GroceryListViewController: GroceryListPresenterOutput {}
extension GroceryListPresenter: GroceryListInteractorOutput {}
extension GroceryListInteractor: GroceryListViewOutput {}

enum GroceryListRouter {
    case ListView
    
    func targetViewController() -> UIViewController? {
        switch self {
        case .ListView:
            let service = StaticGroceryListService()
            let viewController = GroceryListViewController()
            let presenter = GroceryListPresenter(output: viewController)
            let interactor = GroceryListInteractor(output: presenter, service: service)
            viewController.interactor = interactor
            return viewController
        }
    }
}
