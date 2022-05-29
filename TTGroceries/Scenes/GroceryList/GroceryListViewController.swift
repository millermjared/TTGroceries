//
//  ViewController.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/12/22.
//

import Thumbprint
import RxSwift
import RxCocoa

struct GroceryListViewModel {
    let groceries: [Grocery]
}

protocol GroceryListViewInput {
    func display(_ viewModel: GroceryListViewModel)
}

protocol GroceryListViewOutput {
    func loadCurrentGroceryList()
    func addNewGroceryItem(inPresentationContext: (UIViewController & UIAdaptivePresentationControllerDelegate))
}

class GroceryListCell: UITableViewCell {
    static let Identifier = "GroceryListCell"
    
    let groceryNameLabel: Label
    
    required init?(coder: NSCoder) {
        self.groceryNameLabel = Label(textStyle: .title3)
        super.init(coder: coder)
        addSubview(self.groceryNameLabel)
        self.groceryNameLabel.snapToSuperview(edges: [.leading, .top])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.groceryNameLabel = Label(textStyle: .title3)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(self.groceryNameLabel)
        self.groceryNameLabel.snapToSuperview(edges: [.leading, .top])
    }
    
    func configure(with grocery: Grocery) {
        groceryNameLabel.text = grocery.name
    }
}

class GroceryListViewController: UIViewController {
    
    //MARK: - Dependencies
    var interactor: GroceryListViewOutput?
    
    //MARK: - Views
    let groceryListTableView = UITableView()
    
    //MARK: - Rx
    let disposeBag = DisposeBag()
    var groceries: BehaviorRelay<[Grocery]> = BehaviorRelay(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupReactions()
        view.addSubview(groceryListTableView)
        groceryListTableView.snapToSuperview(edges: .all)
        groceryListTableView.register(GroceryListCell.self, forCellReuseIdentifier: GroceryListCell.Identifier)
        
        title = "Grocery List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.loadCurrentGroceryList()
    }
    
    func setupReactions() {
        groceries.bind(to: groceryListTableView.rx
                        .items(cellIdentifier: GroceryListCell.Identifier,
                                    cellType: GroceryListCell.self)) { row, grocery, cell in
            cell.configure(with: grocery)
        }
        .disposed(by: disposeBag)
    }
    
    @objc func addButtonClicked() {
        interactor?.addNewGroceryItem(inPresentationContext: self)
    }
}

extension GroceryListViewController: GroceryListViewInput {
    func display(_ viewModel: GroceryListViewModel) {
        groceries.accept(viewModel.groceries)
    }
}

extension GroceryListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        interactor?.loadCurrentGroceryList()
    }
}
