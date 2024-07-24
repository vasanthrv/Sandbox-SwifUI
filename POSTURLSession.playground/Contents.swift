import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

struct Endpoint
{
    static let registerUser = "https://api-dev-scus-demo.azurewebsites.net/api/User/RegisterUser"
    static let getUser = "https://api-dev-scus-demo.azurewebsites.net/api/User/GetUser"
}
struct MenuDataItem: Codable, Hashable {
    let id: Int
    let menuName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case menuName = "menu_name"
    }
}

struct ErrorMessage: Codable, Error {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

struct User
{
    func registerUser()
        {
            //code to register user
            var urlRequest = URLRequest(url: URL(string: Endpoint.registerUser)!)
            urlRequest.httpMethod = "post"
            let dataDictionary = ["name":"codecat15", "email":"codecat15@gmail.com","password":"1234"]

            do {
                let requestBody = try JSONSerialization.data(withJSONObject: dataDictionary, options: .prettyPrinted)

                urlRequest.httpBody = requestBody
                urlRequest.addValue("application/json", forHTTPHeaderField: "content-type") //this line is very important as explained in the video
            } catch let error {
                debugPrint(error.localizedDescription)
            }

            URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in

                if(data != nil && data?.count != 0)
                {
                    //use decodable here to parse the json response, if you are new to decodable then watch the video
                    //decodable video: https://youtu.be/RiuvxmoU37E
                    let response = String(data: data!, encoding: .utf8)
                    debugPrint(response!)
                }
            }.resume()
        }
    func getUserFromServer()
    {
        var urlRequest = URLRequest(url: URL(string: Endpoint.getUser)!)
        urlRequest.httpMethod = "get"
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if(data != nil && data?.count != 0)
            {
                //use decodable here to parse the json response, if you are new to decodable then watch the video
                //decodable video: https://youtu.be/RiuvxmoU37E
                let response = String(data: data!, encoding: .utf8)
                debugPrint(response!)
            }
        }.resume()
    }
    
    func getMenu(completion: @escaping (Result<[MenuDataItem], ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "https://evapi.crimefire.in/api/menus")!)
        urlRequest.httpMethod = "GET"
//        if !isGuest() {
//            guard let authToken = LocalRepository.shared.getAuthToken() else {return}
//            urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//        }
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data else {
                completion(.failure(ErrorMessage(message: "No data received")))
                return
            }
            
            do {
                if let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(errorResponse))
                } else {
                    let results = try JSONDecoder().decode([MenuDataItem].self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
}

let objUser = User()
objUser.getUserFromServer()
objUser.getMenu { result in
    print(result)
}
