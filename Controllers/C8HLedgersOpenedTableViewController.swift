//
//  C8HLedgersOpenedTableViewController.swift
//  ledge
//
//  Created by robert on 7/25/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class C8HLedgersOpenedTableViewController: UITableViewController {
  var ledgers: [Ledger]?
  var casinoId: Int64!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    C8HLedgerStore().getActiveLedgers(for: casinoId).done{ ledgers in
      self.updateTableViewWith(ledgers: ledgers)
      }.catch{ error in
        debugPrint(error)
    }
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    guard let count = ledgers?.count else{ return 0 }
    return count
  }
  
  private func updateTableViewWith(ledgers: [Ledger]){
    self.ledgers = []
    for ledger in ledgers{
      self.ledgers!.append(ledger)
    }
    self.tableView.reloadData()
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    
    // Table number: 0
    if let tableNumber = cell.viewWithTag(6) as? UILabel{
      tableNumber.text = "Table: \(ledgers?[indexPath.row].tableDetails?.number ?? 0)"
    }
    // Tag 1 = GEGA
    if let gegaLabel = cell.viewWithTag(1) as? UILabel{
      gegaLabel.text = "\(ledgers?[indexPath.row].tableDetails?.gega ?? "Error?")"
    }
    
    // Tag 2 = EMP Name
    if let empNameLabel = cell.viewWithTag(2) as? UILabel{
      //FIXME: Need to split this name in order to do this correctly.
      empNameLabel.text = "\(ledgers?[indexPath.row].empDetails?.name ?? "Error?")"
    }
    
    // Tag 3 = Beg Bal
    
    return cell
  }
  
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
