import UIKit

///
/// the properties and the ui elements of this class will be inherited from
/// the super class we're inherting from
///
class GFFollowerItemController: GFItemInfoController {

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    // MARK: - Helper Functions
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    ///
    /// when this button is clicked the didTapGetFollowers() function of the delegate protocol
    /// inside the UserInfoController class will fire off
    ///
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
