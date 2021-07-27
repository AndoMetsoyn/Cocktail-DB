//
//  DrinksViewController.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/25/21.
//

import UIKit
import MBProgressHUD

class DrinksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterDrinkViewControllerDelegate {

    private let CELL_HEIGHT: CGFloat = 117
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var startPagination = false
    private var isFilter = false
    private var filterCategoryList: [CategoryList] = []
    private var categoryList: [CategoryList] = []
    private var _categoryList: [CategoryList] {
        get {
           return self.isFilter ? self.filterCategoryList : self.categoryList
        }
    }
    private var model: [String: [CategoryDrinks]] = [:]
    
    @IBAction func onFilter(_ sender: UIBarButtonItem) {
        self.pushFilterViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.getCatecoryList()
    }

    private func configureUI() {
        self.title = "Drinks"
        self.configureTableView()
    }
        
    private func configureTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "DrinksTableViewCell", bundle: nil), forCellReuseIdentifier: "DrinksTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func getFirstCategoryDrinks() {
        if let catecory = self._categoryList.first?.strCategory {
            self.getCatecoryDrinks(category: catecory)
        }
    }
    
    private func applyFilter() {
        if self.filterCategoryList.count > 0 {
            self.model = [:]
            self.getFirstCategoryDrinks()
        }
    }
    
    //MARK: - push or present new view controllers
    private func pushFilterViewController() {
        let storyboard = UIStoryboard.App.Drinks.storyboard
        let vc = storyboard.instantiateViewController(FilterDrinkViewController.self)
        vc.categoryModel = self.categoryList
        vc.filterCategoryList = self.filterCategoryList
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Request
    private func getCatecoryList() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkAdapter.request(target: .categories,
        success: { [weak self] (response) in
            do {
                let resp = try response.map(DrinksBaseModel<[CategoryList]>.self)
                if let _categoryList = resp.drinks {
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    self?.categoryList = _categoryList
                    self?.getFirstCategoryDrinks()
                } else {
                    AlertHelper.showAlert(message: "something went wrong", title: "Error")
                }
            } catch(let err) {
                AlertHelper.showAlert(message: err.localizedDescription, title: "Error")
            }
        },error: { (err) in
            AlertHelper.showAlert(message: err.localizedDescription, title: "Error")
        }) { (failure) in
            AlertHelper.showAlert(message: failure, title: "Error")
        }
    }
    
    private func getCatecoryDrinks(category: String, isPagination: Bool = false) {
        if !isFilter {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        NetworkAdapter.request(target: .categoryFilter(category: category),
        success: { [weak self] (response) in
            do {
                let resp = try response.map(DrinksBaseModel<[CategoryDrinks]>.self)
                if let _categoryDrinks = resp.drinks {
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    self?.model[category] = _categoryDrinks
                    self?.tableView.separatorStyle = .singleLine
                    self?.tableView.reloadData()
                
                    if isPagination {
                        self?.startPagination = false
                    }
                } else {
                    AlertHelper.showAlert(message: "something went wrong", title: "Error")
                }
            } catch(let err) {
                AlertHelper.showAlert(message: err.localizedDescription, title: "Error")
            }
        },error: { (err) in
            AlertHelper.showAlert(message: err.localizedDescription, title: "Error")
        }) { (failure) in
            AlertHelper.showAlert(message: failure, title: "Error")
        }
    }
    
    //MARK: - FilterDrinkViewControllerDelegate
    func apply(filter: [CategoryList]) {
        self.isFilter = true
        self.filterCategoryList = filter
        self.applyFilter()
    }

    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    func getModelKey(section: Int) -> String? {
        if let modelKey = self._categoryList[section].strCategory {
            return modelKey
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectinView = HeaderSectionView()
        sectinView.title = self._categoryList[section].strCategory ?? ""
        return sectinView
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let modelKey = self.getModelKey(section: section) else { return 0 }
        return self.model[modelKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let modelKey = self.getModelKey(section: indexPath.section) else { return UITableViewCell() }
        guard let model = self.model[modelKey]?[indexPath.row] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinksTableViewCell", for: indexPath) as! DrinksTableViewCell
        cell.setModel(model)
        return cell
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.isStartPagination(indexPath: indexPath) {
            if !self.startPagination {
                let nextCatecoryIndex = indexPath.section + 1
                if nextCatecoryIndex <= self._categoryList.count - 1 {
                    if let nexCategory = self._categoryList[nextCatecoryIndex].strCategory {
                        self.getCatecoryDrinks(category: nexCategory, isPagination: true)
                        self.startPagination = true
                    }
                }
            }
        }
        
    }

    //MARK: - pagination
    private func isStartPagination(indexPath: IndexPath) -> Bool {
        if self.model.count == indexPath.section + 1 {
            if let category = self._categoryList[indexPath.section].strCategory, indexPath.row + 3 >= self.model[category]!.count {
                return true
            }
        }
        return false
    }
        
}

