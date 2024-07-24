import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

enum APIError: Error {
    case failedToConnect
    case failedToDecode
}

struct UrlConstants {
    static let baseUrl = "https://evangel.stream/api/"
    
    static let login = baseUrl + "mobile_login"
    static let home = baseUrl + "mobile_home"
    static let livetv = baseUrl + "mobile_livetv"
    static let videoPlayback = baseUrl + "mobile_videoplayback"
    static let seriesPlayback = baseUrl + "mobile_seriespage"
    static let search = baseUrl + "mobile_search"
    static let categories = baseUrl + "mobile_menupage"
    static let history = baseUrl + "mobile_watchhistory"
    static let wishlist = baseUrl + "mobile_wishlist"
    static let viewall = baseUrl + "mobile_viewall"
    static let addtowishlist = baseUrl + "mobile_addwishlist"
    static let clearwishlist = baseUrl + "mobile_clearwishlist"
    static let addtohistory = baseUrl + "mobile_addhistory"
    static let clearhistory = baseUrl + "mobile_clearwatchhistory"
    static let userdetails = baseUrl + "mobile_userdetails"
    static let episodeMoreData = baseUrl + "mobile_episodedisplay"
    static let categoryLoadMore = baseUrl + "mobile_menuloadmore"
    static let entertainmemt = baseUrl + "mobile_entertainment"
    
    
}

struct AppConstants {
    
    static let Access_Token_Reference = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiNDNkM2ZiOTVmZmViMjQ0N2VjZTQ4ZDZjMzJjOTBiZjFiZTdmYjg0ZWU3MmEyNjhjNGI0Y2ZkM2IzYzY4OTE1MWYwOTg4MzFmYTg0OWJmNmYiLCJpYXQiOjE2Nzg5NDM3NTguMjk1MDY4LCJuYmYiOjE2Nzg5NDM3NTguMjk1MDcyLCJleHAiOjE3MTA1NjYxNTguMjQ5ODA1LCJzdWIiOiI0MTc3MyIsInNjb3BlcyI6W119.heHYEpVN-pf43bcf4qiDVqahem_wI7HvM2lAenHvBfiwSlncimyCwc1f3lCZTV93b7faAi_eHBUEja3SUVwm4lvgMlD8p69ANwTBAvPIF5nmgc9Lmi-j3U1gXwy6GeBp3wZHgOjgF4A7exKnZfMeLfnePRbVDuHnmYx3fkodPgrsVRjP_oZOD2V8uNcqD1bniLRAh6x5bvN7yR-azpawduXUyjfm3dW-iCW9AmLQNUK5VFpY3YUkqxfBfZajRGQbQeTH65Pyj3S-35Avr_1h4foGMR0l4lhw1xWOjNvXMnaWTMQo_pLipvQoWIrq9uIoqE9pnPDTx1JAZg-6252pgDYq-9leXTTZq3vHt3XtDbjyvmkBBaT8o3Mkg6OiiAXSuHtj2mMTzQFF5jcrgByJlkbyQdTgaeYfsS8DrpCTHCLIiAmo8ly_sUHgih_ipUb2CXYcFe6WDi7RFs3ovuSNMad7NlebxrjkRDnhcDhYL_BqI_kGlgZA3yDgUD9sEwFaeV6LNoOQi4Qp6EySxfh28bAEgtravw5YNXOoKP6mwFcInSCvh8qLtBjdqm-QRUM3XNyMCCuvMt9rNJ4ujyvIlj9Xn7WMNw_WkAp3rYO46txpJvQ96TfPQKqVv5Elt3OnbFro6RR_HnenWbAlV6VIZiaIzU1lLVwUhIxrikOUz84"
    static let authBearer = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiMzczNzZiMjQxZGVlOTgxODYyMTJmMzc5OWVlNjc2N2FhZjgwZDZkMzQwMGZhM2RkOTUzYjE5NDk2ZmY5NGQzNGJlOTY3OGE5YWVmMDVjZDEiLCJpYXQiOjE2NzIyMTYxMjAuMTg4NDU0LCJuYmYiOjE2NzIyMTYxMjAuMTg4NDU3LCJleHAiOjE3MDM3NTIxMjAuMTYzMDExLCJzdWIiOiIzOTMwMyIsInNjb3BlcyI6W119.GhFhDeF-VF_j84eIbk-_9XIPmafqqOmKk2kP_5ZIMIZqm5MoT94zJ5vTJo_tTSS4oU7to4yE_TDRiX966C3EIu1sGLgxPJFaTfMEwIqr5_IGdPc8YnEh_WS7fHTeHHBo7kb2_A5Ifh6yLafMFOZaXtQYsluOuO841UYkOr_1hz6EMPhE4rLrF9xgv5ECFfDhNB2m17B6Xm7j-Z2ulbTt-YVlijNQ_bih5J224Ox6m3oa4KQovclWTW0xfe1Jt37XTV3QG_J0VpUoAB-bnIVU7ZICMIjw0kx5k6InWhmOziRilDPLT61hsByQ1UynDuzvxuZY65k0cwNDxnBe3cVZRPMllO06PQk7gjkKaA3CQBAdgDqu0TMgHfhCreGvuElsh7WaZHPTtpB8ekY0j1DI8DBtuWDlbNho6PKlHlxmMCIN6ZOuUFuMQFzc8KrcKRHVzPgDn8kC6MIqX2CCzH-ckq69fOoqme97KgVE1zFV2eWXC4Jo-rKUNXgafIpQv7Un47AWlvn82j6cxpHG83EoCBax3MU2RYP2tbB55RkX7VklIWfKvGnQr_WsKIXlRMpOPATvExWDwQWoU2-8w2-GwMgg0nI_RuTuLQI21_0DqBFOBKhxxud2vv6DH4fh19y8jEzddExtQpVvdstPSaQN-xEO15Nj0q4ST5Hu-csMX7o"
    static let IsUserLogin = "UserLoginKey"
    static let Access_Token = "Access_Token"
    static let UserDetails = "User_Details"
    static let IsUserSubscribed = "User_Subscription"
}

struct MovieDataModel: Codable {
    let data: [MovieList]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}
struct MovieList: Codable {
    let id: Int
    let title: String
    let type: String
    let children: [ListItem]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case type = "type"
        case children = "children"
    }
}

struct ListItem: Codable {
    let type: String
    let contentType: String
    let title: String
    let description: String
    let id: Int
    let thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case contentType = "content_type"
        case title = "title"
        case description = "description"
        case id = "id"
        case thumbnailURL = "thumbnail_url"
    }
}

enum ContentType: String, Codable {
    case movie = "movie"
    case series = "series"
    case live = "live"
    case unknown
}

class APICaller {
    static let shared = APICaller()
    func addToWishList(id: Int, contentType: ContentType,  completion: @escaping (Result<Void, Error>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.addtowishlist)")!)
        urlRequest.httpMethod = "POST"
        let authToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiMzczNzZiMjQxZGVlOTgxODYyMTJmMzc5OWVlNjc2N2FhZjgwZDZkMzQwMGZhM2RkOTUzYjE5NDk2ZmY5NGQzNGJlOTY3OGE5YWVmMDVjZDEiLCJpYXQiOjE2NzIyMTYxMjAuMTg4NDU0LCJuYmYiOjE2NzIyMTYxMjAuMTg4NDU3LCJleHAiOjE3MDM3NTIxMjAuMTYzMDExLCJzdWIiOiIzOTMwMyIsInNjb3BlcyI6W119.GhFhDeF-VF_j84eIbk-_9XIPmafqqOmKk2kP_5ZIMIZqm5MoT94zJ5vTJo_tTSS4oU7to4yE_TDRiX966C3EIu1sGLgxPJFaTfMEwIqr5_IGdPc8YnEh_WS7fHTeHHBo7kb2_A5Ifh6yLafMFOZaXtQYsluOuO841UYkOr_1hz6EMPhE4rLrF9xgv5ECFfDhNB2m17B6Xm7j-Z2ulbTt-YVlijNQ_bih5J224Ox6m3oa4KQovclWTW0xfe1Jt37XTV3QG_J0VpUoAB-bnIVU7ZICMIjw0kx5k6InWhmOziRilDPLT61hsByQ1UynDuzvxuZY65k0cwNDxnBe3cVZRPMllO06PQk7gjkKaA3CQBAdgDqu0TMgHfhCreGvuElsh7WaZHPTtpB8ekY0j1DI8DBtuWDlbNho6PKlHlxmMCIN6ZOuUFuMQFzc8KrcKRHVzPgDn8kC6MIqX2CCzH-ckq69fOoqme97KgVE1zFV2eWXC4Jo-rKUNXgafIpQv7Un47AWlvn82j6cxpHG83EoCBax3MU2RYP2tbB55RkX7VklIWfKvGnQr_WsKIXlRMpOPATvExWDwQWoU2-8w2-GwMgg0nI_RuTuLQI21_0DqBFOBKhxxud2vv6DH4fh19y8jEzddExtQpVvdstPSaQN-xEO15Nj0q4ST5Hu-csMX7o"
        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        var type = "movie"
        switch contentType {
        case .movie: type = "movie"
        default: type = "series"
        }
        let parameters = [
            "id": id,
            "content_type": type
        ] as [String : Any]
        let body = parameters.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        urlRequest.httpBody = body.data(using: .utf8)
        print(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8))
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToConnect))
                return}
            if let response = httpUrlResponse as? HTTPURLResponse {
                if(response.statusCode == 200){
                    completion(.success(()))
                }
            }
            print("Data")
            print(String(data: data, encoding: .utf8))
        }.resume()
    }
}


APICaller.shared.addToWishList(id: 27, contentType: .movie) { result in
    switch result {
    case .success():
        DispatchQueue.main.async {
            print("Success in Caller")
        }
    case .failure(let error):
        DispatchQueue.main.async {
            print("Fail in Caller \(error)")
        }
    }
}

