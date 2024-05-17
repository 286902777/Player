//
//  HPCaptionManager.swift
//  HPPlixor
//
//  Created by HF on 2024/4/11.
//

import Foundation

enum HPCaptionStatus: Int {
    case none = -1
    case waiting
    case downloading
    case paused
    case failed
    case finished
    case networkError
}

class HPCaptionDownload: NSObject {
    var url: String
    var id: String
    var state: HPCaptionStatus = .waiting
    var progress: Float = 0.0
    
    var task: URLSessionDownloadTask?
    var resumeData: Data?
    
    init(url: String, id: String) {
        self.url = url
        self.id = id
    }
    
    var done: Bool {
        return self.progress >= 1
    }
}

class HPCaptionManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    static let share = HPCaptionManager()
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    var task: URLSessionDataTask?
    var model: AVModel = AVModel()
    private(set) var downloads: [HPCaptionDownload] = []
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    var fileManager: FileManager = .default
    
    override init() {
        
        super.init()
        
        _ = self.downloadsSession
        
    }
    
    /// 加入下载队列
    private func addDownload(_ download: HPCaptionDownload, resume: Bool = true) {
        if resume {
            download.task?.resume()
        }
        download.state = .downloading
        self.downloads.append(download)
    }
    
    /// 获取下载模型
    func getDownload(url: String?) -> HPCaptionDownload? {
        if let video = self.downloads.first(where: { $0.url == url }) {
            return video
        }
        
        return nil
    }
    
    func getDownload(id: String) -> HPCaptionDownload? {
        if let video = self.downloads.first(where: { $0.id == id }) {
            return video
        }
        
        return nil
    }
    
    func getDownload(task: URLSessionDownloadTask) -> HPCaptionDownload? {
        if let video = self.downloads.first(where: { $0.task == task }) {
            return video
        }
        return nil
    }
    
    // MARK: - Download
    func downLoadCaptions(_ model: AVModel) {
        self.model = model
        for (index, item) in model.captions.enumerated() {
            let captionId = "\(Int(Date().timeIntervalSince1970 * 1000) + index)"
            item.captionId = captionId
            self.startDownload(item)
        }
    }
    /// 开始下载
    func startDownload(_ caption: AVCaption) {
        if caption.s3_address.count > 0, let url = URL(string: caption.s3_address) {
            let download = HPCaptionDownload(url: caption.s3_address, id: caption.captionId)
            download.task = self.downloadsSession.downloadTask(with: url)
            self.addDownload(download)
        }
    }
    
    // MARK: - URLSessionDownloadDelegate
    /// 下载完成
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileManager = self.fileManager
        let download = self.getDownload(task: downloadTask)
        if let captionId = download?.id {
            var srcsURL = URL(fileURLWithPath: path)
            srcsURL.appendPathComponent("caption")
            srcsURL.appendPathComponent("\(captionId).srt")
            do {
                try fileManager.createDirectory(at: srcsURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("file error")
            }
            
            //Removing the file at the path, just in case one exists
            do {
                try fileManager.removeItem(at: srcsURL)
            } catch {
                print("file error")
            }
            
            //Moving the downloaded file to the new location
            do {
                try fileManager.moveItem(at: location, to: srcsURL)
            } catch _ as NSError {
                print("file error")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.addLocalData(localPath: srcsURL, captionId: captionId)
            }
        }
    }
    /// 下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("downProgress: \(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error as? NSError, error.code != -999 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let downloadTask = task as? URLSessionDownloadTask, let _ = self.getDownload(task: downloadTask) {
                    
                }
            }
        }
    }
    
    func addLocalData(localPath: URL, captionId: String) {
//        let manager = FileManager()
//        var url = URL(fileURLWithPath: "\(self.path)/caption")
//        url.appendPathComponent(captionId)
//        do {
//            try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
////            try manager.unzipItem(at: localPath, to: url)
//        } catch {
////            print("ZIP failed with error:\(error)")
//        }
//        let local = self.captionAddLocalPath(id: captionId)
        if let c = self.model.captions.first(where: {$0.captionId == captionId}) {
            c.local_address = localPath.absoluteString
            DBManager.share.updateCaptionsData(self.model)
            NotificationCenter.default.post(name: HPKey.Noti_CcRefresh, object: nil)
        }
    }
    
    func captionAddLocalPath(id: String) -> String {
        let path = "\(path)/caption/\(id)"
        if let file = FileManager.default.subpaths(atPath: path) {
            for p in file {
                let localPath = "/caption/\(id)".appending("/\(p)")
                return localPath
            }
        }
        return ""
    }
}

