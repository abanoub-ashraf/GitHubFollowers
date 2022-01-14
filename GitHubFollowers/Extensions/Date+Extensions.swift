import Foundation

extension Date {
    
    ///
    /// we have a function in the string extensions to convert a given string date format
    /// into an actual date then this function will convert that date into a string date format
    /// in a prettier format of it
    ///
    func convertToMonthYearFormat() -> String {
        let dateFormatter           = DateFormatter()
        ///
        /// this is the date format i want
        ///
        dateFormatter.dateFormat    = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
