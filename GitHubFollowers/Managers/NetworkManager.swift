import UIKit

class NetworkManager {
    
    // MARK: - Properties

    static let shared = NetworkManager()
    
    ///
    /// we wil use this to download the image of each follower then store it in the cache if
    /// we will scroll back up again in the collection view so the images that was downloaded at first
    /// doesn't get downloaded again over and over as we scroll up and down
    ///
    let cache = NSCache<NSString, UIImage>()
    
    // MARK: - Initializer

    private init() {}
    
    // MARK: - Network Calls

    func getFollowers(
        for username: String,
        page: Int,
        completed: @escaping (Result<[FollowerModel], GFError>) -> Void
    ) {
        let endpoint = AppConstants.API.baseUrl + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidResponse))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([FollowerModel].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }

    func getUserInfo(
        for username: String,
        completed: @escaping (Result<UserModel, GFError>) -> Void
    ) {
        let endpoint = AppConstants.API.baseUrl + "/users/\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidResponse))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let userInfo = try decoder.decode(UserModel.self, from: data)
                completed(.success(userInfo))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
