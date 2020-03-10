//
//  testListViewController.swift
//  MediaList
//
//  Created by  on 04/03/2020.
//  Copyright © 2020 Da Costa Paolo. All rights reserved.
//

import UIKit
import Foundation

class testListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var mediaTableView: UITableView!
    
    let CellId : String = "mediaCellID"
    
    var arrayListMedia:[MediaResponse] = []
    
    var imageCache : [String:UIImage] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // transfert behavhior to delegate class
        mediaTableView.delegate = self
        mediaTableView.dataSource = self
        mediaTableView.register(UINib(nibName : "MediaTableViewCell", bundle: nil), forCellReuseIdentifier: CellId)
        
        
        let downloadMediasCallback : ((_  mediaList: [MediaResponse]) -> Void) = {(mediaList) -> Void in
            
            self.arrayListMedia += mediaList.compactMap({ (mediaResp) -> MediaResponse? in
                return MediaResponse(idMedia: mediaResp.idMedia, titleMedia: mediaResp.titleMedia, descriptionMedia: mediaResp.descriptionMedia, yearMedia: mediaResp.yearMedia, imagePosterMedia: mediaResp.imagePosterMedia, imageBackdropMedia: mediaResp.imageBackdropMedia, popularityMedia: mediaResp.popularityMedia, tagLineMedia: mediaResp.tagLineMedia, runtimeMedia: mediaResp.runtimeMedia, arrayMedia: mediaResp.arrayMedia, trailerMedia: mediaResp.trailerMedia)
            })
            DispatchQueue.main.sync {
                self.mediaTableView.reloadData()
            }
            
        }
        
        downloadMedias(page : "1", callback: downloadMediasCallback)
        downloadMedias(page : "2", callback: downloadMediasCallback)
        downloadMedias(page : "3", callback: downloadMediasCallback)
    }
    
    // a callback fonction type with with list movie in parameter and return and void
    func downloadMedias(page : String, callback : @escaping ((_  mediaList: [MediaResponse]) -> Void) ){
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=fe7dc8e24817870c1f6d573dcbc1fc6c&language=fr-FR&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)")!
        //completionHandler is param of type function, the closure have two param
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            
            // Check if an error occured
            if error != nil {
                // HERE you can manage the error
                callback([])
                return
            }
            
            // Check the response
            if let nonNilData = data {
                // Serialize the data into an object
                let mediaReponseStruct : MediasResponseStruc? = try? JSONDecoder().decode(MediasResponseStruc.self, from: nonNilData)
                callback(mediaReponseStruct?.media ?? [])
                return
            }
            
            callback([])
            
        })
        task.resume()

    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        let secondViewController = segue.destination as! ViewController
        secondViewController.idMedia = sender as? Int
     }
     
    // for return the exact number of media found
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayListMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as! MediaTableViewCell
        
        // if index isn't in movieArray
        guard arrayListMedia.count > indexPath.row else {
            return cell
        }
        
        // cellule.label.type of data = the array of struct[row] and the structure
        cell.titleLabel.text = arrayListMedia[indexPath.row].titleMedia
        cell.descriptionLabel.text = arrayListMedia[indexPath.row].descriptionMedia
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "FR-fr")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: arrayListMedia[indexPath.row].yearMedia!)
        formatter.dateFormat = "dd MMMM yyyy"
        
        var newDate : String = ""
        
        if let nonOptDate = date{
            newDate = formatter.string(from: nonOptDate)
        }
        
        cell.yearLabel.text = newDate
        
        
        
        
        
        guard let urlString : String = arrayListMedia[indexPath.row].imagePosterMedia else {
            return cell
        }
        
        let pathImageFirstPart : String = "https://image.tmdb.org/t/p/w300/"
        
        
        
        let url = URL(string: pathImageFirstPart + urlString )
        cell.leftImage.downloadImage(from: url!)
        
        //imageCache = [pathImageFirstPart:urlString]
        
        print(indexPath.row)
        
        return cell
    }
    
    // when the cell is selected in list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idRow = arrayListMedia[indexPath.row].idMedia
        performSegue(withIdentifier: "navSegueDetail", sender: idRow)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
// to add function in UIImageView
extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            // we throw that in another thread
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}



