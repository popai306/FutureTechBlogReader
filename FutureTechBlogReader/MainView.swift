//
//  MainView.swift
//  TechnicalBookStore
//
//  Created by Tomohiro Fukuya on 2020/06/13.
//  Copyright © 2020 Tomohiro Fukuya. All rights reserved.
//

import UIKit
import PinLayout

class MainView: UIView {
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<ArticleCollection, Article>! = nil
    
    enum SectionLayoutKind: Int, CaseIterable {
        case recommend, springEntry, goTips, serverless
        func scrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .recommend:
                return .continuous
            default:
                return .groupPaging
            }
        }
    }
      
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.pin.all()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

extension MainView {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionLayoutKind(rawValue: sectionIndex) else { fatalError("unknown section kind") }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupWidth = layoutEnvironment.container.effectiveContentSize.width - 15 * 2 - 5
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth),
                                                   heightDimension: .absolute(150))
            let group: NSCollectionLayoutGroup
            if sectionKind == .recommend {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            } else {
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
            }
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = sectionKind.scrollingBehavior()
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
            
            let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: "header", alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        addSubview(collectionView)
        
        collectionView.register(LargeArticleCell.self, forCellWithReuseIdentifier: LargeArticleCell.reuseIdentifier)
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: ArticleCell.reuseIdentifier)
        collectionView.register(SectionView.self, forSupplementaryViewOfKind: "header",
                                withReuseIdentifier: SectionView.reuseIdentifier)
    }
}
