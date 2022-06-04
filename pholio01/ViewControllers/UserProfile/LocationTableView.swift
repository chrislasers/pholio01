//
//  LocationTableView.swift
//  pholio01
//
//  Created by Chris  Ransom on 10/7/21.
//  Copyright © 2021 Chris Ransom. All rights reserved.
//

import UIKit

class LocationTableView: UITableView, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Hello World!"
        
        return cell
    }
    
    
    


}
