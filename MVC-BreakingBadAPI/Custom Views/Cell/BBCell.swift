//
//  BBCell.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 22.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit
import SDWebImage

class BBCell: UITableViewCell {
    
    static let reuseID = "BBCell"
    let characterImageView = BBImage(frame: .zero)
    let characterName = BBTitleLabel(textAlignment: .left, fontSize: 26)
    let characterNickname = BBTitleLabel(textAlignment: .left, fontSize: 24, textColor: .systemOrange)
    let characterStatus = BBTitleLabel(textAlignment: .left, fontSize: 22)
    let characterPortrayed = BBTitleLabel(textAlignment: .left, fontSize: 20, textColor: .systemOrange)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(character: Character) {
        characterName.text = character.name
        characterNickname.text = character.nickname
        characterStatus.text = character.status
        characterPortrayed.text = character.portrayed
        
        characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        characterImageView.sd_setImage(with: URL(string: character.img), placeholderImage: UIImage(named: "placeholder"))
    }
    
    private func configure() {
        addSubviews(characterImageView, characterName, characterNickname, characterStatus, characterPortrayed)
        
        let heightAnchor: CGFloat = 40
        let trailingAnchor: CGFloat = -20
        let leadingAnchor: CGFloat = 24
        
        NSLayoutConstraint.activate([
            characterImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            characterImageView.heightAnchor.constraint(equalToConstant: 150),
            characterImageView.widthAnchor.constraint(equalToConstant: 150),
            
            characterName.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            characterName.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: leadingAnchor),
            characterName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingAnchor),
            characterName.heightAnchor.constraint(equalToConstant: heightAnchor),
            
            characterNickname.topAnchor.constraint(equalTo: characterName.topAnchor, constant: 40),
            characterNickname.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: leadingAnchor),
            characterNickname.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingAnchor),
            characterNickname.heightAnchor.constraint(equalToConstant: heightAnchor),
            
            characterStatus.topAnchor.constraint(equalTo: characterNickname.topAnchor, constant: 40),
            characterStatus.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: leadingAnchor),
            characterStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingAnchor),
            characterStatus.heightAnchor.constraint(equalToConstant: heightAnchor),
            
            characterPortrayed.topAnchor.constraint(equalTo: characterStatus.topAnchor, constant: 40),
            characterPortrayed.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: leadingAnchor),
            characterPortrayed.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingAnchor),
            characterPortrayed.heightAnchor.constraint(equalToConstant: heightAnchor)
        ])
    }
}