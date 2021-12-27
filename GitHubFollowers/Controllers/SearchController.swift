import UIKit

class SearchController: UIViewController {
 
    // MARK: - UI

    let logoImageView       = UIImageView()
    let usernameTextField   = GFTextField()
    let callToActionButton  = GFButton(
        backgroundColor: .systemGreen,
        title: "Get Followers"
    )
    
    // MARK: - Properties
    
    ///
    /// this variable will return true  or false based on wether the text
    /// inside the username textfield is empty or not
    ///
    var isUsernameEntered: Bool {
        return !usernameTextField.text!.isEmpty
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///
        /// - hide the navigation bar only on this screen
        ///
        /// - since this is set to hidden, we have to set it to false on the next screen
        ///   we wanna go to otherwise it will be hidden there too
        ///
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Helper Functions
    
    @objc func pushFollowersListControllerOnScreen() {
        ///
        /// - if this computed property is true, keep going to the rest of this function body
        ///
        /// - if not print the error then stop excution
        ///
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(
                title: "Empty Username",
                message: "Please enter a username. we need to know who to look for 😀",
                buttonTitle: "Ok"
            )
            
            return
        }
        
        let followersController         = FollowersListController()
        
        followersController.username    = usernameTextField.text
        followersController.title       = usernameTextField.text
        
        navigationController?.pushViewController(followersController, animated: true)
    }
    
    ///
    /// dismiss the keyboard after it was opened because of the text field the user is typing in
    ///
    func createDismissKeyboardTapGesture() {
        ///
        /// the endEditing() function causes the view (or one of its embedded text fields)
        /// to resign the first responder status, meaning hide the keyboard
        ///
        let tap = UITapGestureRecognizer(
            target: self.view,
            action: #selector(UIView.endEditing(_:))
        )
        
        view.addGestureRecognizer(tap)
    }

    func configureLogoImageView() {
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = AppAssets.logo
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        view.addSubview(usernameTextField)
        
        ///
        /// the functions of the UITextFieldDelegate runs based on the actions
        /// that happens to this text field
        ///
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        
        callToActionButton.addTarget(
            self,
            action: #selector(pushFollowersListControllerOnScreen),
            for: .touchUpInside
        )
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

// MARK: - UITextFieldDelegate Methods

///
/// listen to the usernameTextField and fire the delegate functions based on that
///
extension SearchController: UITextFieldDelegate {
    
    ///
    /// specify what should happen when the return key of the keyboard is clicked
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListControllerOnScreen()
        return true
    }
}
