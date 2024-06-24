//
//  DogImageCollectionViewCell.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import UIKit


protocol DogImageCollectionViewCellDelegate: AnyObject {
    func didTapOnFavoriteButton(cell: DogImageCollectionViewCell, index: Int, dogsBreedDetailModel: DogsBreedDetailModel?)
}

class DogImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dogImageView: UIImageView!
    weak var delegate: DogImageCollectionViewCellDelegate?
    @IBOutlet weak var likeDislikeBtn: UIButton!
    var dogsBreedDetailModel : DogsBreedDetailModel?
    
    func configureCell(viewModel: DogsBreedDetailModel?, isFromFav:Bool?){
        self.dogsBreedDetailModel = viewModel
        if let url = URL(string: viewModel?.url ?? "") {
            dogImageView.sd_setImage(with: url, completed: nil)
        }
        dogImageView.contentMode = .scaleAspectFill
        dogImageView.clipsToBounds = true
        
        if(!(isFromFav ?? false)){
            if (viewModel?.isLiked ?? false){
                likeDislikeBtn.setBackgroundImage(UIImage(named: "like"), for: .normal)
            }else{
                likeDislikeBtn.setBackgroundImage(UIImage(named: "dislike"), for: .normal)
            }
            
        }

    }
    
    @IBAction func likeDislikeBtnClick(_ sender: UIButton) {
        self.delegate?.didTapOnFavoriteButton(cell: self, index: sender.tag,dogsBreedDetailModel: self.dogsBreedDetailModel)
    }

    }
