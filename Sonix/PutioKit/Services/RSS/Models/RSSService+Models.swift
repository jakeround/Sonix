//
//  RSSService+Models.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension RSSService { enum Model {} }

public extension RSSService.Model {

    struct Feed: Codable, Hashable {

        let id: Int
        let title: String
        let sourceURL: URL?
        let parentId: Int
        let deleteOldFiles: Bool
        let keyword: String?
        let isPaused: Bool
        let pausedAt: Date?
        let createdAt: Date?
        let updatedAt: Date?
        let startedAt: Date?

        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case sourceURL = "rss_source_url"
            case parentId = "parent_dir_id"
            case deleteOldFiles = "delete_old_files"
            case keyword
            case isPaused = "paused"
            case pausedAt = "paused_at"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case startedAt = "started_at"
        }
    }
}

public extension RSSService.Model {

    struct FeedParameters: Codable, Hashable {

        let title: String
        let sourceURL: URL
        let parentId: Int
        let deleteOldFiles: Bool
        let dontProcessTheWholeFeed: Bool
        let keywords: String
        let unwantedKeywords: String
        let paused: Bool

        init(
            title: String,
            sourceURL: URL,
            parentId: Int = 0,
            deleteOldFiles: Bool = false,
            dontProcessTheWholeFeed: Bool = true,
            keywords: [String],
            unwantedKeywords: [String],
            paused: Bool = false) {

            self.title = title
            self.sourceURL = sourceURL
            self.parentId = parentId
            self.deleteOldFiles = deleteOldFiles
            self.dontProcessTheWholeFeed = dontProcessTheWholeFeed
            self.keywords = keywords.joined(separator: ",")
            self.unwantedKeywords = unwantedKeywords.joined(separator: ",")
            self.paused = paused
        }

        private enum CodingKeys: String, CodingKey {
            case title
            case sourceURL = "rss_source_url"
            case parentId = "parent_dir_id"
            case deleteOldFiles = "delete_old_files"
            case dontProcessTheWholeFeed = "dont_process_whole_feed"
            case keywords
            case unwantedKeywords = "unwanted_keywords"
            case paused
        }
    }
}
