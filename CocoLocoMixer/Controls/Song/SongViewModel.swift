//
//  SongModel.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 30/01/2024.
//
import Foundation
import AVFoundation

class SongViewModel: ObservableObject {
    @Published var waveformData: [Double]?
    var isLoadingSong : Bool = true
    var duration : Double?
    
    init(url: String) {
        generateWaveformData(filePath: url)
    }
    
    func generateWaveformData(filePath: String) {
        let completionHandler: ([Double]?) -> Void = { [weak self] wave in
            DispatchQueue.main.async {
                self?.waveformData = wave ?? nil
                self?.isLoadingSong = false
            }
        }

        if let url = URL(string: filePath), url.scheme != nil {
            downloadFile(from: url) { [weak self] (localURL, error) in
                if let localURL = localURL {
                    self?.readAudioFile(from:localURL, completion:completionHandler)
                } else {
                    //print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
                    completionHandler(nil)
                }
            }
        } else {
            let audioUrl = URL(fileURLWithPath: filePath)
            readAudioFile(from:audioUrl, completion:completionHandler)
        }
    }
     
    func readAudioFile(from audioUrl: URL,
                             completion: @escaping (_ waveHeights: [Double]?) -> Void) {
        
        readBuffer(audioUrl) { samples, sampleRate in
            guard let samples = samples else {
                completion(nil)
                return
            }
        
            autoreleasepool {
                
                let totalSamples = Int(samples.count)
                self.duration = AppSettings.SecondsToScreen(for: (Double(totalSamples) / sampleRate))
                
                let segmentSizeInRate = Int(AppSettings.segmentSizeInSeconds * sampleRate)
                
                //print("song \(audioUrl) has length \((self.duration!)/60) minutes")
                let segmentCounts = Int(ceil(Double(totalSamples) / Double(segmentSizeInRate)))
                let imageSize =
                            CGSize(
                                width: AppSettings.SecondsToScreen(for: self.duration),
                                height: AppSettings.waveformHeight)
                
                var waveHeights: [Double] = []
                let maxAmplitude = samples.max() ?? 0
                let heightNormalizationFactor = (Double(imageSize.height) / Double(maxAmplitude))/2
                
                //print("segment counts : \(segmentCounts)")
                
                for index in 0..<segmentCounts {
                    let startIndex = index * segmentSizeInRate
                    let endIndex = min((index + 1) * segmentSizeInRate, totalSamples)

                    let averageSample = samples[startIndex..<endIndex].reduce(0.0) { $0 + Double($1) } / Double(min(segmentSizeInRate, totalSamples - (index*segmentSizeInRate)))

                    let normalizedSample = CGFloat(averageSample) * CGFloat(heightNormalizationFactor)
                    let waveHeight = abs(normalizedSample)
                    
                   // print("wave height : \(waveHeight)")
                    waveHeights.append(waveHeight)
                }
                
                print("song : \(audioUrl) done, max : \(waveHeights.max() ?? 0)")
                completion(waveHeights)
            }
        }
    }
        
    func downloadFile(from url: URL, completion: @escaping (URL?, Error?) -> Void) {
        let tempDirectoryURL = FileManager.default.temporaryDirectory
        let destinationURL = tempDirectoryURL.appendingPathComponent(url.lastPathComponent)
        
        // Check if the file already exists at destinationURL
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            completion(destinationURL, nil)
            return
        }
        
        URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
            guard let tempURL = tempURL, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                completion(destinationURL, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }


    
}
