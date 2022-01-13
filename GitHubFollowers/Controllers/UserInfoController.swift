import UIKit

class UserInfoController: UIViewController {
    
    // MARK: - UI

    let headerView = UIView()
    
    // MARK: - Properties

    var username: String!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUserInfo()
    }
    
    // MARK: - Helper Functions

    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissController)
        )
        
        navigationItem.rightBarButtonItem = doneButton
        
        configureLayout()
    }
    
    private func configureLayout() {
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    ///
    /// this function is for adding a view controller to a view
    /// as a child view controller
    ///
    private func add(childViewController: UIViewController, to containerView: UIView) {
        ///
        /// - add the specified view controller as a child of the current view controller
        ///
        /// - add the view of the child view controller we added to the container view
        ///   of the current view controller
        ///
        /// - set the frame of the view of the view controller we added to be
        ///   the frame of its container
        ///
        /// - didMove() is for adding the child view controller to the current view controller
        ///
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    private func fetchUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let userInfo):
                    ///
                    /// this ui stuff should happen in the main thread
                    ///
                    DispatchQueue.main.async {
                        ///
                        /// we will use the user info object we got from the server to populate
                        /// the user info header controller then add that header controller to
                        /// the header view we have in this current view controller
                        ///
                        self.add(
                            childViewController: GFUserInfoHeaderController(user: userInfo),
                            to: self.headerView
                        )
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Selectors

    @objc private func dismissController() {
        dismiss(animated: true)
    }
}
