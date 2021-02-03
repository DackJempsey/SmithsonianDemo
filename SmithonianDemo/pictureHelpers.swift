//
//  pictureHelpers.swift
//  SmithonianDemo
//
//  Created by Jack Dempsey on 5/3/20.
//  Copyright © 2020 JackDempsey. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}



class pictureHelper{
    
    struct picture{
        let name: String
        let artist: String? = nil
        let thumbnailSource: URL
        let tiffSource: URL
        let dimensions: Set<CGFloat>? = nil
        let image: UIImage
    }
    
    struct queryPicture: Codable{
        let tiff_url: String
        let thumbnail: String
        let title: String
    }
    
    var tappedRow: Int = -1
    
    var paintings: [picture] = []
    
    func getPictureList(from queryTerms: String, completionHandler: @escaping (_ data: [queryPicture]?) -> ()) {
        let url = handleURL(query: queryTerms)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error fetching the image data")
                completionHandler(nil)
            } else {
                let jsonDecoder = JSONDecoder()
                let pictureData = try? jsonDecoder.decode([queryPicture].self, from: data!)
                completionHandler(pictureData)
                
            }
        }
        
        dataTask.resume()
    }
    
    func fetchImage(from urlString: String, completionHandler: @escaping (Data?) -> ()) {
        let session = URLSession.shared
        let url = URL(string: urlString)!
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
        dataTask.resume()
    }
    
    func handleURL(query: String) -> URL {
        var goodQuery = query
        if query.contains(" ") {
            goodQuery = query.replacingOccurrences(of: " ", with: "+")
        }
        let queryURL = "http://134.122.2.78:5000/query/" + goodQuery
        let url = URL(string: queryURL)!
        return url
    }

    // THIS IS THE FUNCTION THAT IS IN USE
    func updateImages(pictures: [queryPicture], tableView: UITableView) {
        for pic in pictures {
            let imageData = pic.thumbnail
            print("URL: ", imageData)
            fetchImage(from: imageData){ (imageData) in
                if let data = imageData {
                    // referenced imageView from main thread
                    // as iOS SDK warns not to use images from
                    // a background thread
                    DispatchQueue.main.async {
                        print("DATA", data)
                        let image = UIImage(data: data)!
                        let thumbUrl = URL(string: pic.thumbnail)!
                        let tiffURL = URL(string: pic.tiff_url)!
                        let imageToSet = picture(name: pic.title, thumbnailSource: thumbUrl, tiffSource: tiffURL, image: image)
                        self.paintings.append(imageToSet)
                        // add to the UIScroll View
                        // let index = self.paintings.count
                        // self.addToView(index: index, imageToSet: imageToSet, scrollView: scrollView)
                        tableView.reloadData()
                    }
                } else {
                        // show as an alert if you want to
                    print("Error loading image");
                }
            }
        }
    }
    
    func addToView(index: Int, imageToSet: picture, scrollView: UIScrollView) {
        
        let ratio = imageToSet.image.size.height / imageToSet.image.size.width
        let width = 150
        let hieght = Int(CGFloat(width) * ratio)
        
        let myImageView = newView(with: imageToSet, width: width, hieght: hieght)
        // add not multiply
        // let imageViewYoffeset = CGFloat((index-1) * (hieght + 20))
        var imageViewYoffeset : CGFloat
        if index > 1 {
            imageViewYoffeset = scrollView.contentSize.height + 40
            scrollView.contentSize.height = imageViewYoffeset + CGFloat(hieght)
        } else {
            imageViewYoffeset = 20
            scrollView.contentSize.height = CGFloat(hieght)
        }
        myImageView.frame = myImageView.frame.offsetBy(dx: 0, dy: imageViewYoffeset)
        scrollView.addSubview(myImageView)
        // scrollView.contentSize.height = scrollView.contentSize.height + imageViewYoffeset
        scrollView.contentSize.width = CGFloat(width)
        if CGFloat(width) > scrollView.contentSize.width {
            scrollView.contentSize.width =  CGFloat(width)
        }
        
        print("higth: ",scrollView.contentSize.height)
        print("width: ",scrollView.contentSize.width)
    }
    
    func newView(with imageInfo: picture, width: Int, hieght: Int) -> UIView {
        
        // let pictureView = UIStackView(frame: CGRect(x: 0, y: 0, width: width, height: hieght))
        // let pictureView = UIControl(frame: CGRect(x: 0, y: 0, width: width, height: hieght))
        let pictureView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: hieght))

        let picFrame = CGRect(x: 0, y: 0, width: width, height: hieght)

        let description = imageInfo.name
        let yOffset = CGFloat(hieght / 2) + 10
        let xOffset = CGFloat(width + 15)
        let labelFrame = picFrame.offsetBy(dx: xOffset, dy: -10)
        let myDesciptionView: UILabel = UILabel(frame: labelFrame)
        myDesciptionView.text = description
        pictureView.addSubview(myDesciptionView)
        
        let imageView: UIImageView = UIImageView(frame: picFrame)
        imageView.image = imageInfo.image
        pictureView.addSubview(imageView)
        
        let buttonFrame = labelFrame.offsetBy(dx: 0, dy: 20)
        let button = UIButton(frame: buttonFrame)
        button.setTitle("Temp", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        let buttonTouch = UIControl.Event.allTouchEvents
        // here we add the action to start the process to transition to AR view
        
        pictureView.addSubview(button)
        
        
        return pictureView
    }

}
