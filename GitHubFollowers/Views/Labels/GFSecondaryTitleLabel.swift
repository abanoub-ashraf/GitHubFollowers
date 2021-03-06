import UIKit

class GFSecondaryTitleLabel: UILabel {

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        
        configure()
    }
    
    // MARK: - Helper Functions
    
    private func configure() {
        textColor                   = .secondaryLabel
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.90
        lineBreakMode               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
