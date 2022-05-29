//
//  GroceryPickerInteractor.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/14/22.
//

import Foundation
import RxSwift

protocol GroceryPickerInteractorInput {
    func toggleGroceryItem(_ grocery: Grocery)
    func loadGrocerySelections()
}

protocol GroceryPickerInteractorOutput {
    func presentGroceryPicker(_ groceries: [(Grocery, Bool)])
}

struct GroceryPickerInteractor: GroceryPickerInteractorInput {
    let output: GroceryPickerInteractorOutput
    let service: GroceryListService
    let disposeBag = DisposeBag()
    
    init(output: GroceryPickerInteractorOutput, service: GroceryListService) {
        self.output = output
        self.service = service
        service.api().subscribe(onNext: { newGroceryList in
            output.presentGroceryPicker(newGroceryList)
        })
        .disposed(by: disposeBag)
    }
    
    func toggleGroceryItem(_ grocery: Grocery) {
        service.toggle(groceryItem: grocery)
//        loadGrocerySelections()
    }
    
    func loadGrocerySelections() {
        let allGroceries = service.allGroceries()
        let selectedGroceries = service.selectedGroceries()
        
        let grocerySelections = allGroceries.map { grocery in
            return (grocery, selectedGroceries.contains(grocery))
        }
        output.presentGroceryPicker(grocerySelections)
    }
}
