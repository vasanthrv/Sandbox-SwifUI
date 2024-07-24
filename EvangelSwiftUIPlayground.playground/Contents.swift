import UIKit

var greeting = "Hello, playground"

struct UrlConstants {
    static let baseURL = "https://evapi.crimefire.in/api/"
    static let login = baseURL + "login"
    static let register = baseURL + "register"
    static let menus = baseURL + "menus"
    static let sliders = baseURL + "sliders"
    static let contentTypes = baseURL + "content_type"
    static let moviesSection = baseURL + "movies_section"
    static let home = baseURL + "home"
    static let menuContent = baseURL + "menu_content"
    static let getProfile = baseURL + "get_profile"
}

struct LoginDetails: Codable {
    let status: String
    let message: String
    let data: LoginData
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

struct LoginData: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}

struct ErrorMessage: Codable, Error {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

struct ContentTypeItem: Codable {
    let id: Int
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
    }
}

struct ContentResponse: Codable {
    let sliders: [Slider]
    let continueWatching: [ContinueWatching]
    let recentlyAdded: [RecentlyAdded]
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case sliders
        case continueWatching = "continue_watching"
        case recentlyAdded = "recently_added"
        case movies
    }
}

struct Slider: Codable {
    let sliderType: Int
    let sliderAppImage: String
    let sliderTVImage: String
    let contentID: Int
    let contentTypeID: Int
    let genreName: String

    enum CodingKeys: String, CodingKey {
        case sliderType = "slider_type"
        case sliderAppImage = "slider_app_image"
        case sliderTVImage = "slider_tv_image"
        case contentID = "content_id"
        case contentTypeID = "content_type_id"
        case genreName = "genre_name"
    }
}

struct ContinueWatching: Codable {
    // Add properties for the "continue_watching" items if needed
}

struct RecentlyAdded: Codable {
    let id: Int
    let contentTitle: String
    let contentTypeID: Int
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id
        case contentTitle = "content_title"
        case contentTypeID = "content_type_id"
        case thumbnail
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let contentTypeID: Int
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case contentTypeID = "content_type_id"
        case thumbnail
    }
}
struct ContentItem: Codable {
    let id: Int?
    let content_title: String?
    let content_type_id: Int
    let episode_id: Int?
    let total_duration: String?
    let watch_time: String?
    let thumbnail: String
}

struct HomeResponse: Codable {
    struct LanguageSelection: Codable {
        let id: Int
        let language_name: String
        let language_image: String
    }
    
    struct Genre: Codable {
        let id: Int
        let name: String
        let content: [ContentItem]?
    }
    
    let continue_watching: [ContentItem]?
    let recently_added: [ContentItem]?
    let language_selection: [LanguageSelection]?
    let genre_list: [Genre]
}

struct ProfileDetail: Codable {
    let id: Int
    let name: String
    let birth_date: String
    let profile_image: String
    let email: String
    let phone_number: Int
    let email_verified_at: String?
    let created_at: String
    let updated_at: String
    let profilepicture: String
}

struct SliderDataItem: Codable {
    let sliderType: Int
    let sliderAppImage: String
    let sliderTVImage: String
    let contentId: Int
    let contentTypeId: Int
    let genreName: String
    
    enum CodingKeys: String, CodingKey {
        case sliderType = "slider_type"
        case sliderAppImage = "slider_app_image"
        case sliderTVImage = "slider_tv_image"
        case contentId = "content_id"
        case contentTypeId = "content_type_id"
        case genreName = "genre_name"
    }
}

struct MenuCategoryItem: Codable {
    let id: Int
    let title: String
    let content: [MenuCategory]

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
    }
}

struct MenuCategory: Codable {
    let contentID: Int
    let contentTypeID: Int
    let thumbnail: String

    private enum CodingKeys: String, CodingKey {
        case contentID = "content_id"
        case contentTypeID = "content_type_id"
        case thumbnail
    }
}

class LoginRepository {

    func checkEmailLogin(email: String, password: String, completion: @escaping (Result<LoginDetails, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.login)")!)
        urlRequest.httpMethod = "POST"
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        let body = parameters.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        urlRequest.httpBody = body.data(using: .utf8)
        
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
                    let results = try JSONDecoder().decode(LoginDetails.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    func registerUser(name: String, email: String, password: String, confirmPassword: String, completion: @escaping (Result<LoginDetails, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.register)")!)
        urlRequest.httpMethod = "POST"
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "password": password,
            "confirm_password": confirmPassword
        ]
        let body = parameters.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        urlRequest.httpBody = body.data(using: .utf8)
        
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
                    let results = try JSONDecoder().decode(LoginDetails.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
}


class HomeRepository {
    func getHomeData(completion: @escaping (Result<HomeResponse, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.home)")!)
        urlRequest.httpMethod = "GET"
//        guard let authToken = LocalRepository.shared.getAuthToken() else {return}
        urlRequest.setValue("Bearer 7|6jmAJbHkAaltp3kQdxfquaAhlD7sJpCrgBilPlGY91b13f14", forHTTPHeaderField: "Authorization")
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data else {
                completion(.failure(ErrorMessage(message: "No data received")))
                return
            }
//            print(String(data: data, encoding: .utf8))
            do {
                if let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(errorResponse))
                } else {
                    let results = try JSONDecoder().decode(HomeResponse.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    func getMenu(completion: @escaping (Result<[MenuDataItem], ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.menus)")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer 7|6jmAJbHkAaltp3kQdxfquaAhlD7sJpCrgBilPlGY91b13f14", forHTTPHeaderField: "Authorization")
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data else {
                completion(.failure(ErrorMessage(message: "No data received")))
                return
            }
            print(String(data: data, encoding: .utf8))
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
    
    func getSlider(completion: @escaping (Result<[SliderDataItem], ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.sliders)")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer 7|6jmAJbHkAaltp3kQdxfquaAhlD7sJpCrgBilPlGY91b13f14", forHTTPHeaderField: "Authorization")
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data else {
                completion(.failure(ErrorMessage(message: "No data received")))
                return
            }
            print(String(data: data, encoding: .utf8))
            do {
                if let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(errorResponse))
                } else {
                    let results = try JSONDecoder().decode([SliderDataItem].self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }

//    func getContentaTypes(completion: @escaping (Result<[ContentTypeItem], ErrorMessage>) -> Void) {
//        let session = URLSession.shared
//        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.contentTypes)")!)
//        urlRequest.httpMethod = "GET"
////        guard let authToken = LocalRepository.shared.getAuthToken() else {return}
//        urlRequest.setValue("Bearer 24|J61cNge5J79TSeV4uZstWGnpviTZMMc9FTnpBRDQddf61686", forHTTPHeaderField: "Authorization")
//        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
//            guard let data = data else {
//                completion(.failure(ErrorMessage(message: "No data received")))
//                return
//            }
//            
//            do {
//                if let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
//                    let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
//                    completion(.failure(errorResponse))
//                } else {
//                    let results = try JSONDecoder().decode([ContentTypeItem].self, from: data)
//                    completion(.success(results))
//                }
//            } catch {
//                completion(.failure(ErrorMessage(message: "Failed to decode response")))
//            }
//        }.resume()
//    }
    
    func getMovies(completion: @escaping (Result<ContentResponse, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.moviesSection)")!)
        urlRequest.httpMethod = "GET"
//        guard let authToken = LocalRepository.shared.getAuthToken() else {return}
        urlRequest.setValue("Bearer 7|6jmAJbHkAaltp3kQdxfquaAhlD7sJpCrgBilPlGY91b13f14", forHTTPHeaderField: "Authorization")
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data else {
                completion(.failure(ErrorMessage(message: "No data received")))
                return
            }
            print(String(data: data, encoding: .utf8))
            
            do {
                if let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(errorResponse))
                } else {
                    let results = try JSONDecoder().decode(ContentResponse.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    
    func getProfileDetails(completion: @escaping (Result<ProfileDetail, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.getProfile)")!)
        urlRequest.httpMethod = "GET"
//        guard let authToken = LocalRepository.shared.getAuthToken() else {return}
        urlRequest.setValue("Bearer 7|6jmAJbHkAaltp3kQdxfquaAhlD7sJpCrgBilPlGY91b13f14", forHTTPHeaderField: "Authorization")
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data else {
                completion(.failure(ErrorMessage(message: "No data received")))
                return
            }
            print(String(data: data, encoding: .utf8))
            
            do {
                if let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(errorResponse))
                } else {
                    let results = try JSONDecoder().decode(ProfileDetail.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }

    func getMenuContent(id: Int, completion: @escaping (Result<[MenuCategoryItem], ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.menuContent)/\(id)")!)
        urlRequest.httpMethod = "GET"
//        guard let authToken = LocalRepository.shared.getAuthToken() else {return}
        urlRequest.setValue("Bearer 7|6jmAJbHkAaltp3kQdxfquaAhlD7sJpCrgBilPlGY91b13f14", forHTTPHeaderField: "Authorization")
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
                    let results = try JSONDecoder().decode([MenuCategoryItem].self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    func checkUserExist(phoneNumber: String, completion: @escaping (Result<Success, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.validateUser)")!)
        urlRequest.httpMethod = "POST"
        let parameters: [String: String] = [
            "phoneNumber": phoneNumber
        ]
        print(parameters)
        let body = parameters.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        urlRequest.httpBody = body.data(using: .utf8)
        
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data else {
                completion(.failure(ErrorMessage(message: "No data received")))
                return
            }
            
            do {
                if let httpResponse = httpUrlResponse as? HTTPURLResponse {
                    if httpResponse.statusCode != 302 {
                        let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
                        completion(.failure(errorResponse))
                    }
                    if httpResponse.statusCode == 200 {
                        let results = try JSONDecoder().decode(Success.self, from: data)
                        completion(.success(results))
                    }
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
}

struct MenuDataItem: Codable {
    let id: Int
    let menuName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case menuName = "menu_name"
    }
}

//LoginRepository().checkEmailLogin(email: "jebastine@charismainfotainment.com", password: "jebaadmin@123") { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}
//
//LoginRepository().registerUser(name: "Vasanth", email: "rvkyou@gmail.com", password: "vasanth@charisma", confirmPassword: "vasanth@charisma") { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}

//HomeRepository().getMenu { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error):
//        print(error)
//    }
//}

//HomeRepository().getSlider { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}


//HomeRepository().getContentaTypes { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}
//HomeRepository().getMovies { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//        
//    }
//}

//HomeRepository().getHomeData {result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}
//HomeRepository().getProfileDetails { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}
HomeRepository().getMenuContent(id: 5) {result in
    switch result {
    case .success(let model): print(model)
    case .failure(let error): print(error)
    }
}
