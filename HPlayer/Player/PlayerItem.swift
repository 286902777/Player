//
//  PlayerItem.swift
//  HPlayer
//
//  Created by HF on 2023/12/21.
//


import Foundation
import AVFoundation

class PlayerResource {
    let name: String
    let cover: URL?
    var subtitle: HPSubtitles?
    let definitions: [HPPlayerResourceConfig]
    
    convenience init(url: URL, name: String = "", cover: URL? = nil, subtitle: URL? = nil) {
        let definition = HPPlayerResourceConfig(url: url, definition: "")
        
        var subtitles: HPSubtitles? = nil
        if let subtitle = subtitle {
            subtitles = HPSubtitles(url: subtitle)
        }
        
        self.init(name: name, definitions: [definition], cover: cover, subtitles: subtitles)
    }

    init(name: String = "", definitions: [HPPlayerResourceConfig], cover: URL? = nil, subtitles: HPSubtitles? = nil) {
        self.name        = name
        self.cover       = cover
        self.subtitle    = subtitles
        self.definitions = definitions
    }
}

class HPPlayerResourceConfig {
    let url: URL
    let definition: String
    
    var options: [String : Any]?
    
    var avURLAsset: AVURLAsset {
        get {
            return AVURLAsset(url: url)
        }
    }
    
    init(url: URL, definition: String, options: [String : Any]? = nil) {
        self.url        = url
        self.definition = definition
        self.options    = options
    }
}
