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
    
    var arrayStruct:[MediaResponse] = []
    
    var imageCache : [String:UIImage] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaTableView.delegate = self
        mediaTableView.dataSource = self
        mediaTableView.register(UINib(nibName : "MediaTableViewCell", bundle: nil), forCellReuseIdentifier: CellId)
        
        
        
        
        let downloadMediasCallback : ((_  mediaList: [MediaResponse]) -> Void) = {(mediaList) -> Void in
            
            self.arrayStruct += mediaList.compactMap({ (mediaResp) -> MediaResponse? in
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
    
    //un callback de type fonction qui prend en paramètre une liste de mediaReponse et qui retourne un type void
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
            // Serialize the data into an object

            if let nonNilData = data {
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

        // set a variable in the second view controller with the data to pass
    
        secondViewController.idMedia = sender as? Int
     }
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayStruct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as! MediaTableViewCell
        
        guard arrayStruct.count > indexPath.row else {
            return cell
        }
        
        // cellule.label.type de données = le tableau de structure [l'index].la structure
        cell.titleLabel.text = arrayStruct[indexPath.row].titleMedia
        cell.descriptionLabel.text = arrayStruct[indexPath.row].descriptionMedia
        cell.yearLabel.text = arrayStruct[indexPath.row].yearMedia
        
        
        
        
        
        guard let urlString : String = arrayStruct[indexPath.row].imagePosterMedia else {
            return cell
        }
        
        let pathImageFirstPart : String = "https://image.tmdb.org/t/p/w300/"
        
        
        
        let url = URL(string: pathImageFirstPart + urlString )
        cell.leftImage.downloadImage(from: url!)
        
        //imageCache = [pathImageFirstPart:urlString]
        
        print(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idRow = arrayStruct[indexPath.row].idMedia
        performSegue(withIdentifier: "navSegueDetail", sender: idRow)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

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



