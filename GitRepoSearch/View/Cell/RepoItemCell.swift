//
//  RepoItemCell.swift
//  GitRepoSearch
//
//  Created by Bhalodiya, Keyur Ratilal | Kb | ECMPD on 2022/10/25.
//

import UIKit

final class RepoItemCell: UITableViewCell {
    
    @IBOutlet weak var repoFullNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoUrlLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPofileUrl: UILabel!
    
    var linkTapHandler: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
        repoFullNameLabel.text = nil
        repoDescriptionLabel.text = nil
        repoUrlLabel.text = nil
        userNameLabel.text = nil
    }
    
    private func setupView() {
        userImageView.layer.cornerRadius = 8.0
        userImageView.clipsToBounds = true
    }
    
    func style(with item: Item) {
        repoFullNameLabel.text = item.fullName
        repoDescriptionLabel.text = item.description
        repoUrlLabel.attributedText = urlAttributeString(string: item.htmlURL)
        userNameLabel.text = item.owner?.login
        userPofileUrl.attributedText = urlAttributeString(string: item.owner?.htmlURL)
        ImageManager.sharedInstance.downloadImageFromURL(item.owner?.avatarURL ?? "") { (success, image) -> Void in
            if success && image != nil {
                self.userImageView?.image = image
            }
        }
        addTapGestureRecognizer()
    }
    
}

private extension RepoItemCell {
    
    private func urlAttributeString(string: String?) -> NSMutableAttributedString? {
        guard let url = string else {
            return nil
        }
        let attributedString = NSMutableAttributedString.init(string: url)
        let range = NSRange.init(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.link, range: range)
        return attributedString
    }
    
    private func addTapGestureRecognizer() {
        let tapRepoUrl = UITapGestureRecognizer(target: self, action: #selector(tapRepoUrlLabel(sender:)))
        repoUrlLabel.isUserInteractionEnabled = true
        repoUrlLabel.addGestureRecognizer(tapRepoUrl)
        let tapUserProfileUrl = UITapGestureRecognizer(target: self, action: #selector(tapUserProfileUrl(sender:)))
        userPofileUrl.isUserInteractionEnabled = true
        userPofileUrl.addGestureRecognizer(tapUserProfileUrl)
    }
    
    
    @objc private func tapRepoUrlLabel(sender: UITapGestureRecognizer) {
        linkTapHandler?(1)
    }
    
    @objc private func tapUserProfileUrl(sender: UITapGestureRecognizer) {
        linkTapHandler?(2)
    }
}

