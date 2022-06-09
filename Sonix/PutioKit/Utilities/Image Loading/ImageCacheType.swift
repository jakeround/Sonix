//
//  ImageCacheType.swift
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

protocol ImageCacheType: class {

    #if os(macOS)
    typealias Image = NSImage
    #else
    typealias Image = UIImage
    #endif

    // Returns the image associated with a given url
    func image(for key: AnyHashable) -> Image?
    // Inserts the image of the specified url in the cache
    func insertImage(_ image: Image?, for key: AnyHashable)
    // Removes the image of the specified url in the cache
    func removeImage(for key: AnyHashable)
    // Removes all images from the cache
    func removeAllImages()
    // Accesses the value associated with the given key for reading and writing
    subscript(_ key: AnyHashable) -> Image? { get set }
}
