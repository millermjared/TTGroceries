//
//  GroceryListInteractor.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/14/22.
//

import UIKit
import RxSwift
import RxCocoa


protocol GroceryListInteractorInput {
    func loadCurrentGroceryList()
    func addNewGroceryItem(inPresentationContext: (UIViewController & UIAdaptivePresentationControllerDelegate))
}

protocol GroceryListInteractorOutput {
    func presentGroceryList(_ groceryList: [Grocery])
}

struct GroceryListInteractor: GroceryListInteractorInput {
    
    let output: GroceryListInteractorOutput
    let service: GroceryListService

    func addNewGroceryItem(inPresentationContext presentationContext: (UIViewController & UIAdaptivePresentationControllerDelegate)) {
        if let targetViewController = GroceryPickerRouter.PickerView.targetViewController(groceryListService: service) {
            targetViewController.presentationController?.delegate = presentationContext
            presentationContext.present(targetViewController, animated: true, completion: nil)
        }
    }
    
    func loadCurrentGroceryList() {
        let selectedGroceries = service.selectedGroceries()
        output.presentGroceryList(selectedGroceries)
    }

}
