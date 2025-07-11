//
//  ViewController.swift
//  ios101-lab5-flix1
//

import UIKit
import NukeExtensions

// TODO: Add table view data source conformance
class ViewController: UIViewController {
    
    
    // TODO: Add table view outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // TODO: Add property to store fetched movies array
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Assign table view data source
        tableView.dataSource = self
        
        fetchMovies()
    }
    
    // Fetches a list of popular movies from the TMDB API
    private func fetchMovies() {
        
        // URL for the TMDB Get Popular movies endpoint: https://developers.themoviedb.org/3/movies/get-popular-movies
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=b1446bbf3b4c705c6d35e7c67f59c413&language=en-US&page=1")!
        
        // ---
        // Create the URL Session to execute a network request given the above url in order to fetch our movie data.
        // https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
        // ---
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Check for errors
            if let error = error {
                print("🚨 Request failed: \(error.localizedDescription)")
                return
            }
            
            // Check for server errors
            // Make sure the response is within the `200-299` range (the standard range for a successful response).
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("🚨 Server Error: response: \(String(describing: response))")
                return
            }
            
            // Check for data
            guard let data = data else {
                print("🚨 No data returned from request")
                return
            }
            
            // The JSONDecoder's decode function can throw an error. To handle any errors we can wrap it in a `do catch` block.
            do {
                
                // Decode the JSON data into our custom `MovieResponse` model.
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                
                // Access the array of movies
                let movies = movieResponse.results
                
                // Run any code that will update UI on the main thread.
                DispatchQueue.main.async { [weak self] in
                    
                    // We have movies! Do something with them!
                    print("✅ SUCCESS!!! Fetched \(movies.count) movies")
                    
                    // Iterate over all movies and print out their details.
                    for movie in movies {
                        print("🍿 MOVIE ------------------")
                        print("Title: \(movie.title)")
                        print("Overview: \(movie.overview)")
                    }
                    
                    // TODO: Store movies in the `movies` property on the view controller
                    print("🍏 Fetched and stored \(movies.count) movies")
                    self?.movies = movies
                    self?.tableView.reloadData()
                    
                }
            } catch {
                print("🚨 Error decoding JSON data into Movie Response: \(error.localizedDescription)")
                return
            }
        }
        
        // Don't forget to run the session!
        session.resume()
    }
    
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows for the table.
        //        return 50
        print("🍏 numberOfRowsInSection called with movies count: \(movies.count)")
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create the cell
        //        let cell = UITableViewCell()
        
        // Configure the cell (i.e. update UI elements like labels, image views, etc.)
        // Get the row where the cell will be placed using the `row` property on the passed in `indexPath` (i.e., `indexPath.row`)
        //        cell.textLabel?.text = "Row \(indexPath.row)"
        
        // Get the movie-associated table view row
        //        let movie = movies[indexPath.row]
        
        // Configure the cell (i.e., update UI elements like labels, image views, etc.)
        //        cell.textLabel?.text = movie.title
        
        
        // Get a reusable cell
        // Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table. This helps optimize table view performance as the app only needs to create enough cells to fill the screen and reuse cells that scroll off the screen instead of creating new ones.
        // The identifier references the identifier you set for the cell previously in the storyboard.
        // The `dequeueReusableCell` method returns a regular `UITableViewCell`, so we must cast it as our custom cell (i.e., `as! MovieCell`) to access the custom properties you added to the cell.
        print("🍏 cellForRowAt called for row: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        // Get the movie associated table view row
        let movie = movies[indexPath.row]
        
        // Configure the cell (i.e., update UI elements like labels, image views, etc.)
        
        // Unwrap the optional poster path
        if let posterPath = movie.poster_path,
           
            // Create a url by appending the poster path to the base url. https://developers.themoviedb.org/3/getting-started/images
           let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath) {
            
            // Use the Nuke library's load image function to (async) fetch and load the image from the image URL.
            NukeExtensions.loadImage(with: imageUrl, into: cell.posterImageView)
        }
        
        // Set the text on the labels
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = movie.overview
        
        // Return the cell for use in the respective table view row
        return cell
    }
}
