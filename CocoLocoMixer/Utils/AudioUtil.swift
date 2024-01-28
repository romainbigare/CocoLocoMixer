//
//  AudioUtil.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 31/01/2024.
//

import Foundation
import AVFoundation

func readBuffer(_ audioUrl: URL,completion:@escaping (_ wave:UnsafeBufferPointer<Float>?)->Void)  {
    DispatchQueue.global(qos: .utility).async {
        guard let file = try? AVAudioFile(forReading: audioUrl) else {
            completion(nil)
            return
        }
        let audioFormat = file.processingFormat
        let audioFrameCount = UInt32(file.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
        else { return completion(UnsafeBufferPointer<Float>(_empty: ())) }
        do {
            try file.read(into: buffer)
        } catch {
            print(error)
        }
        
        let floatArray = UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength))
        
        DispatchQueue.main.sync {
            completion(floatArray)
        }
    }
}

extension UnsafeBufferPointer {
    func item(at index: Int) -> Element? {
        if index >= self.count {
            return nil
        }
        
        return self[index]
    }
}
