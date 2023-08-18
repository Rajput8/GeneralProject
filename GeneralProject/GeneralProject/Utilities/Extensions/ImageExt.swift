import UIKit

extension UIImage {

    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        do {
            self.init(data: try Data(contentsOf: url))
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }

    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func bluredImage(radius: CGFloat = 10) -> UIImage {
        if let source = self.cgImage {
            let context = CIContext(options: nil)
            let inputImage = CIImage(cgImage: source)
            let clampFilter = CIFilter(name: "CIAffineClamp")
            clampFilter?.setDefaults()
            clampFilter?.setValue(inputImage, forKey: kCIInputImageKey)
            if let clampedImage = clampFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let explosureFilter = CIFilter(name: "CIExposureAdjust")
                explosureFilter?.setValue(clampedImage, forKey: kCIInputImageKey)
                explosureFilter?.setValue(-1.0, forKey: kCIInputEVKey)
                if let explosureImage = explosureFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                    let filter = CIFilter(name: "CIGaussianBlur")
                    filter?.setValue(explosureImage, forKey: kCIInputImageKey)
                    filter?.setValue("\(radius)", forKey: kCIInputRadiusKey)
                    if let result = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                        let bounds = UIScreen.main.bounds
                        if let cgImage = context.createCGImage(result, from: bounds) {
                            let returnImage = UIImage(cgImage: cgImage)
                            return returnImage
                        }
                    }
                }
            }
        }
        return UIImage()
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data.
    /// This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}
