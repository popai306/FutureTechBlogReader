//
//  ViewController.swift
//  TechnicalBookStore
//
//  Created by Tomohiro Fukuya on 2020/06/13.
//  Copyright © 2020 Tomohiro Fukuya. All rights reserved.
//

import UIKit
import SafariServices

class ReaderViewController: UIViewController {
    
    var currentSnapshot: NSDiffableDataSourceSnapshot<ArticleCollection, Article>! = nil
    var articleController = ArticleController()
    
    private var v: ReaderView
    override func loadView() { view = v }
    
    init() {
        v = ReaderView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Future Tech Blog"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        navigationItem.largeTitleDisplayMode = .always
        
        configureDataSource()
        apply()
        
        v.collectionView.delegate = self
    }
}

extension ReaderViewController {
    func configureDataSource() {
        v.dataSource = UICollectionViewDiffableDataSource<ArticleCollection, Article> (collectionView: v.collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, article: Article) -> UICollectionViewCell? in
            
            guard let sectionKind = ReaderView.SectionLayoutKind(rawValue: indexPath.section) else { fatalError("unknown section kind") }
            
            switch sectionKind {
            case .recommend:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeArticleCell.reuseIdentifier, for: indexPath) as! LargeArticleCell
                cell.titleLabel.text = article.title
                cell.imageView.image = article.icon
                cell.tag = article.hashValue
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as! ArticleCell
                cell.titleLabel.text = article.title
                cell.imageView.image = article.icon
                cell.tag = article.hashValue
                return cell
            }
        }
        
        v.dataSource.supplementaryViewProvider = { [weak self]
        (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryView( ofKind: kind,
            withReuseIdentifier: SectionView.reuseIdentifier,
            for: indexPath) as! SectionView
            
            sectionHeader.label.text = snapshot.sectionIdentifiers[indexPath.section].categoryName
            return sectionHeader
        }
    }

    func apply() {
        currentSnapshot = NSDiffableDataSourceSnapshot<ArticleCollection, Article>()
        
        for collection in articleController.articleCollections {
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.articles)
        }
        
        v.dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension ReaderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hashValue = collectionView.cellForItem(at: indexPath)?.tag,
            let url = articleController.getArticleUrl(with: hashValue) else { return }
        
        let webVC = SFSafariViewController(url: URL(string: url)!)
        webVC.modalPresentationStyle = .formSheet
        present(webVC, animated: true, completion: nil)
    }
}
