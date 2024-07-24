import UIKit


struct UrlConstants {
    static let baseURL = "https://persona.vincentselvakumar.org/api/"
    static let adminLogin = baseURL + "admin_login"
    static let volunteerLogin = baseURL + "volunteer_login"
    static let getDepartmentVolunteers = baseURL + "get_department_volunteers"
    static let getAttendence = baseURL + "get_attendance"
    static let monitorDelegate = baseURL + "monitor_delegate"
    static let assignedDepartments = baseURL + "assigned_departments"
    static let leadsList = baseURL + "leads_list"
    
}

struct DepartmentVolunteer: Codable {
    let volunteerId: Int
    let name: String
    let leader: Int
    let subLeader: Int
    let phoneNumber: String
    let loggedIn: Int
    let loggedOut: Int
    
    enum CodingKeys: String, CodingKey {
        case volunteerId = "volunteer_id"
        case name = "name"
        case leader = "leader"
        case subLeader = "sub_leader"
        case phoneNumber = "phone_number"
        case loggedIn = "loggedin"
        case loggedOut = "loggedout"
    }
}

struct VolunteerLoginResponse: Codable {
    let volunteerId: Int
    let name: String
    let leader: Int
    let subLeader: Int
    let departmentId: String
    let loggedIn: Int
    let loggedOut: Int
    
    enum CodingKeys: String, CodingKey {
        case volunteerId = "volunteer_id"
        case name = "name"
        case leader = "leader"
        case subLeader = "sub_leader"
        case departmentId = "department_id"
        case loggedIn = "loggedin"
        case loggedOut = "loggedout"
    }
}

struct Success: Codable {
    let message: String
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case code = "code"
    }
}

struct ErrorMessage: Codable, Error {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}
struct LeadsResponse: Codable, Hashable {
    let id: Int
    let name: String
    let fatherName: String
    let number: String
    let dob: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case fatherName = "father_name"
        case number = "number"
        case dob = "dob"
        case address = "address"
    }
}


struct LoginResponse: Codable {
    let message: String
    let accessToken: String
    let roleType: Int
    let gateId: String
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case accessToken = "access_token"
        case roleType = "role_type"
        case gateId = "gate_id"
        case code = "code"
    }
}
struct AssignedDepartment: Codable {
    let id: String
    let departmentName: String
    let duties: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case departmentName = "department_name"
        case duties = "duties"

    }
}

class LoginRepository {
    
    func checkVolunteerLogin(phoneNumber: String, completion: @escaping (Result<VolunteerLoginResponse, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.volunteerLogin)")!)
        urlRequest.httpMethod = "POST"
        let parameters: [String: String] = [
            "number": phoneNumber
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
                    let results = try JSONDecoder().decode(VolunteerLoginResponse.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    func checkUserLogin(userName: String, password: String) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.adminLogin)")!)
        urlRequest.httpMethod = "POST"
        let parameters: [String: String] = [
            "username": userName,
            "password": password
        ]
        let body = parameters.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        urlRequest.httpBody = body.data(using: .utf8)
        
        session.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            guard let data = data, error == nil else {
                print("error")
                return
            }
            print(String(data: data, encoding: .utf8))
            do{
                let results = try JSONDecoder().decode(LoginResponse.self, from: data)
                print(results)
            }
            catch {
                print("Error Decoding")
            }
        }.resume()
    }
    
    func getLeadsList(completion: @escaping (Result<[LeadsResponse], ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.leadsList)")!)
        urlRequest.httpMethod = "GET"
//        guard let authToken = LocalRepository().getAuthToken() else {return}
//        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("Bearer $2y$10$xRtWxUFEfPbF3JkBBKjN5uBToQHt7NrAD2ggKNCoGtrrfCOrRXSmO", forHTTPHeaderField: "Authorization")
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
                    let results = try JSONDecoder().decode([LeadsResponse].self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()

    }
    
    func getDepartmentVolunteers(deptId: Int, completion: @escaping (Result<[DepartmentVolunteer], ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.getDepartmentVolunteers)")!)
        urlRequest.httpMethod = "POST"
        let parameters: [String: Int] = [
            "department_id": deptId
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
            
//            print(String(data: data, encoding: .utf8))
            do {
                if let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(errorResponse))
                } else {
                    let results = try JSONDecoder().decode([DepartmentVolunteer].self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    func getAssignedDepartment(volunteerId: Int, completion: @escaping (Result<[AssignedDepartment], ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.assignedDepartments)")!)
        urlRequest.httpMethod = "POST"
        let parameters: [String: String] = [
            "volunteer_id": "\(volunteerId)"
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
            print(String(data: data, encoding: .utf8))
            do {
                if let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(errorResponse))
                } else {
                    let results = try JSONDecoder().decode([AssignedDepartment].self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    func sendMonitorRemarks(delegateId: String, delegateRemark: String,dateTime: String, volunteerId: String, completion: @escaping (Result<Success, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.monitorDelegate)")!)
        urlRequest.httpMethod = "POST"
        let parameters: [String: String] = [
            "field_62": volunteerId,
            "field_63": delegateRemark,
            "field_64": dateTime,
            "field_95": delegateId
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
                    let results = try JSONDecoder().decode(Success.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    func getVolunteerAttendence(volunteerId: Int, type: String, time: String, departmentId: String, completion: @escaping (Result<Success, ErrorMessage>) -> Void) {
        let session = URLSession.shared
        var urlRequest = URLRequest(url: URL(string: "\(UrlConstants.getAttendence)")!)
        urlRequest.httpMethod = "POST"
        let parameters: [String: Any] = [
            "volunteer_id": volunteerId,
            "type": type,
            "time": time,
            "department_id" : departmentId
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
            print(String(data: data, encoding: .utf8))
            do {
                if let httpResponse = httpUrlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(.failure(errorResponse))
                } else {
                    let results = try JSONDecoder().decode(Success.self, from: data)
                    completion(.success(results))
                }
            } catch {
                completion(.failure(ErrorMessage(message: "Failed to decode response")))
            }
        }.resume()
    }

    
}

//LoginRepository().checkUserLogin(userName: "sandeep@crimefire.in", password: "Super@persona")
//LoginRepository().checkUserLogin(userName: "jebastine@charismainfotainment.com", password: "lead@persona")
//LoginRepository().checkUserLogin(userName: "testingsite1604@gmail.com", password: "lead@persona")
//LoginRepository().checkUserLogin(userName: "stephen@charismainfotainment.com", password: "Call@persona")
//LoginRepository().checkUserLogin(userName: "dominic@charismainfotainment.com", password: "Call@persona")
//LoginRepository().checkUserLogin(userName: "gatekeeper1@gmail.com", password: "Gate@persona")

//LoginRepository().getLeadsList { result in
//    switch result {
//    case .success(let model):
//        print(model)
//    case .failure(let error): print(error)
//    }
//}
//
//LoginRepository().getDepartmentVolunteers(deptId: 3) {
//    result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error.localizedDescription)
//    }
//}

//LoginRepository().checkVolunteerLogin(phoneNumber: "6379841032") { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}

//LoginRepository().getAssignedDepartment(volunteerId: 3433) { result in
//    switch result {
//    case .success(let model): print(model)
//    case .failure(let error): print(error)
//    }
//}


func sendMonitorRemark() {
    let delegateId = "5"
    let delegateRemark = "Good behaviour"
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
    //    let currentTime = formatter.string(from: Date())
    let dateTime = "2-23-08-16 13:52:00"
    let volunteerId = "1"
    LoginRepository().sendMonitorRemarks(delegateId: delegateId, delegateRemark: delegateRemark, dateTime: "", volunteerId: volunteerId) { result in
        switch result {
        case .success(let model): print(model)
        case .failure(let error): print(error)
        }
    }
}

//func changeVolunteerClockStatus() {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "HH:mm"
//    let currentTime = formatter.string(from: Date())
//    var type: String = "OUT"
//    LoginRepository().getVolunteerAttendence(volunteerId: 1, type: type, time: currentTime, departmentId: "1") { result in
//        switch result {
//        case .success(let model): print(model)
//        case .failure(let error): print(error)
//        }
//    }
//}

//changeVolunteerClockStatus()

sendMonitorRemark()
