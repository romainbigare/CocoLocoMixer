//
//  SongModel.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 30/01/2024.
//
import Foundation
import AVFoundation

class SongViewModel: ObservableObject {
    @Published var waveformData: [Double] = []
    var isLoadingSong : Bool = true
    var duration : Double = 400.0
    
    init(mp3Song: String) {
        self.waveformData = self.generateZeroWaveform(isZero:false)
        generateWaveformData(filePath: mp3Song)
    }
    
    func generateWaveformData(filePath: String) {
        let completionHandler: ([Double]?) -> Void = { [weak self] wave in
            let defaultWaveform = self?.generateZeroWaveform(isZero: true) ?? []
            DispatchQueue.main.async {
                self?.waveformData = wave ?? defaultWaveform
                self?.isLoadingSong = false
            }
        }

        if let url = URL(string: filePath), url.scheme != nil {
            downloadFile(from: url) { [weak self] (localURL, error) in
                if let localURL = localURL {
                    self?.generateWaveHeights(from:localURL, completion:completionHandler)
                } else {
                    print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
                    completionHandler(nil)
                }
            }
        } else {
            let audioUrl = URL(fileURLWithPath: filePath)
            generateWaveHeights(from:audioUrl, completion:completionHandler)
        }
    }

    
    func generateZeroWaveform(isZero:Bool) -> [Double] {
        // Your logic to generate a placeholder waveform
        // For simplicity, let's use a sample data set.
        if isZero{
            return [0.0, 0.0, 0.0]}
        
        else{
            return [0.2, 0.5, 0.8, 0.4, 0.6, 0.2, 0.7, 0.3]}
    }
    
     
    func generateWaveHeights(from audioUrl: URL,
                             completion: @escaping (_ waveHeights: [Double]?) -> Void) {
        readBuffer(audioUrl) { samples in
            guard let samples = samples else {
                completion(nil)
                return
            }
            
            let imageSize = CGSize(width: 400.0, height: 100.0)
        
            autoreleasepool {
                var waveHeights: [Double] = []

                let maxAmplitude = samples.max() ?? 0
                let heightNormalizationFactor = Double(imageSize.height) / Double(maxAmplitude) / 2
                
                var index = 0
                let samplesCount = samples.count
                let sizeWidth = 50
                let period = 500
                let segmentSize = Int(samplesCount / sizeWidth)
                
                // Initialize variables for rolling average calculation
                var sum = 0.0
                
                /*
                for index in 0..<samplesCount {
                    
                    let sampleAtIndex = self.calculateWaveValue(for: index, in: samples, with: segmentSize)
                    waveHeights.append(sampleAtIndex)
                    
                    // Update the running sum
                    sum += sampleAtIndex
                    
                    // Calculate rolling average over 500 periods
                    if index >= period {
                        let average = sum / Double(period)
                        // Subtract the oldest value from the sum
                        sum -= waveHeights[index - period]
                    }
                }
                
                let reducedArray = self.reduceArray(for:waveHeights, to:30)

                // Call completion with the entire array of waveHeights
                completion(reducedArray)
                
                var sampleAtIndex = samples.item(at: index * segmentSize)
                while sampleAtIndex != nil {
                              
                  sampleAtIndex = samples.item(at: index * segmentSize)
                  let normalizedSample = CGFloat(sampleAtIndex ?? 0) * CGFloat(heightNormalizationFactor)
                    
                  let waveHeight = abs(normalizedSample)

                  waveHeights.append(waveHeight)
                  index += 1
            
                }
                
              completion(waveHeights)*/
                
               
                for index in 0..<sizeWidth {
                    let startIndex = index * segmentSize
                    let endIndex = min((index + 1) * segmentSize, samplesCount)
                    
                    // Calculate the average of the segment
                    // Cannot convert value of type '(Double) -> Double' to expected argument type '(Double, Slice<UnsafeBufferPointer<Float>>.Element) throws -> Double' (aka '(Double, Float) throws -> Double')
                    let averageSample = samples[startIndex..<endIndex].reduce(0.0) { $0 + Double($1) } / Double(segmentSize)

                    let normalizedSample = CGFloat(averageSample) * CGFloat(heightNormalizationFactor)
                    let waveHeight = abs(normalizedSample)

                    waveHeights.append(waveHeight)
                }
                
                completion(waveHeights)
            }
        }
    }
    
    func reduceArray(for array: [Double]?, to size: Int) -> [Double]? {
        guard let array = array, !array.isEmpty, size > 0 else {
            return nil
        }
        
        let ratio = Double(array.count - 1) / Double(size - 1)
        
        let reducedArray = (0..<size).map { index in
            let nearestIndex = Int(Double(index) * ratio + 0.5)
            return array[nearestIndex]
        }
        
        return reducedArray
    }
    
    func calculateWaveValue(for index : Int, in samples : UnsafeBufferPointer<Float>?, with segmentSize:Int) -> Double{
        
        let peak = samples?.item(at: index)
        
        return peak != nil ? Double(abs(peak!)) : 0.0
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
