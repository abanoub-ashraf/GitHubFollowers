import Foundation

extension String {
    
    // MARK: - Properties

    var isValidEmail: Bool {
        let emailFormat         = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate      = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    ///
    /// Regex restricts to 8 character minimum, 1 capital letter, 1 lowercase letter, 1 number
    ///
    var isValidPassword: Bool {
        let passwordFormat      = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let passwordPredicate   = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneNumberFormat   = "^\\d{3}-\\d{3}-\\d{4}$"
        let numberPredicate     = NSPredicate(format: "SELF MATCHES %@", phoneNumberFormat)
        return numberPredicate.evaluate(with: self)
    }

    // MARK: - Functions

    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    ///
    /// convert a given string format of a date into an actual date
    ///
    func convertToDate() -> Date? {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone      = .current
        
        return dateFormatter.date(from: self)
    }
    
    ///
    /// get a date from a given string first using the function above
    /// then convert that data into a string using the date extension function
    ///
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
