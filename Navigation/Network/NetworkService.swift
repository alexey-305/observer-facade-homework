import Foundation

struct NetworkService {

    static func request(for configuration: AppConfiguration) {

        let urlString: String

        switch configuration {

        case .people(let url):
            urlString = url

        case .starships(let url):
            urlString = url

        case .planets(let url):
            urlString = url
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {

                print("ERROR:")
                print(error.localizedDescription)
                print(error)

                // При выключенном интернете:
                // Code=-1009
                // The Internet connection appears to be offline.

                return
            }

            if let response = response as? HTTPURLResponse {

                print("STATUS CODE:")
                print(response.statusCode)

                print("HEADERS:")
                print(response.allHeaderFields)
            }

            if let data = data,
               let dataString = String(data: data, encoding: .utf8) {

                print("DATA:")
                print(dataString)
            }
        }

        task.resume()
    }
}
