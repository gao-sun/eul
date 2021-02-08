//
//  AutoUpdate.swift
//  eul
//
//  Created by Gao Sun on 2021/2/8.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Foundation

enum AutoUpdate {
    static let fileManager = FileManager.default
    static let appUrl = fileManager.temporaryDirectory.appendingPathComponent("eul.app")
    static let zipUrl = fileManager.temporaryDirectory.appendingPathComponent("eul.app.zip")

    static func run() {
        downloadLatest {
            if $0 {
                unzip {
                    print("???", $0)
                }
            }
        }
    }

    static func downloadLatest(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://github.com/gao-sun/eul/releases/latest/download/eul.app.zip") else {
            completion(false)
            return
        }

        let session = URLSession(configuration: .ephemeral)
        let task = session.downloadTask(with: url) { url, _, error in
            if let error = error {
                print("⚠️ error when downloading latest zip file", error.localizedDescription)
                completion(false)
                return
            }

            guard let url = url else {
                print("⚠️ no url")
                completion(false)
                return
            }

            do {
                Print("Checking if zip file exists")
                if fileManager.fileExists(atPath: zipUrl.path) {
                    Print("Removing existing zip file")
                    try fileManager.removeItem(at: zipUrl)
                }

                Print("Renaming file")
                try fileManager.moveItem(at: url, to: zipUrl)
            } catch {
                print("⚠️ error when setting up the new app", error.localizedDescription)
                completion(false)
                return
            }

            completion(true)
        }

        task.resume()
    }

    static func unzip(completion: @escaping (Bool) -> Void) {
        do {
            Print("Checking if app directory exists")
            if fileManager.fileExists(atPath: appUrl.path) {
                Print("Removing existing app directory")
                try fileManager.removeItem(at: appUrl)
            }

            guard shell("unzip -oq \(zipUrl.path) -d \(fileManager.temporaryDirectory.path)") != nil else {
                completion(false)
                return
            }
        } catch {
            print("⚠️ error when unzipping the new app", error.localizedDescription)
            completion(false)
            return
        }

        completion(true)
    }
}
