//
//  SearchViewController.swift
//  BookSearcher
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import UIKit
import Combine
class SearchViewController: UIViewController {

    private let search = PassthroughSubject<String, Never>()
    private var cancellables: [AnyCancellable] = []
    
    let model: SearchViewModel
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, BookViewModel>! = nil
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    init(_ model: SearchViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
    }
        private func bind(){
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
            let output = model.output(for: search.eraseToAnyPublisher())
            output.sink(receiveCompletion: { completion in
                
            }) { [weak self] (BookViewModels) in
                self?.update(with: BookViewModels)
            }.store(in: &cancellables)
        }
        private func configureUI() {
            title = NSLocalizedString("Books", comment: "Google Books")
            navigationItem.searchController = self.searchController
            searchController.isActive = true
            configureHierarchy()
            dataSource = makeDataSource()
        }
}

fileprivate extension SearchViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

fileprivate extension SearchViewController {
    enum Section: CaseIterable {
        case books
    }

    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(BookViewCell.self, forCellWithReuseIdentifier: "BookViewCell")
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, BookViewModel> {
        return UICollectionViewDiffableDataSource<Section, BookViewModel>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: BookViewModel) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "BookViewCell",
                for: indexPath) as? BookViewCell else { fatalError("Could not create new cell") }
         cell.bind(to: identifier)
            return cell
        }
    }

    func update(with movies: [BookViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, BookViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .books)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
    }
}
