//
//  ArticleCell.swift
//  TechnicalBookStore
//
//  Created by Tomohiro Fukuya on 2020/06/14.
//  Copyright © 2020 Tomohiro Fukuya. All rights reserved.
//

import UIKit
import PinLayout

class ArticleCell: UICollectionViewCell {
    
    class var reuseIdentifier: String { "article-cell-reuse-identifier" }
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.pin.vCenter().right().height(100%).aspectRatio(1)
        titleLabel.pin.before(of: imageView, aligned: .center).left().sizeToFit(.width).marginRight(10)
    }
}

extension ArticleCell {
    func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.numberOfLines = 3
    }
}
