//
//  CocoLocoMixerApp.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 28/01/2024.
//

import SwiftUI

@main
struct CocoLocoMixerApp: App {
    @StateObject private var viewModel = AppViewModel()
    var body: some Scene {
            WindowGroup {
                NavigationView {
                    Group {
                        if viewModel.isLoading {
                            // Loading Screen
                            LoadingView(progress: viewModel.progress)
                                .onAppear {
                                    viewModel.loadData()
                                }
                        } else {
                            // Main Content
                            HomeView()
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
        }
}

class AppViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var progress: Double = 0.0

    func loadData() {
        // Simulate loading time (replace this with your actual loading logic)
        let totalSteps = 3

        // Asynchronous cleanup
        DispatchQueue.global(qos: .utility).async {
            self.cleanUpTemporaryFiles()
        }

        // Simulate loading steps
        for step in 1...totalSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step)) {
                self.progress = Double(step) / Double(totalSteps)
            }
        }

        // Indicate loading is complete
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalSteps)) {
            self.isLoading = false
        }
    }

    private func cleanUpTemporaryFiles() {
        let tempDirectoryURL = FileManager.default.temporaryDirectory

        do {
            // Get the contents of the temporary directory
            let contents = try FileManager.default.contentsOfDirectory(atPath: tempDirectoryURL.path)

            // Remove each file in the temporary directory
            for file in contents {
                let fileURL = tempDirectoryURL.appendingPathComponent(file)
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print("Error cleaning up temporary files:", error)
        }
    }
}


