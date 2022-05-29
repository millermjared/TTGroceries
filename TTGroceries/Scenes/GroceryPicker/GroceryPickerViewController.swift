//
//  ViewController.swift
//  TTGroceries
//
//  Created by Mathew Miller on 5/12/22.
//

import Thumbprint
import RxSwift
import RxCocoa

struct GroceryPickerViewModel {
    let groceries: [(Grocery, Bool)]
}

protocol GroceryPickerViewInput {
    var currentGroceries: [Grocery] {get set}
    func display(_ viewModel: GroceryPickerViewModel)
}

protocol GroceryPickerViewOutput {
    func loadGrocerySelections()
    func toggleGroceryItem(_ grocery: Grocery)
}

class GroceryPickerCell: UICollectionViewCell {
    static let Identifier = "GroceryPickerCell"
    
    let groceryNameLabel: ToggleChip
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override init(frame: CGRect) {
        let sizer = UIView()
        self.groceryNameLabel = ToggleChip()
        super.init(frame: frame)
        addSubview(sizer)
        sizer.snapToSuperview(edges: [.trailing, .leading], inset: 3.0)
        sizer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.33).isActive = true
        sizer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sizer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sizer.addSubview(self.groceryNameLabel)
        self.groceryNameLabel.snapToSuperview(edges: .all)
    }
    
    func configure(with grocery: Grocery, selected: Bool) {
        groceryNameLabel.text = grocery.name
        groceryNameLabel.isSelected = selected
        groceryNameLabel.isUserInteractionEnabled = false
    }
}

class GroceryPickerViewController: UIViewController {
    
    //MARK: - Dependencies
    var interactor: GroceryPickerViewOutput?
    
    //MARK: - Views
    var groceryItemsCollectionView: UICollectionView!
    
    //MARK: - Rx
    let disposeBag = DisposeBag()
    var groceries: BehaviorRelay<[(Grocery, Bool)]> = BehaviorRelay(value: [])

    var currentGroceries: [Grocery] = [] {
        didSet {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        groceryItemsCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        view.addSubview(groceryItemsCollectionView)
        groceryItemsCollectionView.snapToSuperview(edges: .all)
        groceryItemsCollectionView.register(GroceryPickerCell.self, forCellWithReuseIdentifier: GroceryPickerCell.Identifier)
        setupReactions()
        title = "Add Groceries"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked))
    }
    
    func setupReactions() {
        groceries.bind(to: groceryItemsCollectionView.rx.items) {(collectionView, row, element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroceryPickerCell.Identifier, for: IndexPath(item: row, section: 0))
            if let cell = cell as? GroceryPickerCell {
                cell.configure(with: element.0, selected: element.1)
            }
            return cell
        }
        .disposed(by: disposeBag)

        groceryItemsCollectionView.rx.modelSelected((Grocery, Bool).self).subscribe(
            onNext: { (model) in
                print("model \(model.0.name) selected")
                self.interactor?.toggleGroceryItem(model.0)
            }
        )
        .disposed(by: disposeBag)
        
        interactor?.loadGrocerySelections()
    }
    
    @objc func doneButtonClicked() {
        if let presentationController = navigationController?.presentationController {
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        }
        navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension GroceryPickerViewController: GroceryPickerViewInput {
    
    func display(_ viewModel: GroceryPickerViewModel) {
        groceries.accept(viewModel.groceries)
    }
    
}

