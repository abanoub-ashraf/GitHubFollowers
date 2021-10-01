import UIKit

class GFTitleLabel: UILabel {

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    
        configure()
    }
    
    // MARK: - Helper Functions

    private func configure() {
        textColor                   = .label
        ///
        /// to shrink the font size if the text is too much
        ///
        adjustsFontSizeToFitWidth   = true
        ///
        /// how much minimum the shrinking above should have
        ///
        minimumScaleFactor          = 0.9
        ///
        /// put ... after the text if it was too long
        ///
        lineBreakMode               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
