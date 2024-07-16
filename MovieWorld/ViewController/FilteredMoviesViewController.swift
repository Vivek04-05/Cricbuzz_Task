//
//  FilteredMoviesViewController.swift
//  MovieWorld
//
//  Created by Vivek Patel on 15/07/24.
//

import UIKit

class FilteredMoviesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var movies: [MovieDataModel] = []
    
    @IBOutlet var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.sectionHeaderTopPadding = 0
        tblView.showsHorizontalScrollIndicator = false
        tblView.showsVerticalScrollIndicator = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        
        if let movieImage = movies[indexPath.row].poster , let url = URL(string: movieImage) {
            cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.imgView.image = UIImage(named: "placeholder")
        }
        
        cell.textLbl1.text = movies[indexPath.row].title
        cell.textLbl2.text = "Language: \(movies[indexPath.row].language ?? "N/A")"
        cell.textLbl3.text = "Year: \(movies[indexPath.row].year ?? "N/A")"
        return cell
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController
        storyboard?.movie = movies[indexPath.row]
        navigationController?.pushViewController(storyboard ?? UIViewController(), animated: true)
    }
}
