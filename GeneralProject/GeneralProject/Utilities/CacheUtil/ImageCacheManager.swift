import Foundation
import UIKit

final public class ImageCacheManager {

    public static let shared = ImageCacheManager()
    fileprivate var imageCache = [String: [ImageCacheKey: Any]]()
    let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!

    func cleanStringFunction(_ inputString: String) -> String {
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_-+=~`[{]}\\|;:'\",<>?/")
        let cleanedString = inputString.components(separatedBy: specialCharacterSet).joined(separator: "")
        return cleanedString
    }

    func removeFromLocalDirAndCache(_ type: ClearCacheType,
                                    _ parameter: String = "",
                                    completion: @escaping (_ isCleared: Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let fileManager = FileManager.default
            let documentDirectoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            guard let fileURLs = try? fileManager.contentsOfDirectory(at: documentDirectoryURL,
                                                                      includingPropertiesForKeys: nil,
                                                                      options: []) else { return }
            let currentDate = Date()
            let oneMonth: TimeInterval = 30 * 24 * 60 * 60
            var removedItemCount = 0
            for fileURL in fileURLs {
                do {
                    let fileAttributes = try fileManager.attributesOfItem(atPath: fileURL.path)
                    let modificationDate = fileAttributes[.modificationDate] as? Date
                    if let modificationDate = modificationDate,
                       let fileData = try? Data(contentsOf: fileURL),
                       let _ = UIImage(data: fileData) {
                        switch type {
                        case .expired:
                            if currentDate.timeIntervalSince(modificationDate) > oneMonth {
                                try fileManager.removeItem(at: fileURL)
                            }
                        case .spontaneously:
                            try fileManager.removeItem(at: fileURL)
                        case .particularFile: // parameter should be cleaned string
                            if fileURL.absoluteString.contains(parameter) {
                                try fileManager.removeItem(at: fileURL)
                            }
                        }
                        self.removeFromCache(dirURL: fileURL.absoluteString)
                    }
                    removedItemCount += 1
                } catch {
                    print("Error while checking file: \(fileURL.lastPathComponent) - \(error.localizedDescription)")
                }
            }

            if removedItemCount == fileURLs.count {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    fileprivate func removeFromCache(dirURL: String) {
        DispatchQueue.main.async {
            for (key, _) in self.imageCache {
                if dirURL.contains(self.cleanStringFunction(key)) {
                    self.imageCache.removeValue(forKey: key)
                }
            }
        }
    }

    func calculatedCacheSize(completion: @escaping (_ cacheSize: Int, _ cacheSizeValue: String) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let fileManager = FileManager.default
            let documentDirectoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            guard let fileURLs = try? fileManager.contentsOfDirectory(at: documentDirectoryURL,
                                                                      includingPropertiesForKeys: nil,
                                                                      options: []) else { return }
            var cacheSize = Int()
            for fileURL in fileURLs {
                do {
                    let fileAttributes = try fileManager.attributesOfItem(atPath: fileURL.path)
                    if
                        let fileData = try? Data(contentsOf: fileURL),
                        let _ = UIImage(data: fileData),
                        let size = fileAttributes[FileAttributeKey.size] as? Int {
                        cacheSize += size
                    }
                } catch {
                    print("Error while checking file: \(fileURL.lastPathComponent) - \(error.localizedDescription)")
                }
            }

            let size = ByteCountFormatter().string(fromByteCount: Int64(cacheSize))
            let cacheSizeValue = "Cache Size: \(size)"
            completion(cacheSize, cacheSizeValue)
        }
    }

    func updateImageCache(key: String) {
        if let image = imageCacheEntryForKey(key)[.image] as? UIImage {
            var imageCacheEntry = imageCacheEntryForKey(key)
            imageCacheEntry[.image] = image
            setImageCacheEntry(imageCacheEntry, key: key)
            if let observerMapping = imageCacheEntry[.observerMapping] as? [NSObject: Int] {
                for (observer, initialIndexIdentifier) in observerMapping {
                    switch observer {
                    case let imageView as UIImageView: loadObserver(imageView,
                                                                    image: image,
                                                                    initialIndexIdentifier: initialIndexIdentifier)
                    default: break
                    }
                }
                removeImageCacheObserversForKey(key)
            }
        }
    }

    fileprivate func imageCacheEntryForKey(_ key: String) -> [ImageCacheKey: Any] {
        if let imageCacheEntry = self.imageCache[key] {
            return imageCacheEntry
        } else {
            let imageCacheEntry: [ImageCacheKey: Any] = [.isDownloading: false, .observerMapping: [NSObject: Int]()]
            self.imageCache[key] = imageCacheEntry
            return imageCacheEntry
        }
    }

    fileprivate func setImageCacheEntry(_ imageCacheEntry: [ImageCacheKey: Any], key: String) {
        DispatchQueue.main.async {
            self.imageCache[key] = imageCacheEntry
        }
    }

    internal func isDownloadingFromURL(_ urlString: String) -> Bool {
        let isDownloading = imageCacheEntryForKey(urlString)[.isDownloading] as? Bool
        return isDownloading ?? false
    }

    internal func setIsDownloadingFromURL(_ isDownloading: Bool, urlString: String) {
        var imageCacheEntry = imageCacheEntryForKey(urlString)
        imageCacheEntry[.isDownloading] = isDownloading
        setImageCacheEntry(imageCacheEntry, key: urlString)
    }

    internal func addImageCacheObserver(_ observer: NSObject, initialIndexIdentifier: Int, key: String) {
        var imageCacheEntry = imageCacheEntryForKey(key)
        if var observerMapping = imageCacheEntry[.observerMapping] as? [NSObject: Int] {
            observerMapping[observer] = initialIndexIdentifier
            imageCacheEntry[.observerMapping] = observerMapping
            setImageCacheEntry(imageCacheEntry, key: key)
        }
    }

    internal func removeImageCacheObserversForKey(_ key: String) {
        var imageCacheEntry = imageCacheEntryForKey(key)
        if var observerMapping = imageCacheEntry[.observerMapping] as? [NSObject: Int] {
            observerMapping.removeAll(keepingCapacity: false)
            imageCacheEntry[.observerMapping] = observerMapping
            setImageCacheEntry(imageCacheEntry, key: key)
        }
    }

    internal func loadObserver(_ imageView: UIImageView, image: UIImage, initialIndexIdentifier: Int) {
        let success = initialIndexIdentifier == imageView.indexPathIdentifier
        if success {
            DispatchQueue.main.async {
                UIView.transition(with: imageView,
                                  duration: 0.1,
                                  options: .transitionCrossDissolve,
                                  animations: { imageView.image = image })
            }
        }
        imageView.completion?(success, nil)
    }
}
