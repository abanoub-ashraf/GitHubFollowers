import UIKit

///
/// - this is the main section of the collection view
///
/// - enums are hashable by default
///
enum Section {
    case main
}

class FollowersListController: UIViewController {

    // MARK: - Properties

    var username: String!
    
    var followers: [FollowerModel] = []
    
    ///
    /// - DiffableDataSource gives a snapshot of the data, then if the data changes
    ///   it gives a new snapshot of it, and its animation happens on its own
    ///
    /// - the two generics that it takes must comforms to hashable protocol
    ///
    /// - the two generics should be the section of the collection view and the item
    ///
    var dataSource: UICollectionViewDiffableDataSource<Section, FollowerModel>!
    
    // MARK: - UI

    var collectionView: UICollectionView!
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        getFollowersFromServer()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///
        /// set this to false cause it is set to true on the previous screen
        ///
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helper Functions

    private func getFollowersFromServer() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result {
                case .success(let followers):
                    self.followers = followers
                    self.updateData()
                    
                case .failure(let error):
                    self.presentGFAlertOnMainThread(
                        title: "Bad Stuff Happened",
                        message: error.rawValue,
                        buttonTitle: "Ok"
                    )
            }
        }
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createThreeColumnFlowLayout()
        )

        view.addSubview(collectionView)

        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    ///
    /// - setting up the layout of the collection view and its items
    ///
    /// - each item's width will be the entire view - the padding on both sides - the 2 item spacing
    ///   in the middle of the columns
    ///
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 3

        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }

    // MARK: - DiffableDataSource Methods
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, FollowerModel>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, follower in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FollowerCell.reuseID,
                    for: indexPath
                ) as? FollowerCell

                cell?.set(follower: follower)
                return cell
            }
        )
    }

    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FollowerModel>()

        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
