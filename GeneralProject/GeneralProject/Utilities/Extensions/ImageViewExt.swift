import UIKit

extension UIImageView {
    func blurEffect() {
        let inputImage = CIImage(cgImage: (self.image?.cgImage)!)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: "inputImage")
        filter?.setValue(50, forKey: "inputRadius")
        let blurred = filter?.outputImage

        var newImageSize: CGRect = (blurred?.extent)!
        newImageSize.origin.x += (newImageSize.size.width - (self.image?.size.width)!) / 2
        newImageSize.origin.y += (newImageSize.size.height - (self.image?.size.height)!) / 2
        newImageSize.size = (self.image?.size)!

        if let resultImage = filter?.value(forKey: "outputImage") as? CIImage {
            let context: CIContext = CIContext.init(options: nil)
            let cgimg: CGImage = context.createCGImage(resultImage, from: newImageSize)!
            let blurredImage: UIImage = UIImage.init(cgImage: cgimg)
            self.image = blurredImage
        }
    }
}
