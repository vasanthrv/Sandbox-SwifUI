//
//  DownloadManager.swift
//  TrailApp
//
//  Created by CharismaInfotainment on 10/07/23.
//

//import UIKit
//
//let maxNumberOfActiveDownloads = 3
//
//protocol DownloadManagerDelegate: class {
//    func videoIndexForYouTubeUrl(_ url: String) -> Int?
//    func videoIndexForStreamUrl(_ url: String) -> Int?
//    func localFilePathForUrl(_ streamUrl: String) -> URL?
//}
//
//class DownloadManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
//    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
//    var dataTask: URLSessionDataTask?
//    private(set) var activeDownloads: [Download] = [] //Only allows 3
//    private(set) var enqueuedDownloads: [Download] = []
//
//    private lazy var downloadsSession: URLSession = {
//        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
//        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
//        return session
//    }()
//
//    weak var delegate: DownloadManagerDelegate?
//    weak var videoManagerDelegate: VideoManagerDelegate?
//    var fileManager: FileManager = .default
//
//    // Path where the video files are stored
//    var documentsPath: String {
//        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    }
//
//    init(delegate: DownloadManagerDelegate?, videoManagerDelegate: VideoManagerDelegate?, fileManager: FileManager) {
//        super.init()
//
//        self.delegate = delegate
//        self.videoManagerDelegate = videoManagerDelegate
//        self.fileManager = fileManager
//
//        // Need to specifically init this because self has to be used in the argument, which isn't formed until here
//        _ = self.downloadsSession
//    }
//
//    // MARK: - Dealing with downloads queue
//
//    private func addDownload(_ download: Download) {
//        if self.activeDownloads.count < maxNumberOfActiveDownloads {
//            download.downloadTask?.resume()
//            download.state = .downloading
//            self.activeDownloads.append(download)
//        } else {
//            self.enqueuedDownloads.append(download)
//        }
//    }
//
//    func getDownloadWith(streamUrl: String) -> Download? {
//        if let video = self.activeDownloads.first(where: { $0.url == streamUrl }) {
//            return video
//        } else if let video = self.enqueuedDownloads.first(where: { $0.url == streamUrl }) {
//            return video
//        }
//
//        return nil
//    }
//
//    @discardableResult
//    private func removeDownloadWith(streamUrl: String, cancelDownload: Bool) -> Bool {
//        if let index = self.activeDownloads.index(where: { $0.url == streamUrl }) {
//            let download = self.activeDownloads.remove(at: index)
//            if cancelDownload { download.downloadTask?.cancel() }
//
//            guard self.activeDownloads.count < maxNumberOfActiveDownloads else { return true }
//
//            let firstEnqueuedDownload = self.enqueuedDownloads.first { $0.state != .paused }
//            if let firstEnqueuedDownload = firstEnqueuedDownload {
//                self.resumeDownload(firstEnqueuedDownload)
//            }
//
//            return true
//        } else if let index = self.enqueuedDownloads.index(where: { $0.url == streamUrl }) {
//            let download = self.enqueuedDownloads.remove(at: index)
//            if cancelDownload { download.downloadTask?.cancel() }
//            return true
//        }
//
//        return false
//    }
//
//    // MARK: - Getting index for videos
//
//    func videoIndexForDownloadTask(_ downloadTask: URLSessionDownloadTask) -> Int? {
//        if let url = downloadTask.originalRequest?.url?.absoluteString {
//            return self.delegate?.videoIndexForStreamUrl(url)
//        }
//
//        return nil
//    }
//
//    // MARK: - Downloading
//
//    func startDownload(_ video: Video) -> Int? {
//        print("Starting download of video \(video.title ?? "unknown video")")
//        if let urlString = video.streamUrl, let url = URL(string: urlString), let index = self.delegate?.videoIndexForStreamUrl(urlString) {
//            let download = Download(url: urlString)
//            download.downloadTask = self.downloadsSession.downloadTask(with: url)
//            self.addDownload(download)
//
//            return index
//        }
//
//        return nil
//    }
//
//    func pauseDownload(_ video: Video) {
//        print("Pausing download")
//        if let urlString = video.streamUrl, let download = self.getDownloadWith(streamUrl: urlString) {
//            if download.state == .downloading {
//                download.downloadTask?.cancel(byProducingResumeData: { resumeData in
//                    download.resumeData = resumeData
//                })
//                download.state = .paused
//            }
//
//            self.removeDownloadWith(streamUrl: urlString, cancelDownload: false)
//            self.enqueuedDownloads.append(download)
//        }
//    }
//
//    func cancelDownload(_ video: Video) {
//        print("Cancelling download of video \(video.title ?? "unknown video")")
//        if let urlString = video.streamUrl {
//            self.removeDownloadWith(streamUrl: urlString, cancelDownload: true)
//        }
//    }
//
//    func resumeVideoDownload(_ video: Video) {
//        print("Resuming download of video \(video.title ?? "unknown video")")
//        if let urlString = video.streamUrl, let download = self.getDownloadWith(streamUrl: urlString) {
//            self.resumeDownload(download)
//        }
//    }
//
//    func resumeDownload(_ download: Download) {
//        guard !self.activeDownloads.contains(download) else { return }
//
//        if let resumeData = download.resumeData {
//            download.downloadTask = self.downloadsSession.downloadTask(withResumeData: resumeData)
//            download.downloadTask?.resume()
//            download.state = .downloading
//        } else if let url = URL(string: download.url) {
//            download.downloadTask = self.downloadsSession.downloadTask(with: url)
//            download.downloadTask?.resume()
//            download.state = .downloading
//        }
//
//        self.removeDownloadWith(streamUrl: download.url, cancelDownload: false)
//        self.activeDownloads.append(download)
//    }
//
//    private func markDownloadAsDoneIfNeeded(_ download: Download, at index: Int) {
//        if download.isDone {
//            let video = PersistentVideoStore.shared.fetchedVideosController.object(at: IndexPath(item: index, section: 0))
//            video.isDoneDownloading = NSNumber(value: true)
//            PersistentVideoStore.shared.save()
//        }
//    }
//
//    // MARK: - URLSessionDownloadDelegate
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        if let originalURL = downloadTask.originalRequest?.url?.absoluteString {
//
//            if let destinationURL = self.delegate?.localFilePathForUrl(originalURL) {
//                print("Destination URL: \(destinationURL)")
//
//                let fileManager = self.fileManager
//
//                do {
//                    try fileManager.removeItem(at: destinationURL)
//                } catch {
//                    print("No file to remove. Proceeding...")
//                }
//
//                do {
//                    try fileManager.moveItem(at: location, to: destinationURL)
//                } catch let error as NSError {
//                    print("Could not move file: \(error.localizedDescription)")
//                }
//
//                if let url = downloadTask.originalRequest?.url?.absoluteString {
//                    self.removeDownloadWith(streamUrl: url, cancelDownload: true)
//
//                    if let videoIndex = self.videoIndexForDownloadTask(downloadTask) {
//                        self.videoManagerDelegate?.reloadRows([IndexPath(item: videoIndex, section: 0)])
//                    }
//                }
//            }
//        }
//    }
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//
//        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString, let download =  self.getDownloadWith(streamUrl: downloadUrl) {
//            download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
//            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
//
//            if let videoIndex = self.videoIndexForDownloadTask(downloadTask) {
//                self.markDownloadAsDoneIfNeeded(download, at: videoIndex)
//
//                self.videoManagerDelegate?.updateDownloadProgress(download, at: videoIndex, with: totalSize)
//            }
//        }
//    }
//
//    // MARK: - URLSessionDelegate
//
//    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//        print("URLSession did finish background download events")
//        DispatchQueue.main.async {
//            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
//                    appDelegate.backgroundSessionCompletionHandler = nil
//                    DispatchQueue.main.async(execute: {
//                        completionHandler()
//                    })
//                }
//            }
//        }
//    }
//}
