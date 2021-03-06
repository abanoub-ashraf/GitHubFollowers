import UIKit

///
/// - this delegate will establish connection between the user info controller
///   and this followers list controller
///
/// - when the didRequestFollowers() delegate function is tapped from inside
///   the user info controller we want this  controller to be reset so that
///   it can load a new array of followers of the nuew username we got from
///   the user info controller
///
protocol FollowersListControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

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
    var filteredFollowers: [FollowerModel] = []
    var username: String!
    
    ///
    /// we will use this variable to determine when we click on a follower cell and
    /// we wanna go to the details page of that follower we wanna know which array
    /// we will load the data of that follower from
    ///
    var isSearching = false
    
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
        
        configureUI()
        configureDataSource()
        getFollowersFromServer(username: username, page: page)
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
        showLoadingView()
        
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
            
            self.dismissLoadingView()
            
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
                    
                    ///
                    /// this is to ensure the new paginated data doesn't override the old data that
                    /// we already got from the previous pages above
                    ///
                    self.followers.append(contentsOf: followers)
                    
                    ///
                    /// - if we got no followers from the api then display the empty state view
                    ///
                    /// - do this check after fetching data from the api is done to ensure there's no data
                    ///
                    if self.followers.isEmpty {
                        DispatchQueue.main.async {
                            self.showEmptyStateView(
                                with: AppConstants.noFollowersMessage,
                                in: self.view
                            )
                        }
                        
                        ///
                        /// if the followers is empty then we don't wanna stop right here and
                        /// don't call the updateData() function
                        ///
                        return
                    }
                    
                    self.updateData(on: self.followers)
                    
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
        configureSearchController()
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

    func updateData(on followers: [FollowerModel]) {
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
    
    ///
    /// - configure the search bar on top
    ///
    /// - searchController.searchResultsUpdater = self is the
    ///   UISearchResultsUpdating delegate confirmation
    ///
    /// - searchController.searchBar.delegate = self is the
    ///   UISearchBarDelegate delegate confirmation
    ///
    func configureSearchController() {
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate                     = self
        searchController.searchBar.placeholder                  = "Search for a username..."
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
        navigationItem.hidesSearchBarWhenScrolling              = false
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

    ///
    /// go to the details page of the follower item we tapped on
    ///
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray             = isSearching ? filteredFollowers : followers
        let follower                = activeArray[indexPath.item]
        
        let userInfoController      = UserInfoController()
        userInfoController.username = follower.login
        ///
        /// set this class to be the listener to the deleagte protocol above
        ///
        userInfoController.delegate = self
        
        let navController           = UINavigationController(rootViewController: userInfoController)
        
        present(navController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension FollowersListController: UISearchResultsUpdating {
    
    ///
    /// this gets called every time i type a letter in the search bar
    ///
    func updateSearchResults(for searchController: UISearchController) {
        ///
        /// if the search bar has a text and that text is not empty, continue
        /// else stop right here
        ///
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        
        ///
        /// to indicate that we are searching
        ///
        isSearching = true
        
        ///
        /// get all the followers that their login string contains the filter string
        /// and make an array out of them
        ///
        filteredFollowers = followers.filter {
            $0.login
                .lowercased()
                .contains(filter.lowercased())
        }
        
        ///
        /// now update the collection view
        ///
        updateData(on: filteredFollowers)
    }
}

// MARK: - UISearchBarDelegate

extension FollowersListController: UISearchBarDelegate {
    ///
    /// when the cancel button is clicked we wanna load
    /// the original list of followers
    ///
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        ///
        /// to indicate that we stopped searching
        ///
        isSearching = false
        updateData(on: followers)
    }
}

// MARK: - FollowersListControllerDelegate

extension FollowersListController: FollowersListControllerDelegate {
    
    ///
    /// make the network call with the new user name after resetting everything on the screen
    /// so that we can load new array of followers for the new user we got
    ///
    func didRequestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        
        ///
        /// make the collection view scrolls back up
        ///
        collectionView.setContentOffset(.zero, animated: true)
        
        getFollowersFromServer(username: username, page: page)
    }
}
