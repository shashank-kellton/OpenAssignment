import UIKit
import SVProgressHUD
import SDWebImage

class DogsBreedDetailVC: UIViewController {
    
    // OUTLETS HERE
    
    // VARIABLES HERE
    var viewModel = DogsBreedDetailViewModel()
    var collectionView: UICollectionView!
    var breedName: String?
    let layout = UICollectionViewFlowLayout()



    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
        setupCollectionView()
        registerCell()
        getDogsBreedDetailApiCall()
        self.navigationController?.navigationBar.tintColor = UIColor.kPrimaryColor

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
    
    private func registerCell() {
        self.collectionView.register(UINib(nibName: "DogImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DogImageCollectionViewCell")
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
            SVProgressHUD.dismiss();
            print("Internet disconnected")
            Alert.showSnackBar(message: AppStrings.noInternetConnection.localized)
        }
        
        self.viewModel.serverErrorStatus = {
            SVProgressHUD.dismiss();
            print("Server Error / Unknown Error")
            if self.viewModel.apiErrorModel?.statusCode == 401 {
                DispatchQueue.main.async {
                    // switch to login screen
                }
            }
        }
        
        self.viewModel.dogsBreedDetailAPISuccess = {
            SVProgressHUD.dismiss();
            self.collectionView.reloadData()
        }
    }
    
    func getDogsBreedDetailApiCall() {
        SVProgressHUD.show();
        self.viewModel.getDogsBreedDetailApi(breedName: breedName)
    }
    

}

extension DogsBreedDetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dogsBreedDetailModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogImageCollectionViewCell", for: indexPath) as? DogImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.configureCell(viewModel: viewModel.dogsBreedDetailModel?[indexPath.row], isFromFav: false)
        cell.delegate = self
        cell.likeDislikeBtn.tag = indexPath.row
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

extension DogsBreedDetailVC: DogImageCollectionViewCellDelegate {
    
    func didTapOnFavoriteButton(cell: DogImageCollectionViewCell, index: Int,dogsBreedDetailModel: DogsBreedDetailModel?) {
        if (viewModel.dogsBreedDetailModel?[index].isLiked == true){
            viewModel.dogsBreedDetailModel?[index].isLiked = false
            FavoritesManager.shared.removeFavorite(dogsBreedDetailModel: dogsBreedDetailModel!)
        }else{
            viewModel.dogsBreedDetailModel?[index].isLiked = true
            FavoritesManager.shared.addFavorite(dogsBreedDetailModel: dogsBreedDetailModel!)
        }
        self.collectionView.reloadData()
    }
    
    
}
