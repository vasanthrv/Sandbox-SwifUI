import UIKit

struct UrlConstants {
    static let baseURL = "https://evapi.crimefire.in/api/"
    
    static let register = baseURL + "register"
    static let login = baseURL + "login"
    static let validateEmail = baseURL + "validate_email"
    static let menus = baseURL + "menus"
    static let menuContent =  baseURL + "menu_content"
    static let contentTypes = baseURL + "content_type"
    static let home = baseURL + "home"
    static let moviesSection = baseURL + "movies_section"
    static let liveTvSection = baseURL + "livetv_section"
    static let videoPlayback = baseURL + "video_playback"
    static let getProfile = baseURL + "get_profile"
    static let updateProfile = baseURL + "update_profile"
    static let getInfo = baseURL + "get_info"
    static let addWishlist = baseURL + "add_wishlist"
    static let getWishlist = baseURL + "get_wishlist"
    static let removeWishlist = baseURL + "remove_wishlist"
    static let homeViewAll = baseURL + "home_viewall"
    static let homeSearch = baseURL + "home_search"
    static let userFeedback = baseURL + "user_feedback"
    static let history = baseURL + "show_watchhistory"
}


struct ErrorMessage: Codable, Error {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

struct MenuCategoryItem: Codable {
    let id: Int
    let title: String
    let content: [Content]?

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
    }
}

struct Content: Codable {
    let contentId: Int
    let contentTypeId: Int
    let thumbnail: URL

    enum CodingKeys: String, CodingKey {
        case contentId = "content_id"
        case contentTypeId = "content_type_id"
        case thumbnail
    }
}

struct VideoPlaybackData: Codable {
    let details: [ContentDetail]
      let seasons: [Season]?
      let episodes: [Episode]
      let more: [More]

    struct ContentDetail: Codable {
        let contentId: String
        let seriesTitle: String
        let episodeTitle: String
        let contentDescription: String
        let contentRating: Int
        let duration: String
        let language: String
        let videoURL: URL
        
        enum CodingKeys: String, CodingKey {
            case contentId = "content_id"
            case seriesTitle = "series_title"
            case episodeTitle = "episode_title"
            case contentDescription = "content_description"
            case contentRating = "content_rating"
            case duration = "duration"
            case language
            case videoURL = "video_url"
        }
    }

    struct Season: Codable {
        // Define properties for Season if needed
    }

    struct Episode: Codable {
        let contentId: String
        let contentTypeID: Int?
        let episodeID: Int
        let episodeNumber: Int
        let thumbnail: URL

        enum CodingKeys: String, CodingKey {
            case contentId = "content_id"
            case contentTypeID = "content_type_id"
            case episodeID = "episode_id"
            case episodeNumber = "episode_number"
            case thumbnail = "thumbnail"
        }
    }

    struct More: Codable {
        let contentId: Int
        let contentTypeID: Int?
        let thumbnail: String

        enum CodingKeys: String, CodingKey {
            case contentId = "content_id"
            case contentTypeID = "content_type_id"
            case thumbnail = "thumbnail"
        }
    }
}

struct WishlistItem: Codable {
    let wishlist_id: Int
    let content_id: Int
    let content_type_id: Int
    let content_title: String
    let content_description: String
    let thumbnail: URL
}

struct HistoryItem: Codable {
    let watchhistory_id: Int
    let content_id: Int
    let content_type_id: Int
    let content_title: String
    let content_description: String
    let thumbnail: URL
}

struct SliderDataItem: Codable {
    let sliderType: Int
    let sliderAppImage: URL
    let sliderTvImage: URL
    let contentId: Int
    let contentTypeId: Int
    let genreName: String

    enum CodingKeys: String, CodingKey {
        case sliderType = "slider_type"
        case sliderAppImage = "slider_app_image"
        case sliderTvImage = "slider_tv_image"
        case contentId = "content_id"
        case contentTypeId = "content_type_id"
        case genreName = "genre_name"
    }
    func convertToContent() -> Content {
            return Content(
                contentId: self.contentId,
                contentTypeId: self.contentTypeId,
                thumbnail: self.sliderAppImage // You can choose either sliderAppImage or sliderTvImage as the thumbnail URL
            )
        }
}
struct ContinueWatching: Codable {
    let id: Int?
    let contentTypeId: Int?
    let episodeId: Int?
    let contentId: Int
    let totalDuration: String
    let watchTime: String
    let thumbnail: URL
    let contentTitle: String?

    // Computed property to calculate progress
    var progress: Double? {
            let totalDurationInSeconds = durationInSeconds(from: totalDuration)
            let watchTimeInSeconds = durationInSeconds(from: watchTime)
            
            if totalDurationInSeconds > 0 {
                return Double(watchTimeInSeconds) / Double(totalDurationInSeconds)
            } else {
                return nil
            }
        }

    enum CodingKeys: String, CodingKey {
        case id
        case contentId = "content_id"
        case contentTypeId = "content_type_id"
        case episodeId = "episode_id"
        case totalDuration = "total_duration"
        case watchTime = "watch_time"
        case thumbnail
        case contentTitle = "content_title"
    }

    // Helper function to convert time duration string to seconds
    private func durationInSeconds(from duration: String) -> Int {
        let components = duration.components(separatedBy: ":")
        if components.count == 2, let minutes = Int(components[0]), let seconds = Int(components[1]) {
            return (minutes * 60) + seconds
        } else {
            return 0
        }
    }
}

struct MovieResponse: Codable {
    let sliders: [SliderDataItem]
    let continueWatching: [ContinueWatching]
    let recentlyAdded: [Content]
    let movies: [Content]

    enum CodingKeys: String, CodingKey {
        case sliders
        case continueWatching = "continue_watching"
        case recentlyAdded = "recently_added"
        case movies
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let contentTypeID: Int
    let thumbnail: URL

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case contentTypeID = "content_type_id"
        case thumbnail
    }
}

class PlaybackRepository {
    func getPlayback(completion: @escaping (Result<VideoPlaybackData, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.videoPlayback)/94/2")!)
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
                    let results = try JSONDecoder().decode(VideoPlaybackData.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    func getWishlistItem(completion: @escaping (Result<[WishlistItem], ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.getWishlist)")!)
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
                    let results = try JSONDecoder().decode([WishlistItem].self, from: data)
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
    
    func getHistory(completion: @escaping (Result<[HistoryItem], ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.history)")!)
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
                    let results = try JSONDecoder().decode([HistoryItem].self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
        
    }
    
    func getMovies(completion: @escaping (Result<MovieResponse, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.moviesSection)")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer 15|PGuGGMXI43K8kP4DrK00gZenZMtgVA1mu69OlGtI45f67e5a", forHTTPHeaderField: "Authorization")
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
                    let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
}

//PlaybackRepository().getMenuContent(id: 1) {result in
//    switch result {
//    case .success(let model): print(model)
//        
//    case .failure(let error):print(error)
//    }
//}
//PlaybackRepository().getPlayback { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}

//PlaybackRepository().getWishlistItem { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}
//
//PlaybackRepository().getHistory  { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}

PlaybackRepository().getMovies { result in
    switch result {
    case .success(let model): print(model)
    case .failure(let error): print(error)
    }
    
}
