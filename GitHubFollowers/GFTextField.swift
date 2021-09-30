import UIKit

class GFTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius          = 10
        layer.borderWidth           = 2
        layer.borderColor           = UIColor.systemGray4.cgColor
        
        textColor                   = .label
        tintColor                   = .label
        textAlignment               = .center
        font                        = UIFont.preferredFont(forTextStyle: .title2)
        ///
        /// if the text is too long, the font size of the text will shrink to adjust
        ///
        adjustsFontSizeToFitWidth   = true
        ///
        /// the line above will shrink the font size but this line will set the minimun shrinking
        ///
        minimumFontSize             = 12
        
        backgroundColor             = .tertiarySystemBackground
        ///
        /// to disable auto correction inside this textfield
        ///
        autocorrectionType          = .no
        
        placeholder                 = "Enter a username..."
    }
    
}
