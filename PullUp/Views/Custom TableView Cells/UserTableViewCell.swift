//
//  TableViewCell.swift
//  PullUp
//
//  Created by Vikram Singh on 4/15/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var mutualsLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadUser(user: User){
        print("USERS NAME IS \(user.name)")
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        profilePictureImageView.image = UIImage(systemName: "person")
//        nameLabel.text =
//        nameLabel.s
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.username)"
        
        let profileImagePath = "images/\(user.profilePictureFileName)"
        StorageManager.shared.downloadURL(for: profileImagePath, completion: { [weak self] result in
            switch result{
            case .success(let url):
                self?.downloadImage(imageView: self!.profilePictureImageView, url: url)
                print("LOG: success getting downloadURL when loading user into UserTableViewCell")
            case .failure(let error):
                print("ERROR: failed to getdownload url when loading user into UserTableViewCell: \(error)")
            }
        })
        
    }
    
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else{
                print("ERROR: something went wrong when downloading image. Data was nil or error wasn't nil.")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
}
