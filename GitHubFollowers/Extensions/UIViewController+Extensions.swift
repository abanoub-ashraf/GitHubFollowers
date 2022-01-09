import UIKit

fileprivate var containerView: UIView!

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
    
    ///
    /// show a loading indicator 
    ///
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    ///
    /// dismiss the loading indicator
    ///
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    ///
    /// show the empty state view anywhere we have no data with a custom message
    ///
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
