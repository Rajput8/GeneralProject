import Foundation

var indexPathIdentifierAssociationKey: UInt8 = 0
var completionAssociationKey: UInt8 = 0

internal protocol AssociatedValue {
    func getAssociatedValue<T>(key: UnsafeRawPointer, defaultValue: T?) -> T?
    func getAssociatedValue<T>(key: UnsafeRawPointer, defaultValue: T) -> T
    func setAssociatedValue<T>(key: UnsafeRawPointer, value: T?, policy: objc_AssociationPolicy)
}

internal extension AssociatedValue {
    func getAssociatedValue<T>(key: UnsafeRawPointer, defaultValue: T?) -> T? {
        guard let value = objc_getAssociatedObject(self, key) as? T else { return defaultValue }
        return value
    }

    func getAssociatedValue<T>(key: UnsafeRawPointer, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else { return defaultValue }
        return value
    }

    func setAssociatedValue<T>(key: UnsafeRawPointer, value: T?,
                               policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, key, value, policy)
    }
}

enum ImageCacheKey {
    case image, isDownloading, observerMapping
}

enum ClearCacheType {
    case expired
    case spontaneously
    case particularFile
}