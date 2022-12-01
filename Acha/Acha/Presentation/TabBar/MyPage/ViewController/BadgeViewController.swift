//
//  BadgeViewController.swift
//  Acha
//
//  Created by 조승기 on 2022/11/30.
//

import UIKit
import Then
import SnapKit
import RxSwift

class BadgeViewController: UIViewController {
    // MARK: - UI properties
    private var collectionView: UICollectionView!
    // MARK: - Properties
    enum BadgeSection {
        case brandNew
        case acquired
        case unacquired
        
        var title: String {
            switch self {
                case .brandNew:
                    return "최근 달성 기록"
                case .acquired:
                    return "획득한 뱃지"
                case .unacquired:
                    return "미획득한 뱃지"
            }
        }
    }
    let viewModel: BadgeViewModel
    typealias DataSource = UICollectionViewDiffableDataSource<BadgeSection, Badge>
    private var dataSource: DataSource?
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    init(viewModel: BadgeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    private func setupSubviews() {
        navigationItem.title = "뱃지"
        cofigureCollectionView()
    }
    
    private func cofigureCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: configureCollectionViewLayout())
        
        collectionView.register(BadgeCell.self,
                                forCellWithReuseIdentifier: BadgeCell.identifer)
        collectionView.register(MyPageHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MyPageHeaderView.identifer)
        collectionView.backgroundColor = .lightGray
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        configureDataSource()
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView,
                                cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BadgeCell.identifer,
                for: indexPath) as? BadgeCell else {
                return BadgeCell()
            }
            cell.bind(image: item.imageURL,
                      badgeName: item.name,
                      disposeBag: self.disposeBag)
            return cell
        })
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, _ ) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(145))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            item.contentInsets = itemInsets
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(145))
            let groupInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = groupInsets
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            let headerInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            header.contentInsets = headerInsets
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            return section
        }
    }
    
    private func makeBadgeSnapShot(badges: [Badge]) {
        guard let dataSource else { return }
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.brandNew, .acquired, .unacquired])
        let brandNewBadges = badges.filter { $0.isOwn}
    }
}
