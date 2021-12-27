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
        ///
        /// - ARC: Automatic Reference Counting
        ///
        /// - if i created an object from a class then the reference counting of that object in memory
        ///   is 1, if i made that object nil, then the reference counting now is 0 and that object
        ///   gets deallocated from the memory
        ///
        /// - if i have a developer object that has a machine object and the machine object has a developer
        ///   object as well then tha's a strong reference between the developer and the machine classes,
        ///   the reference counting for each one of them is 2, one for the object itself and one for
        ///   it inside the other class
        ///
        /// - the solution for that strong reference is to make one of the objects inside the other class
        ///   weak var, which means weak reference
        ///
        /// - in this api call there is a strong reference between the network manager and the view controller
        ///   so we need to use weak self to avoid that string reference
        ///
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
            guard let self = self else { return }
            
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
            collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view)
        )

        collectionView.backgroundColor = .systemBackground
        
        collectionView.showsVerticalScrollIndicator = false

        view.addSubview(collectionView)

        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
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
