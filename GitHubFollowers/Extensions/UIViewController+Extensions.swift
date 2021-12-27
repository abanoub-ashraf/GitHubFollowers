import UIKit

extension UIViewController {

    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertController = GFAlertController(
                title: title,
                message: message,
                buttonTitle: buttonTitle
            )
            
            alertController.modalPresentationStyle  = .overFullScreen
            alertController.modalTransitionStyle    = .crossDissolve
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
