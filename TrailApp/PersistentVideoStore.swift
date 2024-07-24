//
//  PersistentVideoStore.swift
//  TrailApp
//
//  Created by CharismaInfotainment on 10/07/23.
//

import Foundation

class PersistentVideoStore {
    static let shared = PersistentVideoStore()

    // MARK: - Core Data Stack
    
    // Fetched videos
    var fetchedVideosController: NSFetchedResultsController<Video> {
        if let controller = _fetchedVideosController {
            return controller
        }
        _fetchedVideosController = self.createControllerWithFetchRequest(Video.fetchRequest(), search: nil, isDownloaded: nil)
        return _fetchedVideosController!
    }
    private var _fetchedVideosController: NSFetchedResultsController<Video>?
    
    // Fetched streamed videos
    var fetchedStreamingVideosController: NSFetchedResultsController<StreamingVideo> {
        if let controller = _fetchedStreamingVideosController {
            return controller
        }
        _fetchedStreamingVideosController = self.createControllerWithFetchRequest(StreamingVideo.fetchRequest(), search: nil, isDownloaded: nil)
        return _fetchedStreamingVideosController!
    }
    private var _fetchedStreamingVideosController: NSFetchedResultsController<StreamingVideo>?
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourModelName") // Replace with your Core Data model name
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Creating items
    
    func createNewVideo(youTubeUrl: String, streamUrl: String, videoObject: XCDYouTubeVideo?) -> Video {
        let newVideo = Video(context: managedObjectContext)
        
        newVideo.created = Date()
        newVideo.isDoneDownloading = false
        newVideo.youtubeUrl = youTubeUrl
        newVideo.title = videoObject?.title
        newVideo.streamUrl = streamUrl
        newVideo.watchProgress = .unwatched
        
        saveContext()
        
        return newVideo
    }
    
    func createNewStreamingVideo(youTubeUrl: String, streamUrl: String, videoObject: XCDYouTubeVideo?) -> StreamingVideo {
        let newVideo = StreamingVideo(context: managedObjectContext)
        
        newVideo.youtubeUrl = youTubeUrl
        newVideo.title = videoObject?.title
        newVideo.streamUrl = streamUrl
        newVideo.watchProgress = .unwatched
        
        saveContext()
        
        return newVideo
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Fetching videos
    
    func fetchVideos(withSearch search: String?, isDownloaded: Bool?) -> [Video] {
        let fetchRequest: NSFetchRequest<Video> = Video.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.predicate = predicatesWithSearch(search, isDownloaded: isDownloaded)
        
        do {
            let videos = try managedObjectContext.fetch(fetchRequest)
            return videos
        } catch {
            print("Failed to fetch videos: \(error)")
            return []
        }
    }
    
    private func predicatesWithSearch(_ search: String?, isDownloaded: Bool?) -> NSPredicate? {
        var predicates: [NSPredicate] = []
        
        if let search = search, !search.isEmpty {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", search)
            predicates.append(predicate)
        }
        
        if let isDownloadedPredicate = isDownloaded {
            let predicate = NSPredicate(format: "isDoneDownloading == %@", NSNumber(value: isDownloadedPredicate))
            predicates.append(predicate)
        }
        
        if !predicates.isEmpty {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        return nil
    }
}
