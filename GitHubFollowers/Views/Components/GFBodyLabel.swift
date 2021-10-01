import UIKit

class GFBodyLabel: UILabel {

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        
        self.textAlignment = textAlignment
        
        configure()
    }
    
    // MARK: - Helper Functions
    
    private func configure() {
        textColor                   = .secondaryLabel
        font                        = UIFont.preferredFont(forTextStyle: .body)
        ///
        /// to shrink the font size if the text is too much
        ///
        adjustsFontSizeToFitWidth   = true
        ///
        /// how much minimum the shrinking above should have
        ///
        minimumScaleFactor          = 0.75
        ///
        /// Wrapping occurs at word boundaries, unless the word doesn’t fit on a single line
        ///
        lineBreakMode               = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}
