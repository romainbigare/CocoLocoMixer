//
//  YoutubeHelper.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 16/02/2024.
//

import Foundation
import YouTubeKit
import XCDYouTubeKit
import AVFoundation
import Alamofire


struct YoutubeHelper {
    
    static var player: AVPlayer?

    
    static func downloadSongNoXCD(with songId: String, completion: @escaping (Result<String, Error>) -> Void) async {
        do {
            let stream = try await YouTube(videoID: songId, methods: [.local, .remote]).streams
                                      .filterAudioOnly()
                                      .filter { $0.fileExtension == .m4a }
                                      .highestAudioBitrateStream()
            
            guard let streamURL = stream?.url else {
                completion(.failure(NSError(domain: "YoutubeHelper", code: 0, userInfo: [NSLocalizedDescriptionKey: "Stream is null"])))
                return
            }
            
            downloadSongFromURL(streamURL) { result in
                switch result {
                case .success(let localFilePath):
                    completion(.success(localFilePath))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        } catch {
            completion(.failure(NSError(domain: "YoutubeHelper", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
        }
    }
    
    
    static func downloadSong(with songId: String, completion: @escaping (Result<String, Error>) -> Void) async {
        do{
            XCDYouTubeClient.default().getVideoWithIdentifier(songId, completionHandler: {(video: XCDYouTubeVideo?, error: Error?) -> Void in
                
                if video != nil {
                    if let streamURL = (video?.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ??
                                        video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] ??
                                        video?.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] ??
                                        video?.streamURLs[XCDYouTubeVideoQuality.small240.rawValue]) {
                        print("streamURL: \(streamURL)")
                        
                        downloadSongFromURL(streamURL) { result in
                            switch result {
                            case .success(let localFilePath):
                                completion(.success(localFilePath))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                }
            })
        }catch {
            completion(.failure(NSError(domain: "YoutubeHelper", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
        }
    }
    
    static func downloadSongFromURL(_ url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let session = URLSession.shared
        let task = session.downloadTask(with: url) { (tempLocalUrl, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempLocalUrl = tempLocalUrl else {
                let error = NSError(domain: "YoutubeHelper", code: 0, userInfo: [NSLocalizedDescriptionKey: "Temporary local URL not found"])
                completion(.failure(error))
                return
            }
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)

            do {
                try FileManager.default.moveItem(at: tempLocalUrl, to: destinationURL)
                completion(.success(destinationURL.path))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    
    static func playPreview(with songId: String ) async {
        do {
            let stream = try await YouTube(videoID: songId, methods: [.local, .remote]).streams
                                      .filterAudioOnly()
                                      .filter { $0.fileExtension == .m4a }
                                      .highestAudioBitrateStream()
            
            guard let streamURL = stream?.url else {
                print("Stream URL is nil.")
                return
            }
            player = AVPlayer(url: streamURL)
            player?.play()
        } catch {
            print("Failed to get audio stream: \(error)")
        }
    }
    
    static func pausePreview() {
        player?.pause()
    }
    
    
    // ALL TAKEN FROM HERE :
    // https://stackoverflow.com/questions/33489230/youtube-api-v3-search-list-returning-irrelevant-videos-swift
    
    static func searchYouTubeVideos(searchString: String, completion: @escaping ([String]?, [String]?, Error?) -> Void) {
        // Form the request URL string.
        let apiKey = AppSettings.youtubeAPIKey
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&fields=items(id(videoId),snippet(title))&order=viewCount&q=\(searchString)&type=video&maxResults=15&key=\(apiKey)"
        
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        // Create a NSURL object based on the above string.
        guard let targetURL = URL(string: urlString) else {
            completion(nil, nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        // Get the results.
        performGetRequest(targetURL: targetURL) { (data, HTTPStatusCode, error) in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            guard HTTPStatusCode == 200 else {
                completion(nil, nil, NSError(domain: "HTTP Error", code: HTTPStatusCode, userInfo: nil))
                return
            }
            
            do {
                // Convert the JSON data to a dictionary object.
                guard let resultsDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                      let items = resultsDict["items"] as? [[String: Any]] else {
                    completion(nil, nil, NSError(domain: "Parsing Error", code: 0, userInfo: nil))
                    return
                }
                
                // Extract video titles and IDs from the search results.
                var videoTitles = [String]()
                var videoIds = [String]()
                for item in items {
                    guard let snippet = item["snippet"] as? [String: Any],
                          let title = snippet["title"] as? String,
                          let id = item["id"] as? [String: Any],
                          let videoId = id["videoId"] as? String else {
                        continue
                    }
                    videoTitles.append(title)
                    videoIds.append(videoId)
                }
                
                completion(videoTitles, videoIds, nil)
            } catch {
                completion(nil, nil, error)
            }
        }
    }



    static func performGetRequest(targetURL: URL, completion: @escaping (Data?, Int, Error?) -> Void) {
        let request = URLRequest(url: targetURL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, 0, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                completion(data, httpResponse.statusCode, nil)
            }
        }
        
        task.resume()
    }
}
