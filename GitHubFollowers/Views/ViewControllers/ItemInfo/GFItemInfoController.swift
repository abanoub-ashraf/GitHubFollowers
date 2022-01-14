import UIKit

///
/// this controller will be the super class that we will create 2 subclasses from
/// to configure the items of this super class dieffrently in the two ones we will create
///
class GFItemInfoController: UIViewController {

    // MARK: - UI

    let stackView       = UIStackView()
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let actionButton    = GFButton()
    
    // MARK: - Properties
    
    var user: UserModel!
    
    ///
    /// this delegate will call the functions of the delegate protocol
    /// through the 2 classes that inherit from this super class
    /// by overriding the obj actionButtonTapped() function of this class
    ///
    weak var delegate: UserInfoControllerDelegate!
    
    // MARK: - Initializer
    
    init(user: UserModel) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helper Functions
    
    private func configureBackground() {
        view.layer.cornerRadius = 18
        view.backgroundColor    = .secondarySystemBackground
    }
    
    private func configureStackView() {
        stackView.axis          = .horizontal
        stackView.distribution  = .fillEqually
        stackView.spacing       = 60
        
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        [stackView, actionButton].forEach { subView in
            view.addSubview(subView)
        }
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureActionButton() {
        actionButton.addTarget(
            self,
            action: #selector(actionButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func configureUI() {
        configureBackground()
        
        configureStackView()
        
        configureLayout()
        
        configureActionButton()
    }
    
    // MARK: - Selectors

    ///
    /// this function will be overried inside the class that inherite from this one
    /// [the repo item controller, and the follower item controller one]
    ///
    @objc func actionButtonTapped() {
        ///
        /// nothing is gonna be here cause this whole class is a generic one
        ///
    }
}
