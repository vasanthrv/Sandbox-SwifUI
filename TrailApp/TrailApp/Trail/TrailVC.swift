//
//  TrailVC.swift
//  TrailApp
//
//  Created by CharismaInfotainment on 12/05/23.
//

import UIKit
import Charts

struct RegisteredUsersResponse: Codable {
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum APIError: Error {
    case failedToConnect
    case failedToDecode
    case failedToSerializeRequestBody
}

struct UrlConstants {
    static let baseUrl = "https://evangel.stream/api/"
    
    static let home = baseUrl + "admin_app_dashboard"
    static let registeredUsers = baseUrl + "admin_app_registeredusers"
    static let paidSubscriptions = baseUrl + "admin_app_paidsubscriptions"
    static let activeSubscriptions = baseUrl + "admin_app_activesubscriptions"
}

struct AppConstants {
    static let Access_Token_Reference = ""
    static let IsUserLogin = "UserLoginKey"
    static let Access_Token = "Access_Token"
}

class TrailVC: UIViewController, URLSessionDownloadDelegate {
    var progressView: UIProgressView!
    var downloadTask: URLSessionDownloadTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a progress view to show the download progress
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.center = view.center
        progressView.trackTintColor = UIColor.lightGray
        progressView.tintColor = UIColor.blue
        view.addSubview(progressView)
        
        // Start the download task
        let url = URL(string: "https://customer-i6oni2kwo89vbrxk.cloudflarestream.com/c3a12c30f074637d2eb198f2abbbbbc8/dl/default.mp4?p=eyJ0eXBlIjoiZG93bmxvYWRzIiwidmlkZW9JRCI6ImMzYTEyYzMwZjA3NDYzN2QyZWIxOThmMmFiYmJiYmM4Iiwib3duZXJJRCI6MzMwODA3NDEsImNyZWF0b3JJRCI6IiIsImRvd25sb2FkVHlwZSI6ImRlZmF1bHQiLCJzdG9yYWdlUHJvdmlkZXIiOjIsImR1cmF0aW9uU2VjcyI6NDYxMS41OTk5OTg0NzQsInJlc29sdXRpb24iOiIxMDgwIiwidG90YWxCeXRlU2l6ZSI6MTE5NTI2MTk3N30&s=cWPCnsOYwozCncOswp7DssO7FTLDrhgWdMK9VSNuwqBYwqvDkUQSw68dwq1BdMKN")!
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // URLSessionDownloadDelegate method to track the download progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        // Update the progress view on the main queue
        DispatchQueue.main.async {
            self.progressView.progress = progress
        }
    }
    
    // URLSessionDownloadDelegate method called when the download is complete
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Get the downloaded file URL
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let destinationURL = URL(fileURLWithPath: documentsPath.appendingPathComponent("video.mp4"))
        
        // Move the downloaded file to the desired location
        do {
            try FileManager.default.moveItem(at: location, to: destinationURL)
            
            // Display a success message or perform any other actions after successful download
            print("Download completed!")
        } catch {
            // Display an error message or perform any other error handling
            print("Error: \(error.localizedDescription)")
        }
    }
}
