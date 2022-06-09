//
//  NSImage+Decoded.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 03/04/2020.
//

import Foundation

#if os(macOS)

import AppKit
import CoreGraphics

extension NSImage {

    var cgImage: CGImage? {
        get {
            guard
                let imageData: NSData = self.tiffRepresentation as NSData?,
                let source = CGImageSourceCreateWithData(imageData as CFData, nil),
                let maskRef = CGImageSourceCreateImageAtIndex(source, 0, nil)
            else { return nil }
            return maskRef
        }
    }

    func decodedImage() -> NSImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return NSImage(cgImage: decodedImage, size: size)
    }

    func encodedImage() -> Data? { tiffRepresentation }

    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }

    static func from(data: Data) -> NSImage? {
        NSImage(data: data)
    }
}

#endif
