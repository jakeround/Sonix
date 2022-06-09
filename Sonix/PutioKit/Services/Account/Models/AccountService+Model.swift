//
//  AccountService+Model.swift
//  PutioKit
//
//  Created by Ilias Pavlidakis on 08/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public extension AccountService { enum Model {} }

public extension AccountService.Model {

    struct Info: Codable, Hashable {

        let id: Int
        let username: String
        let mail: String

        private enum CodingKeys: String, CodingKey {
            case id = "user_id"
            case username
            case mail
        }
    }
}

public extension AccountService.Model {

    struct Settings: Codable, Hashable {

        enum SortOder: String, Codable {
            case nameAscending = "NAME_ASC"
            case nameDescending = "NAME_DESC"
            case sizeAscending = "SIZE_ASC"
            case sizeDescending = "SIZE_DESC"
            case dateAscending  = "DATE_ASC"
            case dateDescending = "DATE_DESC"
            case modifierAscending  = "MODIFIED_ASC"
            case modifierDescending = "MODIFIED_DESC"
            case typeAscending  = "TYPE_ASC"
            case typeDescending = "TYPE_DESC"
            case watchAscending  = "WATCH_ASC"
            case watchDescending = "WATCH_DESC"
        }

        enum TransferSortOder: String, Codable {
            case nameAscending = "NAME_ASC"
            case nameDescending = "NAME_DESC"
            case dateAddedAscending  = "DATEADDED_ASC"
            case dateAddedDescending = "DATEADDED_DESC"
            case dataDownloadedAscending  = "DATADOWNLOADED_ASC"
            case dataDownloadedDescending = "DATADOWNLOADED_DESC"
            case dataUploadedAscending  = "DATAUPLOADED_ASC"
            case dataUploadedDescending = "DATAUPLOADED_DESC"
            case statusAscending  = "STATUS_ASC"
            case statusDescending = "STATUS_DESC"
            case etaAscending  = "ETA_ASC"
            case etaDescending = "ETA_DESC"
            case peerCountAscending  = "PEER_ASC"
            case peerCountDescending = "PEER_DESC"
            case ratioAscending  = "RATIO_ASC"
            case ratioDescending = "RATIO_DESC"
        }

        let defaultDownloadFolder: Int
        let isInvisible: Bool
        let subtitleLanguages: [String]
        let defaultSubtitleLanguage: String?

        // MARK: - Not mentioned in the public API
        let isBeta: Bool?
        let callbackURL: String?
        let hasDarkThemeEnabled: Bool?
        let hasFluidLayoutEnabled: Bool?
        let hasHistoryEnabled: Bool?
        let locale: String?
        let hasLoginEmailsEnabled: Bool?
        let hasPlayNextEpisodeEnabled: Bool?
        let pushoverToken: String?
        let defaultSortOrder: SortOder?
        let startFrom: Bool?
        let hasTheaterModeEnabled: Bool?
        let transferSortOder: TransferSortOder?
        let hasTranshEnabled: Bool?
        let tunnelRouteName: String?
        let hasPrivateDownloadIPUsageEnabled: Bool?

        init(defaultDownloadFolder: Int,
             isInvisible: Bool,
             subtitleLanguages: [String],
             defaultSubtitleLanguage: String? = nil,
             isBeta: Bool? = nil,
             callbackURL: String? = nil,
             hasDarkThemeEnabled: Bool? = nil,
             hasFluidLayoutEnabled: Bool? = nil,
             hasHistoryEnabled: Bool? = nil,
             locale: String? = nil,
             hasLoginEmailsEnabled: Bool? = nil,
             hasPlayNextEpisodeEnabled: Bool? = nil,
             pushoverToken: String? = nil,
             defaultSortOrder: SortOder? = nil,
             startFrom: Bool? = nil,
             hasTheaterModeEnabled: Bool? = nil,
             transferSortOder: TransferSortOder? = nil,
             hasTranshEnabled: Bool? = nil,
             tunnelRouteName: String? = nil,
             hasPrivateDownloadIPUsageEnabled: Bool? = nil
        ) {
            self.defaultDownloadFolder = defaultDownloadFolder
            self.isInvisible = isInvisible
            self.subtitleLanguages = subtitleLanguages
            self.defaultSubtitleLanguage = defaultSubtitleLanguage
            self.isBeta = isBeta
            self.callbackURL = callbackURL
            self.hasDarkThemeEnabled = hasDarkThemeEnabled
            self.hasFluidLayoutEnabled = hasFluidLayoutEnabled
            self.hasHistoryEnabled = hasHistoryEnabled
            self.locale = locale
            self.hasLoginEmailsEnabled = hasLoginEmailsEnabled
            self.hasPlayNextEpisodeEnabled = hasPlayNextEpisodeEnabled
            self.pushoverToken = pushoverToken
            self.defaultSortOrder = defaultSortOrder
            self.startFrom = startFrom
            self.hasTheaterModeEnabled = hasTheaterModeEnabled
            self.transferSortOder = transferSortOder
            self.hasTranshEnabled = hasTranshEnabled
            self.tunnelRouteName = tunnelRouteName
            self.hasPrivateDownloadIPUsageEnabled = hasPrivateDownloadIPUsageEnabled
        }

        private enum CodingKeys: String, CodingKey {
            case defaultDownloadFolder = "default_download_folder"
            case isInvisible = "is_invisible"
            case subtitleLanguages = "subtitle_languages"
            case defaultSubtitleLanguage = "default_subtitle_language"
            case isBeta = "beta_user"
            case callbackURL = "callback_url"
            case hasDarkThemeEnabled = "dark_theme"
            case hasFluidLayoutEnabled = "fluid_layout"
            case hasHistoryEnabled = "history_enabled"
            case locale = "locale"
            case hasLoginEmailsEnabled = "login_mails_enabled"
            case hasPlayNextEpisodeEnabled = "next_episode"
            case pushoverToken = "pushover_token"
            case defaultSortOrder = "sort_by"
            case startFrom = "start_from"
            case hasTheaterModeEnabled = "theater_mode"
            case transferSortOder = "transfer_sort_by"
            case hasTranshEnabled = "trash_enabled"
            case tunnelRouteName = "tunnel_route_name"
            case hasPrivateDownloadIPUsageEnabled = "use_private_download_ip"
        }
    }
}
