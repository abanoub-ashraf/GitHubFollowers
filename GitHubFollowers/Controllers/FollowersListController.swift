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

    var followers: [FollowerModel] = []
    var username: String!
    
    ///
    /// this variable is for getting specific amount of followers per page
    /// every time we scroll down
    ///
    var page = 1
    
    ///
    /// this variable is for pagination, it strts as true then we set it to false
    /// when the amout of data we get from the api is less than 100 which means
    /// it is the last data the api has and there is no more
    ///
    var hasMoreFollowers = true
    
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
        
        getFollowersFromServer(username: username, page: page)
        configureUI()
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

    private func getFollowersFromServer(username: String, page: Int) {
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
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let followers):
                    ///
                    /// - if the followers we got from the api is less than 100 then this is the last data
                    ///   we can get from the api and there is no more followers to get
                    ///
                    /// - so flip this variable hasMoreFollowers to false
                    ///
                    if followers.count < 100 {
                        self.hasMoreFollowers = false
                    }
                    
                    self.followers.append(contentsOf: followers)
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
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false

        view.addSubview(collectionView)

        collectionView.register(
            FollowerCell.self,
            forCellWithReuseIdentifier: FollowerCell.reuseID
        )
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
            self.dataSource.apply(
                snapshot,
                animatingDifferences: true
            )
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FollowersListController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        ///
        /// this is how far we scrolled down in the screen
        ///
        let offsetY         = scrollView.contentOffset.y
        ///
        /// this is the height of the entire scrollview even the hidden part as well
        ///
        let contentHeight   = scrollView.contentSize.height
        ///
        /// this is the height of the device's screen
        ///
        let height          = scrollView.frame.size.height
        
        ///
        /// get the followers for the next page if the amount we did scroll is bigger than
        /// (the whole scrollview content - the current height of the screen)
        ///
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            
            page += 1
            getFollowersFromServer(username: username, page: page)
        }
    }
}
