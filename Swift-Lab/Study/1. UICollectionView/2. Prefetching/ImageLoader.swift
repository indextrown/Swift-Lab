//
//  ImageLoader.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/20/26.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    private var runningTasks: [URL: URLSessionDataTask] = [:]
    private var pendingCompletions: [URL: [(UIImage?) -> Void]] = [:]
    private let stateQueue = DispatchQueue(label: "com.swift-lab.image-loader.state")
    
    private init() {}
    
    func loadImage(
        from url: URL,
        completion: @escaping (UIImage?) -> Void
    ) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }

        stateQueue.async { [weak self] in
            guard let self else { return }
            self.pendingCompletions[url, default: []].append(completion)
            self.startRequestIfNeeded(for: url)
        }
    }
    
    func prefetchImage(from url: URL) {
        if cache.object(forKey: url as NSURL) != nil { return }
        
        stateQueue.async { [weak self] in
            guard let self else { return }
            self.startRequestIfNeeded(for: url)
        }
    }
    
    func cancelPrefetch(for url: URL) {
        stateQueue.async { [weak self] in
            guard let self else { return }
            self.runningTasks[url]?.cancel()
            self.runningTasks[url] = nil
        }
    }
    
    private func startRequestIfNeeded(for url: URL) {
        if runningTasks[url] != nil { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self else { return }
            let image = data.flatMap(UIImage.init(data:))
            
            self.stateQueue.async {
                self.runningTasks[url] = nil
                let completions = self.pendingCompletions.removeValue(forKey: url) ?? []
                
                if let image {
                    self.cache.setObject(image, forKey: url as NSURL)
                }
                
                DispatchQueue.main.async {
                    completions.forEach { $0(image) }
                }
            }
        }
        
        runningTasks[url] = task
        task.resume()
    }
}
