//
//  DogsBreedVC.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import UIKit
import SVProgressHUD
class DogsBreedVC: UIViewController {
    
    // OUTLETS HERE
    @IBOutlet weak var tableView: UITableView!
    // VARIABLES HERE
    var viewModel = DogsBreedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerCell()
        getDogsBreedApiCall()
        setupNavigationBar()
    }
    
    
    private func registerCell(){
        self.tableView.register(UINib(nibName: "DogsBreedSubCategoryCell", bundle: nil), forCellReuseIdentifier: "DogsBreedSubCategoryCell")
        self.tableView.register(UINib(nibName: "DogsBreedCategoryCell", bundle: nil), forCellReuseIdentifier: "DogsBreedCategoryCell")
        
    }
    private func setupViewModel() {
        self.viewModel.showAlertClosure = {
            let alert = self.viewModel.alertMessage ?? ""
            print(alert)
        }
        
        self.viewModel.updateLoadingStatus = {
            if self.viewModel.isLoading {
                print("LOADING...")
            } else {
                print("DATA READY")
            }
        }
        
        self.viewModel.internetConnectionStatus = {
            print("Internet disconnected")
            // show UI Internet is disconnected
            SVProgressHUD.dismiss();
            Alert.showSnackBar(message: AppStrings.noInternetConnection.localized)
        }
        
        self.viewModel.serverErrorStatus = {
            SVProgressHUD.dismiss();
            print("Server Error / Unknown Error")
            // show UI Server is Error
            Alert.showSnackBar(message: self.viewModel.apiErrorModel?.message ?? AppStrings.someThingWentWrong.localized)
            if(self.viewModel.apiErrorModel?.statusCode == 401){
                DispatchQueue.main.async {
                    // switch to login screen
                }
            }
        }
        
        self.viewModel.dogsBreedAPISuccess = {
            SVProgressHUD.dismiss();
            self.tableView.reloadData()
        }
                
    }
    func getDogsBreedApiCall(){
        SVProgressHUD.show();
        self.viewModel.getDogsBreedApi(data: [:])
    }

    private func setupNavigationBar() {
        self.view.backgroundColor = UIColor.kPrimaryColor
        self.title = "Dog Breeds"
        let favoriteButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action:  #selector(favoriteButtonTapped))
        favoriteButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = favoriteButton
    }
    @objc private func favoriteButtonTapped() {
        let favoriteVC = FavoriteVC()
        self.navigationController?.pushViewController(favoriteVC, animated: true)
    }


}


extension DogsBreedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].subcategories.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].breed
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DogsBreedSubCategoryCell", for: indexPath) as? DogsBreedSubCategoryCell
            else{ return UITableViewCell()}
            let subcategory = viewModel.sections[indexPath.section].subcategories[indexPath.row]
            cell.textLabel?.text = subcategory.capitalized
        cell.backgroundColor = UIColor.kPrimaryColor1
        cell.selectionStyle = .none
            return cell
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("DogsBreedCategoryCell", owner: self, options: nil)?.last as? DogsBreedCategoryCell
        header?.backgroundColor = UIColor.kPrimaryColor
        let breedKey = viewModel.breedKeys[section]
        header?.dogsBreedCategoryLbl.text = breedKey.capitalized
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
        header?.tag = section
        header?.addGestureRecognizer(tapGesture)
        header?.isUserInteractionEnabled = true
        return header
    }
    
    @objc func headerTapped(_ sender: UITapGestureRecognizer) {
        let dogsBreedDetailVC = DogsBreedDetailVC()
        guard let section = sender.view?.tag else { return }
        let breedKey = viewModel.breedKeys[section]
        dogsBreedDetailVC.breedName = breedKey
        self.navigationController?.pushViewController(dogsBreedDetailVC, animated: true)
    }
}



