//
//  TVCListadoRepositorios.swift
//  pruebaTecnica
//
//  Created by Andrea Roveres on 23/7/18.
//  Copyright © 2018 andreaRoveres. All rights reserved.
//

import UIKit

class TableViewControllerRepositoriesList: UITableViewController, UISearchBarDelegate, GitHubManagerDelegate {
    @IBOutlet weak var myTable:UITableView!
    var iRowsToLoad:Int = 0
    var iRowSelected = 0
    var avatarURL:String = ""
    var isSearching:Bool = false
    var searchAllPublicRepos:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        //Descargo los repositorios públicos de GitHub
        Manager.search(url: Manager.URL_ALL_PUBLIC_REPOSITORIES, delegate: self, searchAllPublicRepos: true)
        createSearchBar()
        }
    
    func createSearchBar(){
        let searchBar:UISearchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Busca un proyecto público en GitHub"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    // MARK: - Response delegate
    func repositoriesData(downloaded: Bool) {
        isSearching = false
        if downloaded == true {
            iRowsToLoad = DataHolder.sharedInstance.resultsDataSearch.count
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchAllPublicRepos == true){
            searchAllPublicRepos = false
        }
        let textSearch = searchBar.text
        if let textSearchUnwrapped = textSearch {
            let noSpacesSearch = textSearchUnwrapped.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            DataHolder.sharedInstance.resultsDataSearch.removeAll()
            let urlFinalSearch = URL(string: Manager.URL_PUBLIC_REPOSITORIES_SEARCH + noSpacesSearch)
            Manager.search(url: urlFinalSearch, delegate: self, searchAllPublicRepos: false)
        }
    }
 
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iRowsToLoad
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCellPrototype = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! TableViewCellPrototype
            DispatchQueue.global(qos: .background).async {
                if let avatar_urlUnwrapped = DataHolder.sharedInstance.resultsDataSearch[indexPath.row].owner?.avatar_url ,let urlUnwrapped:URL = URL(string: avatar_urlUnwrapped) {
                    let data = try? Data(contentsOf: urlUnwrapped)
                    DispatchQueue.main.async {
                        if let dataUnwrapped = data {
                            cell.imageGitHubUser?.image = UIImage(data: dataUnwrapped)
                        }
                    }
                }
            }
        cell.lblNameRepo?.text = DataHolder.sharedInstance.resultsDataSearch[indexPath.row].full_name
        cell.lblDescriptionRepo?.text = DataHolder.sharedInstance.resultsDataSearch[indexPath.row].description
        if(indexPath.row ==  DataHolder.sharedInstance.resultsDataSearch.count - 1 && !isSearching && !searchAllPublicRepos == false && indexPath.row > 0){
            isSearching = true
            Manager.search(url: Manager.nextPageURL, delegate: self, searchAllPublicRepos: false)
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        iRowSelected = indexPath.row
        self.performSegue(withIdentifier: "showdetails", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewControllerRepositoryDetails
        destination.iRowSelected = iRowSelected
    }
}
