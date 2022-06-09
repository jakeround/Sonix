//
//  TransfersService+Model.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension TransfersService { enum Model {} }

public extension TransfersService.Model {

    struct Transfer: Codable, Hashable {

        public enum Status: String, Codable {
            case inQueue = "IN_QUEUE"
            case waiting = "WAITING"
            case preparing = "PREPARING_DOWNLOAD"
            case downloading = "DOWNLOADING"
            case completing = "COMPLETING"
            case seeding = "SEEDING"
            case completed = "COMPLETED"
            case error = "ERROR"
        }

        public enum Kind: String, Codable {
            case torrent = "TORRENT"
            case url = "URL"
            case playlist = "PLAYLIST"
            case livestream = "LIVE_STREAM"
            case notavailable = "N/A"
        }

        public let availability: Int?
        public let callbackURL: String?
        public let clientIP: String?
        public let completionPercent: Int?
        public let createdAt: Date
        public let createByTorrent: Bool?
        public let ratio: Float?
        public let downSpeed: Int?
        public let downloadId: Int?
        public let dataDownloaded: Int?
        public let errorMessage: String?
        public let estimatedTime: Int?
        public let fileId: Int?
        public let finishedAt: Date?
        public let hash: String?
        public let id: Int
        public let isPrivate: Bool
        public let links: [String]?
        public let name: String
        public let connectedPeers: Int?
        public let peersGettingFromPutIO: Int?
        public let peersSendingToPutIO: Int?
        public let percentDone: Int?
        public let parentFolder: Int
        public let secondsSeeding: Int?
        public let simulated: Bool?
        public let size: Int?
        public let source: String?
        public let startedAt: Date?
        public let status: Status
        public let subscriptionId: Int?
        public let torrentLink: String?
        public let tracker: String?
        public let trackerMessage: String?
        public let kind: Kind
        public let dataUploaded: Int?
        public let upSpeed: Int?

        private enum CodingKeys: String, CodingKey {
            case availability = "availability"
            case callbackURL = "callback_url"
            case clientIP = "client_ip"
            case completionPercent = "completion_percent"
            case createdAt = "created_at"
            case createByTorrent = "created_torrent"
            case ratio = "current_ratio"
            case downSpeed = "down_speed"
            case downloadId = "download_id"
            case dataDownloaded = "downloaded"
            case errorMessage = "error_message"
            case estimatedTime = "estimated_time"
            case fileId = "file_id"
            case finishedAt = "finished_at"
            case hash
            case id = "id"
            case isPrivate = "is_private"
            case links
            case name
            case connectedPeers = "peers_connected"
            case peersGettingFromPutIO = "peers_getting_from_us"
            case peersSendingToPutIO = "peers_sending_to_us"
            case percentDone = "percent_done"
            case parentFolder = "save_parent_id"
            case secondsSeeding = "seconds_seeding"
            case simulated
            case size = "size"
            case source = "source"
            case startedAt = "started_at"
            case status = "status"
            case subscriptionId = "subscription_id"
            case torrentLink = "torrent_link"
            case tracker
            case trackerMessage = "tracker_message"
            case kind = "type"
            case upSpeed = "up_speed"
            case dataUploaded = "uploaded"
        }
    }
}

public extension TransfersService.Model {

    struct AddParameters: Codable, Hashable {

        let url: String
        let parentId: Int?
        let callbackURL: URL?

        private enum CodingKeys: String, CodingKey {
            case url
            case parentId = "parent_id"
            case callbackURL = "callback_url"
        }
    }
}
