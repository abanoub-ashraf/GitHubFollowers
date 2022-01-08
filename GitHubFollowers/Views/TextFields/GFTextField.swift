import UIKit

class GFTextField: UITextField {
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Helper Functions

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
        ///
        /// - the keyboard is connected to the textfield in ios
        ///
        /// - this line determine the type of the keyboard i wanna use for each text field
        ///
        keyboardType                = .default
        ///
        /// specify the title of the return key of the keyboard
        ///
        returnKeyType               = .go
        
        placeholder                 = "Enter a username..."
    }
}
