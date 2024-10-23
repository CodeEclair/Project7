//
//  ViewController.swift
//  Project7
//
//  Created by Валерия Беленко on 23/10/2024.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    
   override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Shopping List"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
       let firstRightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemToList))
       
       let secondRightButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
       
       navigationItem.rightBarButtonItems = [secondRightButton, firstRightButton]
    }
    
    @objc func refreshList() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addItemToList() {
        let ac = UIAlertController(title: "Add item to the list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text?.lowercased() else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ item: String?) {
        var allowedCharacterSet = CharacterSet.letters
            allowedCharacterSet.formUnion(.decimalDigits)
            allowedCharacterSet.insert("-")
        
        guard let item = item?.trimmingCharacters(in: .whitespacesAndNewlines), !item.isEmpty,
              item.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil else {
            let ac = UIAlertController(title: "Item cannot be added", message: "Please enter a valid item name.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        
        
        let capitalizedItem = item.capitalized
        shoppingList.insert(capitalizedItem, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func shareTapped() {
        let list = shoppingList.joined(separator: "\n")
        
        
        let vc = UIActivityViewController(activityItems: [title!, list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

