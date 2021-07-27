//
//  FilterDrinkViewController.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/26/21.
//

import UIKit

protocol FilterDrinkViewControllerDelegate: class {
    func apply(filter: [CategoryList])
}

class FilterDrinkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: FilterDrinkViewControllerDelegate!
    @IBOutlet weak var applyFilter: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    public var categoryModel: [CategoryList] = []
    public var filterCategoryList: [CategoryList] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    @IBAction func onApplyFilter(_ sender: UIButton) {
        self.delegate?.apply(filter: self.filterCategoryList)
        self.navigationController?.popViewController(animated: true)
    }

    private func configureUI() {
        self.navigationController?.navigationBar.tintColor = .black
        self.configureApplyFilterButton()
        self.configureTableView()
    }
    
    private func configureTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func configureApplyFilterButton() {
        self.applyFilter.isEnabled = false
        self.applyFilter.alpha = 0.5
    }
    
    //MARK: -  UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.tintColor = .black
        if let categoryName = self.categoryModel[indexPath.row].strCategory {
            cell.textLabel?.text = categoryName
            
            
            let isSelected = self.filterCategoryList.contains { (item) -> Bool in
                item.strCategory == categoryName
            }
            cell.accessoryType =  isSelected ? .checkmark : .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let categoryName = self.categoryModel[indexPath.row].strCategory {
            let isSelected = self.filterCategoryList.contains { (item) -> Bool in
                item.strCategory == categoryName
            }
            self.applyFilter.isEnabled = true
            self.applyFilter.alpha = 1
            if isSelected {
                self.filterCategoryList.removeAll { (item) -> Bool in
                    item.strCategory == categoryName
                }
            } else {
                self.filterCategoryList.append(self.categoryModel[indexPath.row])
            }
        
            cell?.accessoryType =  !isSelected ? .checkmark : .none
        }
    }

}
