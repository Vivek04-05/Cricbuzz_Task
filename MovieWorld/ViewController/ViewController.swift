//
//  ViewController.swift
//  MovieWorld
//
//  Created by Vivek Patel on 15/07/24.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var movies: [MovieDataModel] = []
    var filteredMovies: [MovieDataModel] = []
    var isSearching = false
    
    var arrayHeader: [(title: String, isExpanded: Bool)] = [
        (title: "Year", isExpanded: true),
        (title: "Genre", isExpanded: true),
        (title: "Directors", isExpanded: true),
        (title: "Actors", isExpanded: true),
        (title: "All Movies", isExpanded: true)
    ]
    
    private var viewModel = MovieViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderTopPadding = 0
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        self.movies = viewModel.loadData()
        self.filteredMovies = movies
        searchBar.delegate = self
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return isSearching ? 0 : 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isSearching {
            return UIView()
        } else {
            let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
            viewHeader.backgroundColor = UIColor.darkGray
            
            let titleLabel = UILabel()
            titleLabel.text = arrayHeader[section].title
            titleLabel.textColor = .white
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            viewHeader.addSubview(titleLabel)
            
            let imageView = UIImageView(image: UIImage(systemName: arrayHeader[section].isExpanded ? "chevron.down" : "chevron.up"))
            imageView.tintColor = .white
            imageView.translatesAutoresizingMaskIntoConstraints = false
            viewHeader.addSubview(imageView)
            
            let button = UIButton(type: .custom)
            button.frame = viewHeader.bounds
            button.tag = section
            button.addTarget(self, action: #selector(tapSection(sender:)), for: .touchUpInside)
            viewHeader.addSubview(button)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor),
                
                imageView.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor, constant: -16),
                imageView.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor),
                
                button.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor),
                button.topAnchor.constraint(equalTo: viewHeader.topAnchor),
                button.bottomAnchor.constraint(equalTo: viewHeader.bottomAnchor)
            ])
            
            return viewHeader
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : arrayHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredMovies.count
        }
        let header = arrayHeader[section]
        
        if header.title == "All Movies" {
            return header.isExpanded ? 0 : movies.count
        } else if header.title == "Year" {
            return header.isExpanded ? 0 : getUniqueYears().count
        } else if header.title == "Genre" {
            return header.isExpanded ? 0 : getUniqueGenres().count
        }else if header.title == "Directors" {
            return header.isExpanded ? 0 : getUniqueDirectors().count
        } else if header.title == "Actors" {
            return header.isExpanded ? 0 : getUniqueActors().count
        }else  {
            return header.isExpanded ? 0 : 6
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        
        if isSearching {
            let movie = filteredMovies[indexPath.row]
            if let movieImage = movie.poster, let url = URL(string: movieImage) {
                cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.imgView.image = UIImage(named: "placeholder")
            }
            cell.textLbl1.text = movie.title
            cell.textLbl2.text = "Language: \(movie.language ?? "N/A")"
            cell.textLbl3.text = "Year: \(movie.year ?? "N/A")"
            cell.imgView.isHidden = false
            cell.textLbl2.isHidden = false
            cell.textLbl3.isHidden = false
        } else {
            let header = arrayHeader[indexPath.section]
            
            
            if header.title == "All Movies" {
                if let movieImage = movies[indexPath.row].poster , let url = URL(string: movieImage) {
                    cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
                } else {
                    cell.imgView.image = UIImage(named: "placeholder")
                }
                cell.textLbl1.text = movies[indexPath.row].title
                cell.textLbl2.text = "Language: \(movies[indexPath.row].language ?? "N/A")"
                cell.textLbl3.text = "Year: \(movies[indexPath.row].year ?? "N/A")"
                cell.imgView.isHidden = false
                cell.textLbl2.isHidden = false
                cell.textLbl3.isHidden = false
            } else if header.title == "Year" {
                let uniqueYears = getUniqueYears()
                cell.textLbl1.text = uniqueYears[indexPath.row]
                cell.imgView.isHidden = true
                cell.textLbl2.isHidden = true
                cell.textLbl3.isHidden = true
            } else if header.title == "Genre"{
                let uniqueGenres = getUniqueGenres()
                cell.textLbl1.text = uniqueGenres[indexPath.row]
                cell.imgView.isHidden = true
                cell.textLbl2.isHidden = true
                cell.textLbl3.isHidden = true
            }else if header.title == "Directors"{
                let uniqueDirectors = getUniqueDirectors()
                cell.textLbl1.text = uniqueDirectors[indexPath.row]
                
                cell.imgView.isHidden = true
                cell.textLbl2.isHidden = true
                cell.textLbl3.isHidden = true
                
            }else if header.title == "Actors" {
                let uniqueActors = getUniqueActors()
                cell.textLbl1.text = uniqueActors[indexPath.row]
                
                cell.imgView.isHidden = true
                cell.textLbl2.isHidden = true
                cell.textLbl3.isHidden = true
            }else {
                cell.textLbl1.text = movies[indexPath.row].year
                cell.imgView.isHidden = true
                cell.textLbl2.isHidden = true
                cell.textLbl3.isHidden = true
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearching {
            let movie = filteredMovies[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController
            storyboard?.movie = movie
            navigationController?.pushViewController(storyboard ?? UIViewController(), animated: true)
        } else {
            let header = arrayHeader[indexPath.section]
            
            if header.title == "Year" {
                let selectedYear = getUniqueYears()[indexPath.row]
                let filteredMovies = movies.filter { $0.year == selectedYear }
                let data = filteredMovies
                navigateVC(movieData: data)
                print(data)
                
            }else if header.title == "Genre" {
                let selectedGenre = getUniqueGenres()[indexPath.row]
                let filteredMovies = movies.filter { movie in
                    guard let genres = movie.genre?.components(separatedBy: ", ") else { return false }
                    return genres.contains(selectedGenre)
                }
                navigateVC(movieData: filteredMovies)
            }else if header.title == "Directors" {
                let selectedDirector = getUniqueDirectors()[indexPath.row]
                let filteredMovies = movies.filter { movie in
                    guard let directors = movie.director?.components(separatedBy: ", ") else { return false }
                    return directors.contains(selectedDirector)
                }
                navigateVC(movieData: filteredMovies)
            }else if header.title == "Actors" {
                let selectedActor = getUniqueActors()[indexPath.row]
                let filteredMovies = movies.filter { movie in
                    guard let actors = movie.actors?.components(separatedBy: ", ") else { return false }
                    return actors.contains(selectedActor)
                }
                navigateVC(movieData: filteredMovies)
            } else if header.title == "All Movies"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController
                storyboard?.movie = movies[indexPath.row]
                navigationController?.pushViewController(storyboard ?? UIViewController(), animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if isSearching {
            return 100
        } else {
            if arrayHeader[indexPath.section].title == "All Movies" {
                return 100
            } else {
                return 50
            }
        }
        
    }
    
    
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        if isSearching {
            filteredMovies = movies.filter { movie in
                let searchTextLowercased = searchText.lowercased()
                return (movie.title?.lowercased().contains(searchTextLowercased) ?? false) ||
                (movie.genre?.lowercased().contains(searchTextLowercased) ?? false) ||
                (movie.director?.lowercased().contains(searchTextLowercased) ?? false) ||
                (movie.actors?.lowercased().contains(searchTextLowercased) ?? false) ||
                (movie.year?.lowercased().contains(searchTextLowercased) ?? false)
            }
        } else {
            filteredMovies = movies
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredMovies = movies
        filteredMovies = movies
        tableView.reloadData()
    }
}
extension ViewController {
    
    @objc func tapSection(sender: UIButton) {
        self.arrayHeader[sender.tag].isExpanded.toggle()
        self.tableView.reloadSections([sender.tag], with: .fade)
    }
    
    
    func getUniqueYears() -> [String] {
        let years = movies.compactMap { $0.year }
        let uniqueYears = Set(years)
        return Array(uniqueYears).sorted()
    }
    
    func getUniqueGenres() -> [String] {
        let genres = movies.flatMap { $0.genre?.components(separatedBy: ", ") ?? [] }
        let uniqueGenres = Set(genres)
        return Array(uniqueGenres).sorted()
    }
    
    func getUniqueDirectors() -> [String] {
        let directors = movies.flatMap { $0.director?.components(separatedBy: ", ") ?? [] }
        let uniqueDirectors = Set(directors)
        return Array(uniqueDirectors).sorted()
    }
    
    func getUniqueActors() -> [String] {
        let actors = movies.flatMap { $0.actors?.components(separatedBy: ", ") ?? [] }
        let uniqueActors = Set(actors)
        return Array(uniqueActors).sorted()
    }
    
    func navigateVC(movieData: [MovieDataModel]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilteredMoviesViewController") as? FilteredMoviesViewController
        storyboard?.movies = movieData
        navigationController?.pushViewController(storyboard ?? UIViewController(), animated: true)
    }
}

