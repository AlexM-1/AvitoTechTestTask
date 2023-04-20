
import Foundation
import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {
    }
    
    func loadFromBundleJSON<T: Decodable>(_ filename: String) -> T {
        
        var data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    
    func loadImageFromUrl(imageUrl: String?, completion: @escaping (UIImage?) -> Void) {
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            completion(nil)
            return }
        
        // Проверка, существует ли изображение в кэше
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            let image = UIImage(data: cachedResponse.data)
            completion(image)
            return
        }
        // если к кэше нет данного изображения, получаем его из сети
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, _ in
            
            if let data = data, let response = response {
                let image = UIImage(data: data)
                completion(image)
                
                // помещаем в кэш
                self?.handleLoadedImage(data: data, response: response)
            }
            
        }
        dataTask.resume()
    }
    
    // Метод, помещающий изображение в кэш
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
}
