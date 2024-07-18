//
//  UIImage+.swift
//  CleanSwiftCase
//
//  Created by Tosun, Irem on 17.07.2024.
//

import Foundation
import UIKit

extension UIImage {
    static func image(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Create a background queue to fetch the image data
        DispatchQueue.global(qos: .background).async {
            do {
                // Fetch image data
                let data = try Data(contentsOf: url)
                // Create UIImage from data
                let image = UIImage(data: data)
                
                // Call the completion handler on the main thread
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                print("Error loading image from URL: \(error)")
                // Call the completion handler on the main thread with nil
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
