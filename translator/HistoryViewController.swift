//
//  SecondViewController.swift
//  translator
//
//  Created by TONY on 21/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var history: [Translator]! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            history = try CoreDataHelper().load()
        } catch CoreDataErrors.loadError {
            self.alert(title: "Error", message: "Can't load data")
        } catch {
            print("unknown error")
        }
    }


}

extension HistoryViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HistoryToItem", sender: history[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? ItemViewController else {return}
        guard let lts = sender as? Translator else {return}
        
        controller.item = lts
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        
        cell.inputedTextLabel.text = history[indexPath.row].inputedText
        cell.langFromLabel.text = history[indexPath.row].source
        cell.langToLabel.text = history[indexPath.row].target
        
        return cell
    }
    
    
}
