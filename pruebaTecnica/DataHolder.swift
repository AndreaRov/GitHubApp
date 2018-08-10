//
//  DataHolder.swift
//  pruebaTecnica
//
//  Created by Andrea Roveres on 24/7/18.
//  Copyright © 2018 andreaRoveres. All rights reserved.
//

import UIKit

class DataHolder: NSObject {
    static let sharedInstance = DataHolder()
    var allPublicRepositories = [Repository]()
    var resultsDataSearch = [Repository]()
}
