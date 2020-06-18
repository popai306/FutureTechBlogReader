//
//  SectionView.swift
//  TechnicalBookStore
//
//  Created by Tomohiro Fukuya on 2020/06/13.
//  Copyright © 2020 Tomohiro Fukuya. All rights reserved.
//

import UIKit
import PinLayout

class SectionView: UICollectionReusableView {
    
    static let reuseIdentifier = "section-supplementary-reuse-identifier"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.pin.all()
    }
}
