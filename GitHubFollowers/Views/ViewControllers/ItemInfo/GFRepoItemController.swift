import UIKit

///
/// the properties and the ui elements of this class will be inherited from
/// the super class we're inherting from
///
class GFRepoItemController: GFItemInfoController {

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    // MARK: - Helper Functions

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
}
