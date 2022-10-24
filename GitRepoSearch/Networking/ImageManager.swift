
import UIKit

protocol ImageManaging: AnyObject {
    func downloadImageFromURL(_ urlString: String, completion: ((_ success: Bool, _ image: UIImage?) -> Void)?)
}

class ImageManager: NSObject {
    
    static let cache = NSCache<NSString, UIImage>()
    static let sharedInstance = ImageManager()

    var imageCache = [String: UIImage]()
    private let kLazyLoadMaxCacheImageSize = 20
    
    
    /// Store image in cache
    /// - Parameter image: image data
    /// - Parameter url: image URL
    func cacheImage(_ image: UIImage, forURL url: String) {
        if imageCache.count > kLazyLoadMaxCacheImageSize { // free old images first.
            imageCache.remove(at: imageCache.startIndex)
        }
        imageCache[url] = image
    }

    
    /// Func for store cache image
    /// - Parameter url: image URL
    func cachedImageForURL(_ url: String) -> UIImage? { return imageCache[url] }
    func clearCache() { imageCache.removeAll() }

    
    /// Get image asynchronously
    /// - Parameter urlString: image URL
    /// - Parameter completion: image data or error result.
    func downloadImageFromURL(_ urlString: String, completion: ((_ success: Bool, _ image: UIImage?) -> Void)?) {
        // Check if system have image in cache
        if let cachedImage = cachedImageForURL(urlString) {
            DispatchQueue.main.async(execute: {completion?(true, cachedImage) })
        } else if let url = URL(string: urlString) { // download from URL asynchronously
            let session = URLSession.shared
            let downloadTask = session.downloadTask(with: url, completionHandler: { (retrievedURL, _, error) -> Void in
                var found = false
                if error != nil { print("Error downloading image \(url.absoluteString): \(error!.localizedDescription)") } else if retrievedURL != nil {
                    if let data = try? Data(contentsOf: retrievedURL!) {
                        if let image = UIImage(data: data) {
                            found = true
                            self.cacheImage(image, forURL: url.absoluteString)
                            DispatchQueue.main.async(execute: { completion?(true, image) })
                        }
                    }
                }
                if !found { DispatchQueue.main.async(execute: { completion?(false, nil) }); }
            })
            downloadTask.resume()
        } else { completion?(false, nil) }
    }

}

