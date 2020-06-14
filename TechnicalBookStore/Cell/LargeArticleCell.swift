//
//  ArticleCell.swift
//  TechnicalBookStore
//
//  Created by Tomohiro Fukuya on 2020/06/13.
//  Copyright © 2020 Tomohiro Fukuya. All rights reserved.
//

import PinLayout

class LargeArticleCell: ArticleCell {
    
    override class var reuseIdentifier: String { "large-article-cell-reuse-identifier" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        imageView.pin.top().horizontally().height(100)
        titleLabel.pin.below(of: imageView, aligned: .center).width(of: imageView).sizeToFit(.width)
    }
}
