//
//  ViewController.swift
//  pruebaTecnica
//
//  Created by Andrea Roveres on 23/7/18.
//  Copyright © 2018 andreaRoveres. All rights reserved.
//

import UIKit

class ViewControllerRepositoryDetails: UIViewController {
    @IBOutlet weak var lblRepoName:UILabel!
    @IBOutlet weak var lblRepoDescription:UILabel!
    @IBOutlet weak var lblHtmlUrl:UILabel!
    @IBOutlet weak var imgProfilePhoto:UIImageView!
    var defaultRepositories:[Repository]?
    var resultsSearchRepositories:Repositories?
    var iRowSelected:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            DispatchQueue.global(qos: .background).async {
                if let avatar_urlUnwrapped = DataHolder.sharedInstance.resultsDataSearch[self.iRowSelected!].owner?.avatar_url, let urlUnwrapped:URL = URL(string: avatar_urlUnwrapped) {
                    let data = try? Data(contentsOf: urlUnwrapped)
                    DispatchQueue.main.async {
                        if let dataUnwrapped = data { self.imgProfilePhoto?.image = UIImage(data: dataUnwrapped) }
                    }
                }
            }
            lblRepoName?.text = DataHolder.sharedInstance.resultsDataSearch[iRowSelected!].full_name
            if let descriptionUnwrapped = DataHolder.sharedInstance.resultsDataSearch[iRowSelected!].description {
                lblRepoDescription?.text = "Descripción: " + descriptionUnwrapped
            }
            lblHtmlUrl?.text = "Repositorio url: " + DataHolder.sharedInstance.resultsDataSearch[iRowSelected!].html_url
    }
}
