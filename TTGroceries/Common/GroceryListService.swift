//
//  GroceryListService.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/24/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol GroceryListService {
    func add(groceryItem: Grocery)
    func remove(groceryItem: Grocery)
    func update(groceryItem: Grocery)
    func toggle(groceryItem: Grocery)
    func selectedGroceries()->[Grocery]
    func allGroceries()->[Grocery]
    func api() -> Observable<[(Grocery, Bool)]>
}

class StaticGroceryListService: GroceryListService {
    
    var currentGroceries: [Grocery] = []
    var groceries: BehaviorRelay<[(Grocery, Bool)]> = BehaviorRelay(value: [
        (Grocery(name: "apples"), false),
        (Grocery(name: "oranges"), false)
    ])
    
    func api() -> Observable<[(Grocery, Bool)]> {
        return groceries.asObservable()
    }
    
    private func publishGroceryList() {
        let allGroceries = allGroceries()
        let selectedGroceries = selectedGroceries()
        
        let grocerySelections = allGroceries.map { grocery in
            return (grocery, selectedGroceries.contains(grocery))
        }
        
        groceries.accept(grocerySelections)
    }
    
    func add(groceryItem: Grocery) {
        if !currentGroceries.contains(groceryItem) {
            currentGroceries.append(groceryItem)
        }
    }
    
    func remove(groceryItem: Grocery) {
        currentGroceries = currentGroceries.filter{ $0 != groceryItem }
    }
    
    func update(groceryItem: Grocery) {
        let index = currentGroceries.firstIndex { candidate in
            candidate.name == groceryItem.name
        }
        if let index = index {
            currentGroceries[index] = groceryItem
        }
    }
    
    func toggle(groceryItem: Grocery) {
        let index = currentGroceries.firstIndex { candidate in
            candidate.name == groceryItem.name
        }
        if let index = index {
            currentGroceries.remove(at: index)
        } else {
            currentGroceries.append(groceryItem)
        }
        publishGroceryList()
    }
    
    func selectedGroceries() -> [Grocery] {
        return currentGroceries
    }
    
    func allGroceries() -> [Grocery] {
        return [
        Grocery(name: "apples"),
        Grocery(name: "oranges")
        ]
    }
}
