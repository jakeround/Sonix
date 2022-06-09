//
//  ImageCache.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 03/04/2020.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

final class ImageCache: ImageCacheType {

    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(
            countLimit: 100,
            memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    // 1st level cache, that contains encoded images
    private lazy var imageCache = NSCache<AnyObject, AnyObject>(countLimit: config.countLimit)
    // 2nd level cache, that contains decoded images
    private lazy var decodedImageCache = NSCache<AnyObject, AnyObject>(countLimit: config.memoryLimit)
    private lazy var diskImageCache = ImagePersistence()

    private let lock = NSLock()
    private let config: Config

    init(config: Config = Config.defaultConfig) { self.config = config }

    func image(for key: AnyHashable) -> Image? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decoded image in memory
        if let decodedImage = decodedImageCache.object(forKey: key as AnyObject) as? Image {
            return decodedImage
        }
        // search for image data
        if let image = imageCache.object(forKey: key as AnyObject) as? Image {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: key as AnyObject, cost: decodedImage.diskSize)
            return decodedImage
        } else if let loadedImage = diskImageCache?.fetchImage(for: key.description) {
            let decompressedImage = loadedImage.decodedImage()
//            lock.lock(); defer { lock.unlock() }
            imageCache.setObject(decompressedImage, forKey: key as AnyObject, cost: 1)
            decodedImageCache.setObject(image as AnyObject, forKey: key as AnyObject, cost: decompressedImage.diskSize)
            return loadedImage
        }
        return nil
    }

    func insertImage(_ image: Image?, for key: AnyHashable) {
        guard let image = image else { return removeImage(for: key) }
        let decompressedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(decompressedImage, forKey: key as AnyObject, cost: 1)
        decodedImageCache.setObject(image as AnyObject, forKey: key as AnyObject, cost: decompressedImage.diskSize)
        diskImageCache?.persist(image: decompressedImage, key: key.description)
    }

    func removeImage(for key: AnyHashable) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: key as AnyObject)
        decodedImageCache.removeObject(forKey: key as AnyObject)
        diskImageCache?.removeImage(for: key)
    }

    func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }

    subscript(_ key: AnyHashable) -> Image? {
        get { image(for: key) }
        set { insertImage(newValue, for: key) }
    }
}
