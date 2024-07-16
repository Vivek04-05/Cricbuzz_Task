//
//  MovieDetailsViewController.swift
//  MovieWorld
//
//  Created by Vivek Patel on 16/07/24.
//

import UIKit
import SDWebImage
class MovieDetailsViewController: UIViewController {
  
    
    @IBOutlet var imgView: UIImageView!
    
    
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieGenre: UILabel!
    @IBOutlet var movieCaste: UILabel!
    @IBOutlet var movieCrew: UILabel!
    @IBOutlet var movieyear: UILabel!
    @IBOutlet var moviePlot: UILabel!
    
    @IBOutlet var rating1: UILabel!
    @IBOutlet var rating2: UILabel!
    @IBOutlet var rating3: UILabel!
    
    @IBOutlet var rating1Desc: UILabel!
    
    @IBOutlet var rating2Desc: UILabel!
    
    @IBOutlet var rating3Desc: UILabel!
    
    @IBOutlet var scrollViewConstants: NSLayoutConstraint!
    
    
    var movie: MovieDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        scrollViewConstants.constant = UIScreen.main.bounds.height + 200
    }
    
    func setUpUI(){
        if let image = movie?.poster , let url = URL(string: image) {
            imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            imgView.image = UIImage(named: "placeholder")
        }
        
        movieTitle.text = movie?.title
        movieGenre.text = movie?.genre
        movieCaste.text = movie?.actors
        movieCrew.text = movie?.writer
        movieyear.text = movie?.year
        
        moviePlot.text = movie?.plot
        
        if let ratings = movie?.ratings {
                    // Handle rating 1
                    if ratings.count > 0 {
                        rating1.text = ratings[0].source
                        rating1Desc.text = ratings[0].value
                        rating1.isHidden = false
                        rating1Desc.isHidden = false
                    } else {
                        rating1.isHidden = true
                        rating1Desc.isHidden = true
                    }
                    
                    // Handle rating 2
                    if ratings.count > 1 {
                        rating2.text = ratings[1].source
                        rating2Desc.text = ratings[1].value
                        rating2.isHidden = false
                        rating2Desc.isHidden = false
                    } else {
                        rating2.isHidden = true
                        rating2Desc.isHidden = true
                    }
                    
                    // Handle rating 3
                    if ratings.count > 2 {
                        rating3.text = ratings[2].source
                        rating3Desc.text = ratings[2].value
                        rating3.isHidden = false
                        rating3Desc.isHidden = false
                    } else {
                        rating3.isHidden = true
                        rating3Desc.isHidden = true
                    }
                } else {
                    // Handle case where ratings is nil
                    rating1.isHidden = true
                    rating2.isHidden = true
                    rating3.isHidden = true
                    rating1Desc.isHidden = true
                    rating2Desc.isHidden = true
                    rating3Desc.isHidden = true
                }
            }
        
       
    }

