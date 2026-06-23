import Foundation

struct ChuckNorrisQuote: Decodable {
    let value: String
    let category: String?
}

class APIService {
    private let baseURL = "https://api.chucknorris.io/jokes/random"
    
    func fetchRandomQuote(completion: @escaping (Result<ChuckNorrisQuote, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            
            do {
                let quote = try JSONDecoder().decode(ChuckNorrisQuote.self, from: data)
                completion(.success(quote))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
