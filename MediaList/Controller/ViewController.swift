//
//  ViewController.swift
//  MediaList
//
//  Created by  on 03/03/2020.
//  Copyright © 2020 Da Costa Paolo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBAction func playVideoButton(_ sender: Any) {
        
        //check for know if arraystruct have a trailer and for prevent the crash of the application 
        if arrayTrailerList.count > 0{
            let value =  arrayTrailerList[0].key
            
            // add link url in the button
            let urlYoutubeTrailer : String = "https://www.youtube.com/watch?v=\(value)"
            if let urlTrailer = URL(string: "\(urlYoutubeTrailer)"), !urlTrailer.absoluteString.isEmpty {
                UIApplication.shared.open(urlTrailer, options: [:], completionHandler: nil)
            }

            // or outside scope use this
            guard let urlTrailer = URL(string: "\(urlYoutubeTrailer)"), !urlTrailer.absoluteString.isEmpty else {
               return
            }
             UIApplication.shared.open(urlTrailer, options: [:], completionHandler: nil)
        }
        
    }
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleMediaLabel: UILabel!
    @IBOutlet weak var subTitileMediaLabel: UILabel!
    @IBOutlet weak var yearMediaLabel: UILabel!
    @IBOutlet weak var durationMediaLabel: UILabel!
    @IBOutlet weak var categoryMediaLabel: UILabel!
    @IBOutlet weak var categoryMediaLabel2: UILabel!
    @IBOutlet weak var categoryMediaLabel3: UILabel!
    @IBOutlet weak var synopsisMediaLabel: UILabel!
    
    var idMedia : Int?
    
    var arrayTrailerList:[VideoTrailer] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadMedias(idMedia: idMedia!)
        
    }
    
    

    // a callback fonction type with with id movie in parameter
    func downloadMedias(idMedia : Int){
        
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(idMedia)?api_key=fe7dc8e24817870c1f6d573dcbc1fc6c&language=en-US&append_to_response=videos")!
        //completionHandler is param of type function, the closure have two param
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                
            
            // Check if an error occured
            if error != nil {
                // HERE you can manage the error
                return
            }
            // Check the response
            if let nonNilData = data {
                // Serialize the data into an objec
                let mediaReponse : MediaResponse? = try? JSONDecoder().decode(MediaResponse.self, from: nonNilData)
                
                if let hours = mediaReponse?.runtimeMedia{
                    self.durationMediaLabel.text = "\(hours) min"
                }
                
                guard let mediaNoneOpt = mediaReponse else{
                    return
                }
                
                self.titleMediaLabel.text = mediaNoneOpt.titleMedia
                
                /*let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "FR-fr")
                formatter.dateFormat = "yyyy-MM-dd"
                date = formatter.date(from: mediaNoneOpt.yearMedia!)
                formatter.dateFormat = "dd-MMMM-yyyy"
                let newDate = formatter.string(from: date)*/
                
                self.yearMediaLabel.text = mediaNoneOpt.yearMedia
                self.synopsisMediaLabel.text = mediaNoneOpt.descriptionMedia
                self.subTitileMediaLabel.text = mediaNoneOpt.tagLineMedia
                
                if let category = mediaNoneOpt.arrayMedia{
                    if category.count > 0{
                        self.categoryMediaLabel.text = category[0].name
                    }else
                    {
                        self.categoryMediaLabel.isHidden = true
                    }
                    
                }
        
                if let category = mediaNoneOpt.arrayMedia{
                    if category.count > 1{
                        self.categoryMediaLabel2.text = category[1].name
                    }else
                    {
                        self.categoryMediaLabel2.isHidden = true
                    }
                    
                }
                
                if let category = mediaNoneOpt.arrayMedia{
                    if  category.count > 2{
                        self.categoryMediaLabel3.text = category[2].name
                    }else
                    {
                        self.categoryMediaLabel3.isHidden = true
                    }
                   
                }
                
                let pathImageFirstPart : String = "https://image.tmdb.org/t/p/original/"
                
                if let urlString : String = mediaReponse?.imagePosterMedia, let url = URL(string: pathImageFirstPart + urlString ){
                    self.leftImageView.downloadImage(from:  url)
                }
                
                if let urlString : String = mediaReponse?.imageBackdropMedia, let url = URL(string: pathImageFirstPart + urlString ){
                    self.backgroundImageView.downloadImage(from:  url)
                }
                
               if let resultKey = mediaReponse?.trailerMedia{
                if let result = resultKey["results"]{
                    for i in result{
                        self.arrayTrailerList.append(i)
                    }
                }
                
                
               }
                if self.arrayTrailerList.count == 0{
                    self.videoButton.isHidden = true
                }
                return
            }
            }
        })
        task.resume()
    }
}


