//
//  Github.swift
//  pruebaTecnica
//
//  Created by Andrea on 6/8/18.
//  Copyright © 2018 andreaRoveres. All rights reserved.
//

import Foundation

// MARK: - Data
struct Repositories: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [Repository]
}

struct Repository: Codable {
    let full_name: String
    let owner: User?
    let html_url: String
    let description: String?
}

struct User: Codable {
    let avatar_url: String
}

// MARK: - Header
class Manager {
    static public let URL_ALL_PUBLIC_REPOSITORIES = URL(string: "https://api.github.com/repositories")
    static public let URL_PUBLIC_REPOSITORIES_SEARCH = "https://api.github.com/search/repositories?q="
    static public var nextPageURL:URL?
    
    
    static func search(url: URL!, delegate:GitHubManagerDelegate, searchAllPublicRepos: Bool){
        var downloadedInfo:Repositories?
        var downloadedAllPublicRepos:[Repository]?
        URLSession.shared.dataTask(with: url) { (data:Data?, response: URLResponse?, error: Error?) in
            if (error != nil){
                print(error?.localizedDescription as Any)
                delegate.repositoriesData!(downloaded: false)
            }else{
                do{
                    if let httpResponse = response as? HTTPURLResponse {
                        if let linksHeader = httpResponse.allHeaderFields["Link"] as? String {
                            let subsLinksHeader = Substring(linksHeader)
                            let nextLinkHeader = subsLinksHeader.components(separatedBy: ">").first
                            if var nextLinkHeaderUnwrapped = nextLinkHeader {
                                nextLinkHeaderUnwrapped = String(nextLinkHeaderUnwrapped.dropFirst())
                                nextPageURL = URL(string:nextLinkHeaderUnwrapped)
                            }
                        }
                    }
                        let jsonDec = JSONDecoder()
                        if (searchAllPublicRepos == true){
                            downloadedAllPublicRepos = try jsonDec.decode([Repository].self, from: data!)
                            DataHolder.sharedInstance.resultsDataSearch += downloadedAllPublicRepos!
                        }else if (searchAllPublicRepos == false){
                            downloadedInfo = try jsonDec.decode(Repositories.self, from: data!)
                            DataHolder.sharedInstance.resultsDataSearch += downloadedInfo!.items
                        }
                        delegate.repositoriesData!(downloaded: true)
                } catch {
                    print("Error",error)
                    delegate.repositoriesData!(downloaded: false)
                }
            }
        }.resume()
    }
}

@objc protocol GitHubManagerDelegate{
    @objc optional func repositoriesData(downloaded:Bool)
}
