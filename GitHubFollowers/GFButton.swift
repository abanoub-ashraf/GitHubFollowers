import UIKit

class GFButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    ///
    /// this is required when you initialize this GFButton via storyboard
    ///
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    ///
    /// to initialize this button with whatever style we want every time we use it
    ///
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        
        configure()
    }
    
    private func configure() {
        layer.cornerRadius      = 10
        titleLabel?.textColor   = .white
        ///
        /// preferredFont to mke the font size adjust to the available space
        ///
        titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
        ///
        /// to be able to use the auto layout in code
        ///
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
