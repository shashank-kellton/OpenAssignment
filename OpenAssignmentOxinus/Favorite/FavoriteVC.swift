//
//  FavoriteVC.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 24/06/24.
//

import UIKit

class FavoriteVC: UIViewController {
    
    // VARIABLES HERE
    var viewModel = DogsBreedDetailViewModel()
    var collectionView: UICollectionView!
    var breedName: String?
    let layout = UICollectionViewFlowLayout()
    var model: [DogsBreedDetailModel] = [DogsBreedDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        getFavorites()
        setupCollectionView()
        self.collectionView.reloadData()
        registerCell()
    }
    
    private func getFavorites() {
        model = FavoritesManager.shared.getFavorites()
        if(model.count == 0){
            Alert.showSnackBar(message: AppStrings.nofavFound.localized)
        }
    }


    private func setupCollectionView() {
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DogImageCollectionViewCell.self, forCellWithReuseIdentifier: "DogImageCollectionViewCell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        self.title = "Fovorite Dog Breeds"
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action:  #selector(filterButtonTapped))
        let all = UIBarButtonItem(title: "All", style: .plain, target: self, action:  #selector(allButtonTapped))
        navigationItem.rightBarButtonItems = [all,filter]
    }
    
    private func showBreedSelectionSheet() {
        let alertController = UIAlertController(title: "Select Breed", message: nil, preferredStyle: .actionSheet)
        
        var uniqueBreeds: Set<String> = []
        
        for breed in model {
            if !uniqueBreeds.contains(breed.breedName) {
                uniqueBreeds.insert(breed.breedName)
                let action = UIAlertAction(title: breed.breedName.capitalized, style: .default) { _ in
                    self.model = FavoritesManager.shared.getFavorites(for: breed.breedName)
                    self.collectionView.reloadData()

                }
                alertController.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @objc private func filterButtonTapped() {
        model = FavoritesManager.shared.getFavorites()
        showBreedSelectionSheet()
    }
    
    @objc private func allButtonTapped() {
        model = FavoritesManager.shared.getFavorites()
        collectionView.reloadData()
    }

    private func registerCell() {
        self.collectionView.register(UINib(nibName: "DogImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DogImageCollectionViewCell")
    }
                
    

}


extension FavoriteVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogImageCollectionViewCell", for: indexPath) as? DogImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(viewModel: model[indexPath.row],isFromFav: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let paddingSpace = layout.minimumInteritemSpacing * (itemsPerRow - 1) + layout.sectionInset.left + layout.sectionInset.right
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
}


