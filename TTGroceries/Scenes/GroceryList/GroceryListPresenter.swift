//
//  GroceryListPresenter.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/14/22.
//

import Foundation

protocol GroceryListPresenterInput {
    func presentGroceryList(_ groceryList: [Grocery])
}

protocol GroceryListPresenterOutput {
    func display(_ groceryList: GroceryListViewModel)
}

struct GroceryListPresenter: GroceryListPresenterInput {
    
    let output: GroceryListPresenterOutput
    
    func presentGroceryList(_ groceryList: [Grocery]) {
        let viewModel = GroceryListViewModel(groceries: groceryList)
        output.display(viewModel)
    }
}
