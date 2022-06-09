//
//  ImageLoader.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 03/04/2020.
//

import Foundation
import Combine
#if os(macOS)
import AppKit
#else
import UIKit
#endif

final class ImageLoader {

    static let shared = ImageLoader()

    private let cache: ImageCacheType
    private lazy var backgroundQueue = OperationQueue(maxConcurrentOperationCount: 5)

    init(cache: ImageCacheType = ImageCache()) { self.cache = cache }

    func loadImage(from url: URL) -> AnyPublisher<ImageCacheType.Image?, Never> {

        let key = url.lastPathComponent

        guard let image = cache[key] else {
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { ImageCacheType.Image(data: $0.data) }
                .catch { error in return Just(nil) }
                .handleEvents(receiveOutput: {[weak self] image in
                    guard let image = image else { return }
                    self?.cache[key] = image
                })
                .print("Image loading \(url):")
                .subscribe(on: backgroundQueue)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }

        return Just(image).eraseToAnyPublisher()
    }

    func image(for key: AnyHashable) -> ImageCacheType.Image? {
        return cache[key]
    }

    func cacheExists(for key: AnyHashable) -> Bool {

        return cache[key] != nil
    }
}
