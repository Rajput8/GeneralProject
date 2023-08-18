import Foundation
import UIKit

extension UIImageView: AssociatedValue {}

extension UIImageView {

    enum RequestType {
        case viaContentURL, viaURLRequest
    }

    private static var imageCache = NSCache<NSString, UIImage>()
    private static var activityIndicatorViewAssociationKey: UInt8 = 0

    func urlSessions() -> URLSession {
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        return session
    }

    private var activityIndicatorView: UIActivityIndicatorView? {
        get { return objc_getAssociatedObject(self, &UIImageView.activityIndicatorViewAssociationKey) as? UIActivityIndicatorView }
        set { objc_setAssociatedObject(self, &UIImageView.activityIndicatorViewAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func startAnimating() {
        guard activityIndicatorView == nil else { return }
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        indicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        DispatchQueue.main.async {
            self.activityIndicatorView = indicatorView
            self.addSubview(indicatorView)
            indicatorView.startAnimating()
        }
    }

    func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView?.stopAnimating()
            self.activityIndicatorView?.removeFromSuperview()
            self.activityIndicatorView = nil
        }
    }

    final internal var indexPathIdentifier: Int {
        get { return getAssociatedValue(key: &indexPathIdentifierAssociationKey, defaultValue: -1) }
        set { setAssociatedValue(key: &indexPathIdentifierAssociationKey, value: newValue) }
    }

    final internal var completion: ((_ finished: Bool, _ error: Error?) -> Void)? {
        get { return getAssociatedValue(key: &completionAssociationKey, defaultValue: nil) }
        set { setAssociatedValue(key: &completionAssociationKey, value: newValue) }
    }

    func imageNamed(_ imageName: String) -> UIImage? {
        if let cachedImage = UIImageView.imageCache.object(forKey: imageName as NSString) {
            return cachedImage
        } else {
            if let image = UIImage(named: imageName) {
                UIImageView.imageCache.setObject(image, forKey: imageName as NSString)
                return image
            } else {
                return nil
            }
        }
    }

    final func loadImage(contentURL: String,
                         requestParams: APIRequestParams? = nil,
                         placeholder: String? = "appLogo",
                         completion: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {

        guard let contentURL = URL(string: contentURL) else {
            DispatchQueue.main.async {
                completion?(false, nil)
                self.stopAnimating()
            }
            return
        }

        startAnimating()

        var remoteURLRequest: URLRequest? = nil
        var urlForValidation = ""

        if let requestParams {
            guard var urlRequest = SessionURLRequest.urlRequest(requestParams) else {
                DispatchQueue.main.async {
                    LoaderUtil.shared.hideLoading()
                    completion?(false, nil)
                }
                return
            }
            let cleanedURLString = ImageCacheManager.shared.cleanStringFunction(urlRequest.url?.absoluteString ?? "")
            urlRequest.url = contentURL
            urlForValidation = cleanedURLString
            remoteURLRequest = urlRequest
        } else {
            urlForValidation = contentURL.absoluteString
            remoteURLRequest = nil
        }

        loadImage(url: contentURL,
                  urlForCheckingWhetherItIsAlreadyInCache: urlForValidation,
                  placeholder: placeholder,
                  urlRequest: remoteURLRequest,
                  completion: completion)
    }

    final func loadImage(url: URL,
                         urlForCheckingWhetherItIsAlreadyInCache: String,
                         placeholder: String? = nil,
                         urlRequest: URLRequest? = nil,
                         completion: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {

        self.completion = completion
        self.indexPathIdentifier = -1
        let urlString = url.absoluteString
        let cleanedString = ImageCacheManager.shared.cleanStringFunction(urlString)
        let pathURL = ImageCacheManager.shared.cacheDirectory.appendingPathComponent(cleanedString)

        if let cachedImage = UIImage(contentsOfFile: pathURL.path) {
            DispatchQueue.main.async {
                let currentData = NSDate()
                let attributes = [FileAttributeKey.modificationDate: currentData]
                do {
                    try FileManager.default.setAttributes(attributes, ofItemAtPath: pathURL.path)
                } catch {
                    print(error)
                }
                self.image = cachedImage
                self.stopAnimating()
                self.completion?(true, nil)
            }
        } else {
            if let imageName = placeholder, let placeholder = imageNamed(imageName) { self.image = placeholder }
            var parentView = self.superview
            while parentView != nil {
                switch parentView {
                case let tableViewCell as UITableViewCell:
                    if let tableView = tableViewCell.superview as? UITableView,
                       let indexPath = tableView.indexPathForRow(at: tableViewCell.center) {
                        self.indexPathIdentifier = indexPath.hashValue
                    }
                case let collectionViewCell as UICollectionViewCell:
                    if let collectionView = collectionViewCell.superview as? UICollectionView,
                       let indexPath = collectionView.indexPathForItem(at: collectionViewCell.center) {
                        self.indexPathIdentifier = indexPath.hashValue
                    }
                default: break
                }
                parentView = parentView?.superview
            }
            let initialIndexIdentifier = self.indexPathIdentifier
            if ImageCacheManager.shared.isDownloadingFromURL(urlString) == false {
                ImageCacheManager.shared.setIsDownloadingFromURL(true, urlString: urlString)
                ImageCacheManager.shared.removeFromLocalDirAndCache(.particularFile, urlForCheckingWhetherItIsAlreadyInCache) { _ in }
                if let urlRequest {
                    let task = urlSessions().dataTask(with: urlRequest) { data, response, error in
                        self.handleRequestResponse(urlString: urlString,
                                                   cleanedString: cleanedString,
                                                   initialIndexIdentifier: initialIndexIdentifier,
                                                   data: data,
                                                   response: response,
                                                   error: error)
                    }
                    task.resume()
                } else {
                    let task = urlSessions().dataTask(with: url) { data, response, error in
                        self.handleRequestResponse(urlString: urlString,
                                                   cleanedString: cleanedString,
                                                   initialIndexIdentifier: initialIndexIdentifier,
                                                   data: data,
                                                   response: response,
                                                   error: error)
                    }
                    task.resume()
                }
            } else {
                weak var weakSelf = self
                ImageCacheManager.shared.addImageCacheObserver(weakSelf!,
                                                               initialIndexIdentifier: initialIndexIdentifier,
                                                               key: urlString)
            }
        }
    }

    fileprivate func handleRequestResponse(urlString: String,
                                           cleanedString: String,
                                           initialIndexIdentifier: Int,
                                           data: Data?,
                                           response: URLResponse?,
                                           error: Error?) {

        guard let data = data, let _ = response, let image = UIImage(data: data), error == nil else {
            DispatchQueue.main.async {
                self.stopAnimating()
                self.completion?(false, error)
            }
            DispatchQueue.global().async {
                ImageCacheManager.shared.setIsDownloadingFromURL(false, urlString: urlString)
                ImageCacheManager.shared.removeImageCacheObserversForKey(urlString)
            }
            return
        }
        if initialIndexIdentifier == self.indexPathIdentifier {
            DispatchQueue.main.async {
                self.image = image
                self.stopAnimating()
                self.completion?(true, nil)
            }
        } else {
            DispatchQueue.main.async {
                self.image = UIImage(named: "appLogo")
            }
        }
        DispatchQueue.global().async {
            ImageCacheManager.shared.updateImageCache(key: urlString)
            let cacheURL = ImageCacheManager.shared.cacheDirectory.appendingPathComponent(cleanedString)
            try? data.write(to: cacheURL)
        }
    }
}
