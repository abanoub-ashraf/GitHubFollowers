import Foundation

class NetworkManager {
    
    // MARK: - Properties

    static let shared = NetworkManager()
    
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
            if let _ = error {
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
    
}
