//
//  Movies.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2022.
//

import SwiftUI
//MARK: - BASE MODEL

struct ApiResponse : Decodable {
    let status : String?
    let statusMessage : String?
    let data : DataYTS?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case statusMessage = "status_message"
        case data = "data"
    }
}

//MARK: - DATA

struct DataYTS : Decodable {
    let movieCount : Int?
    let limit : Int?
    let pageNumber : Int?
    let movies : [Movies]?

    enum CodingKeys: String, CodingKey {

        case movieCount = "movie_count"
        case limit = "limit"
        case pageNumber = "page_number"
        case movies = "movies"
    }
}

//MARK: - MOVIES
struct Movies : Decodable, Identifiable {
    let id : Int?
    let url : String?
    let imdbCode : String?
    let title : String?
    let titleEnglish : String?
    let titleLong : String?
    let slug : String?
    let year : Int
    let rating : Float?
    let runtime : Int?
    let genres : [String]?
    let summary : String?
    let descriptionFull : String?
    let synopsis : String?
    let ytTrailerCode : String?
    let language : String?
    let mpaRating : String?
    let backgroundImage : String?
    let backgroundImageOriginal : String?
    let smallCoverImage : String?
    let mediumCoverImage : String?
    let largeCoverImage : String?
    let state : String?
    let torrents : [Torrents]?
    let dateUploaded : String?
    let dateUploadedUnix : Int?
    
    var duration: String {
           guard let runtime = self.runtime, runtime > 0 else {
               return ""
           }
        return Movies.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? ""
       }

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case url = "url"
        case imdbCode = "imdb_code"
        case title = "title"
        case titleEnglish = "title_english"
        case titleLong = "title_long"
        case slug = "slug"
        case year = "year"
        case rating = "rating"
        case runtime = "runtime"
        case genres = "genres"
        case summary = "summary"
        case descriptionFull = "description_full"
        case synopsis = "synopsis"
        case ytTrailerCode = "yt_trailer_code"
        case language = "language"
        case mpaRating = "mpa_rating"
        case backgroundImage = "background_image"
        case backgroundImageOriginal = "background_image_original"
        case smallCoverImage = "small_cover_image"
        case mediumCoverImage = "medium_cover_image"
        case largeCoverImage = "large_cover_image"
        case state = "state"
        case torrents = "torrents"
        case dateUploaded = "date_uploaded"
        case dateUploadedUnix = "date_uploaded_unix"
    }
    
    
    static private let durationFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .abbreviated
            formatter.zeroFormattingBehavior = .pad
            return formatter
        }()
}




//MARK: - TORRENTS

struct Torrents : Decodable, Hashable, Identifiable {
    var id = UUID()
    let url : String?
    let hash : String?
    let quality : String?
    let type : String?
    let seeds : Float?
    let peers : Float?
    let size : String?
    let sizeBytes : Float?
    let dateUploaded : String?
    let dateUploadedUnix : Float?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case hash = "hash"
        case quality = "quality"
        case type = "type"
        case seeds = "seeds"
        case peers = "peers"
        case size = "size"
        case sizeBytes = "size_bytes"
        case dateUploaded = "date_uploaded"
        case dateUploadedUnix = "date_uploaded_unix"
    }
    
    
}


