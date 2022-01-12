import Flutter
import UIKit

@available(iOS 10.0, *)
public class SwiftResizeMediaPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "resize_media", binaryMessenger: registrar.messenger())
        let instance = SwiftResizeMediaPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)  {
        if (call.method == "image") {
            var dict: NSDictionary? = nil

            if (call.arguments != nil) {
                dict = (call.arguments as! NSDictionary)
            }

            let path: String = dict!.value(forKey: "path") as! String

            print(dict!.value(forKey: "maxWidth") as Any)

            var maxWidth = dict!.value(forKey: "maxWidth")
            var maxHeight = dict!.value(forKey: "maxHeight")
            var imageQuality = dict!.value(forKey: "imageQuality")

            if maxWidth is NSNull {
                maxWidth = 0.0 as Double
            } else {
                maxWidth = dict!.value(forKey: "maxWidth") as! Double
            }

            if maxHeight is NSNull {
                maxHeight =  0.0 as Double
            } else {
                maxHeight = dict!.value(forKey: "maxHeight") as! Double
            }

            if imageQuality is NSNull {
                imageQuality = 1.0 as Double
            } else {
                imageQuality = dict!.value(forKey: "imageQuality") as! Double
            }

            let originalData: Data

            do {
                originalData = try Data(contentsOf: URL(fileURLWithPath: path))
            } catch {
                result(FlutterError(code: "ImageCompress", message: "Cannot load image data.", details: nil))
                return
            }

            let source: CGImageSource = CGImageSourceCreateWithData((originalData as! CFMutableData), nil)!

            let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0,nil) as! [String:Any]

            guard let originalImage = UIImage(data: originalData) else {
                result(FlutterError(code: "ImageCompress", message: "Load image Failed.", details: nil))
                return
            }

            let resizedImage = self.resize(image: originalImage, maxWidth: maxWidth as! Double, maxHeight: maxHeight as! Double)

            if let jpgData = resizedImage!.jpegData(compressionQuality: imageQuality as! Double) {
                guard let source = CGImageSourceCreateWithData(jpgData as CFData, nil),
                      let uniformTypeIdentifier = CGImageSourceGetType(source) else { return }

                let finalData = NSMutableData(data: jpgData)

                guard let destination = CGImageDestinationCreateWithData(finalData, uniformTypeIdentifier, 1, nil) else { return }

                CGImageDestinationAddImageFromSource(destination, source, 0, metadata as CFDictionary)

                guard CGImageDestinationFinalize(destination) else { return }

                let name = (path as NSString).lastPathComponent

                let file = FileManager.default.temporaryDirectory.appendingPathComponent(name + ".jpg")

                try? finalData.write(to: file)

                result(file.path)
            }

        }
    }

    //    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    //        let size = image.size
    //
    //        let widthRatio  = targetSize.width  / size.width
    //        let heightRatio = targetSize.height / size.height
    //
    //        var newSize: CGSize
    //
    //        if(widthRatio > heightRatio) {
    //            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    //        } else {
    //            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    //        }
    //
    //        let rect = CGRect(origin: .zero, size: newSize)
    //
    //        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    //        image.draw(in: rect)
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        return newImage
    //    }

    func resize(image: UIImage, maxWidth: Double, maxHeight: Double) -> UIImage? {
        let originalWidth = image.size.width;
        let originalHeight = image.size.height;

        let hasMaxWidth = maxWidth != 0.0
        let hasMaxHeight = maxHeight != 0.0

        var width = hasMaxWidth ? min(maxWidth, originalWidth) : originalWidth
        var height = hasMaxHeight ? min(maxHeight , originalHeight) : originalHeight

        let shouldDownscaleWidth = hasMaxWidth && maxWidth  < originalWidth
        let shouldDownscaleHeight = hasMaxHeight && maxHeight  < originalHeight
        let shouldDownscale = shouldDownscaleWidth || shouldDownscaleHeight

        if (shouldDownscale) {
            let downscaledWidth = floor((height / originalHeight) * originalWidth);
            let downscaledHeight = floor((width / originalWidth) * originalHeight);

            if (width < height) {
                if (!hasMaxWidth) {
                    width = downscaledWidth;
                } else {
                    height = downscaledHeight;
                }
            } else if (height < width) {
                if (!hasMaxHeight) {
                    height = downscaledHeight;
                } else {
                    width = downscaledWidth;
                }
            } else {
                if (originalWidth < originalHeight) {
                    width = downscaledWidth;
                } else if (originalHeight < originalWidth) {
                    height = downscaledHeight;
                }
            }
        }

        let imageToScale = UIImage.init(cgImage: image.cgImage!, scale: 1, orientation: UIImage.Orientation.up)

        if (image.imageOrientation == UIImage.Orientation.left ||
            image.imageOrientation == UIImage.Orientation.right ||
            image.imageOrientation == UIImage.Orientation.leftMirrored ||
            image.imageOrientation == UIImage.Orientation.rightMirrored) {
            let temp = width;
            width = height;
            height = temp;
        }

        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: width, height: height), false, 1.0);

        imageToScale.draw(in: CGRect(x: 0, y: 0, width: width, height: height))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return scaledImage;
    }
}
