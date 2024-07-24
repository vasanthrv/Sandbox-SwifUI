import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct HomePageDataModel: Codable {
    let drawer: [SideDrawerMenu]
    let data: [MainData]
    let id: Int
}

// MARK: - SideDrawerMenu
struct SideDrawerMenu: Codable, Identifiable, Hashable {
    let id: Int
    let type, title: String
    let children: [SideDrawerMenu]?
}

// MARK: - MainData
struct MainData: Codable, Identifiable, Hashable { // model for each category
    let id: Int
    let type: DatumType
    let children: [DataModel]
    let title: String? // Category Title
}

// MARK: - DataModel
struct DataModel: Codable, Identifiable, Hashable { // model for each title
    let type: String //
    let contentType: String
    let id: Int
    let imageURL, landscapeURL, thumbnailURL: String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case contentType = "content_type"
        case id
        case imageURL = "image_url"
        case landscapeURL = "landscape_url"
        case thumbnailURL = "thumbnail_url"
    }
}

enum ContentType: String, Codable {
    case movie = "movie"
    case series = "series"
}

enum ChildType: String, Codable {
    case collectionItem = "collection_item"
    case sliderItem = "slider_item"
}

enum DatumType: String, Codable {
    case collection = "collection"
    case slider = "slider"
}

///

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
    
    
}
class APICaller {
    static let shared = APICaller()
    
    func getRecentlyAddedVideos(completion: @escaping (Result<HomePageDataModel,Error>) -> Void) {
        let authBearer = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiMzczNzZiMjQxZGVlOTgxODYyMTJmMzc5OWVlNjc2N2FhZjgwZDZkMzQwMGZhM2RkOTUzYjE5NDk2ZmY5NGQzNGJlOTY3OGE5YWVmMDVjZDEiLCJpYXQiOjE2NzIyMTYxMjAuMTg4NDU0LCJuYmYiOjE2NzIyMTYxMjAuMTg4NDU3LCJleHAiOjE3MDM3NTIxMjAuMTYzMDExLCJzdWIiOiIzOTMwMyIsInNjb3BlcyI6W119.GhFhDeF-VF_j84eIbk-_9XIPmafqqOmKk2kP_5ZIMIZqm5MoT94zJ5vTJo_tTSS4oU7to4yE_TDRiX966C3EIu1sGLgxPJFaTfMEwIqr5_IGdPc8YnEh_WS7fHTeHHBo7kb2_A5Ifh6yLafMFOZaXtQYsluOuO841UYkOr_1hz6EMPhE4rLrF9xgv5ECFfDhNB2m17B6Xm7j-Z2ulbTt-YVlijNQ_bih5J224Ox6m3oa4KQovclWTW0xfe1Jt37XTV3QG_J0VpUoAB-bnIVU7ZICMIjw0kx5k6InWhmOziRilDPLT61hsByQ1UynDuzvxuZY65k0cwNDxnBe3cVZRPMllO06PQk7gjkKaA3CQBAdgDqu0TMgHfhCreGvuElsh7WaZHPTtpB8ekY0j1DI8DBtuWDlbNho6PKlHlxmMCIN6ZOuUFuMQFzc8KrcKRHVzPgDn8kC6MIqX2CCzH-ckq69fOoqme97KgVE1zFV2eWXC4Jo-rKUNXgafIpQv7Un47AWlvn82j6cxpHG83EoCBax3MU2RYP2tbB55RkX7VklIWfKvGnQr_WsKIXlRMpOPATvExWDwQWoU2-8w2-GwMgg0nI_RuTuLQI21_0DqBFOBKhxxud2vv6DH4fh19y8jEzddExtQpVvdstPSaQN-xEO15Nj0q4ST5Hu-csMX7o"
        
        let session = URLSession.shared // Using a shared session
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.home)")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(authBearer, forHTTPHeaderField: "Authorization")
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(HomePageDataModel.self, from: data)
                completion(.success(results))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}


APICaller.shared.getRecentlyAddedVideos() { result in
    switch result {
    case .success(let model):
        print(model.data.count)
        print("\n\(model.data)")
        for i in model.data {
            for j in i.children {
                print("Title: \(i.title ?? "")  \(j)")
            }
        }
    case .failure(let error):
        print(error.localizedDescription)
    }
}
