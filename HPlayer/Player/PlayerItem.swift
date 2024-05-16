//
//  PlayerItem.swift
//  HPlayer
//
//  Created by HF on 2024/4/23.
//


import Foundation
import AVFoundation

class PlayerResource {
    let name: String
    let cover: URL?
    var subtitle: HPSubtitles?
    let config: [HPPlayerResourceConfig]
    
    convenience init(url: URL, name: String = "", cover: URL? = nil, subtitle: URL? = nil) {
        let cfg = HPPlayerResourceConfig(url: url, definition: "")
        
        var s: HPSubtitles? = nil
        if let subtitle = subtitle {
            s = HPSubtitles(url: subtitle)
        }
        self.init(name: name, config: [cfg], cover: cover, subtitles: s)
    }

    init(name: String = "", config: [HPPlayerResourceConfig], cover: URL? = nil, subtitles: HPSubtitles? = nil) {
        self.name        = name
        self.cover       = cover
        self.subtitle    = subtitles
        self.config = config
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
