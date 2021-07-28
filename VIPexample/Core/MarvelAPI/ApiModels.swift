// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let murvel = try? newJSONDecoder().decode(Murvel.self, from: jsonData)

import Foundation
import UIKit.UIImage

// MARK: - Murvel
struct Murvel: Codable {
    var code: Int?
    var status: String?
    var copyright: String?
    var attributionText: String?
    var attributionHtml: String?
    var etag: String?
    var data: DataClass?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case copyright = "copyright"
        case attributionText = "attributionText"
        case attributionHtml = "attributionHTML"
        case etag = "etag"
        case data = "data"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [MurvelResult]?

    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case limit = "limit"
        case total = "total"
        case count = "count"
        case results = "results"
    }
}

// MARK: - Result
struct MurvelResult: Codable, Hashable {
    
    var id: Int?
    var name: String?
    var resultDescription: String?
    var modified: String?
    var thumbnail: MurvelThumbnail?
    var resourceUri: String?
    var comics: Comics?
    var series: Comics?
    var stories: MurvelStories?
    var events: Comics?
    var urls: [MurvelURLElement]?
    var image: UIImage?

    static func == (lhs: MurvelResult, rhs: MurvelResult) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.modified == rhs.modified &&
            lhs.resourceUri == rhs.resourceUri
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case resultDescription = "description"
        case modified = "modified"
        case thumbnail = "thumbnail"
        case resourceUri = "resourceURI"
        case comics = "comics"
        case series = "series"
        case stories = "stories"
        case events = "events"
        case urls = "urls"
    }
}

// MARK: - Comics
struct Comics: Codable, Hashable {
    
    var available: Int?
    var collectionUri: String?
    var items: [ComicsItem]?
    var returned: Int?

    static func == (lhs: Comics, rhs: Comics) -> Bool {
        lhs.collectionUri == rhs.collectionUri && lhs.items == rhs.items
    }

    enum CodingKeys: String, CodingKey {
        case available = "available"
        case collectionUri = "collectionURI"
        case items = "items"
        case returned = "returned"
    }
}

// MARK: - ComicsItem
struct ComicsItem: Codable, Hashable {
    var resourceUri: String?
    var name: String?
    
    static func == (lhs: ComicsItem, rhs: ComicsItem) -> Bool {
        lhs.resourceUri == rhs.resourceUri && lhs.name == rhs.name
    }

    enum CodingKeys: String, CodingKey {
        case resourceUri = "resourceURI"
        case name = "name"
    }
}

// MARK: - Stories
struct MurvelStories: Codable, Hashable {
    
    var available: Int?
    var collectionUri: String?
    var items: [StoriesItem]?
    var returned: Int?

    static func == (lhs: MurvelStories, rhs: MurvelStories) -> Bool {
        return lhs.available == rhs.available && lhs.collectionUri == rhs.collectionUri && lhs.returned == rhs.returned
    }

    enum CodingKeys: String, CodingKey {
        case available = "available"
        case collectionUri = "collectionURI"
        case items = "items"
        case returned = "returned"
    }
}

// MARK: - StoriesItem
struct StoriesItem: Codable, Hashable {
    var resourceUri: String?
    var name: String?
    var type: String?

    enum CodingKeys: String, CodingKey {
        case resourceUri = "resourceURI"
        case name = "name"
        case type = "type"
    }
}

// MARK: - Thumbnail
struct MurvelThumbnail: Codable, Hashable {
    var path: String?
    var thumbnailExtension: String?

    static func == (lhs: MurvelThumbnail, rhs: MurvelThumbnail) -> Bool {
        return lhs.path == rhs.path && lhs.thumbnailExtension == rhs.thumbnailExtension
    }
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct MurvelURLElement: Codable, Hashable {
    var type: String?
    var url: String?

    static func == (lhs: MurvelURLElement, rhs: MurvelURLElement) -> Bool {
        return lhs.type == rhs.type && lhs.url == rhs.url
    }
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case url = "url"
    }
}
