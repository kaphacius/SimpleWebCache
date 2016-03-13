//: Playground - noun: a place where people can play

import Foundation
import UIKit

class CacheableResource<Resource: NSCoding>: NSCoding {
    var resource: Resource! = nil
    var lastModified: String! = nil
    init(lastModified: String, resource: Resource) {
        self.lastModified = lastModified
        self.resource = resource
    }

    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(resource, forKey: "resource")
        aCoder.encodeObject(lastModified, forKey: "lastModified")
    }

    @objc required init?(coder aDecoder: NSCoder) {
        if let resource = aDecoder.decodeObjectForKey("resource") as? Resource,
            let lastModified = aDecoder.decodeObjectForKey("lastModified") as? String {
                self.resource = resource
                self.lastModified = lastModified
        } else {
            return nil
        }
    }
}

class SimpleWebCache<Resource: NSCoding, Key: Hashable> {
    private let placeholderResource: Resource?
    private let fullSavePath: String?
    private lazy var fileManager: NSFileManager = {
        return NSFileManager.defaultManager()
    }()

    convenience init?(placeholderResource: Resource?, folderName: String) {
        if let cachesDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .AllDomainsMask, false).first {
            let fullPath = cachesDir + "/\(folderName)"
            self.init(placeholderResource: placeholderResource, fullSavePath: fullPath)
        } else {
            return nil
        }
    }

    required init?(placeholderResource: Resource?, fullSavePath: String) {
        self.placeholderResource = placeholderResource
        self.fullSavePath = fullSavePath
    }

    typealias Completion = (resource: Resource?) -> Void

    private var resources = Dictionary<Key, Resource>()
    private var waiting = Dictionary<Key, Completion>()

    func getResource(withKey key: Key, completion: Completion) -> Resource? {
        return nil
    }

    func saveResourceToDisk(resource: CacheableResource<Resource>, key: Key) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(resource)
    }
}

let cache = SimpleWebCache<UIImage, String>(placeholderResource: nil, folderName: "someFolder")