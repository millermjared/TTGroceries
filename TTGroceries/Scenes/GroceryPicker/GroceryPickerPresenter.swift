//
//  GroceryPickerPresenter.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/14/22.
//

import Foundation

protocol GroceryPickerPresenterInput {
    func presentGroceryPicker(_ groceries: [(Grocery, Bool)])
}

protocol GroceryPickerPresenterOutput {
    func display(_ GroceryPicker: GroceryPickerViewModel)
}

struct GroceryPickerPresenter: GroceryPickerPresenterInput {
    
    let output: GroceryPickerPresenterOutput
    
    func presentGroceryPicker(_ groceries: [(Grocery, Bool)]) {
        let viewModel = GroceryPickerViewModel(groceries: groceries)
        output.display(viewModel)
    }
}
