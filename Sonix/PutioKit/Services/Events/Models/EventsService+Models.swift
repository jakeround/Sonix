//
//  EventsService+Models.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension EventsService { enum Model {} }

public extension EventsService.Model {

    struct Event: Codable, Hashable {

        public enum Kind: String, Codable {
            case upload
            case zipCreated = "zip_created"
            case transferCompleted = "transfer_completed"
            case fileShared = "file_shared"
            case transferFromRSSError = "transfer_from_rss_error"
            case transferError = "transfer_error"
            case transferCallbackError = "transfer_callback_error"
            case fileFromRSSDeletedForSpace = "file_from_rss_deleted_for_space"
            case privateTorrentPin = "private_torrent_pin"
            case rssFilterPaused = "rss_filter_paused"
        }

        let id: Int
        let createdAt: Date
        let kind: Kind

        private enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case kind = "type"
        }
    }
}
