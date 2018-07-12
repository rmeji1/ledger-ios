//
//  C8HSideMenuTableViewController.swift
//  ledge
//
//  Created by robert on 5/16/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

protocol SideMenuProtocol {
  func logout()
}

class C8HSideMenuTableViewController: UITableViewController {
  var delegate : SideMenuProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Actions
  
  /**
   Revoke an access token.
   
   Call OktaAuth.revoke method to revoke access token. Clear userdefaults and clear
   keychain.
   */
  @IBAction func loggout(_ sender: Any){
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    var retValue = 0
    
    switch section {
    case 0:
      retValue = 2
    case 1:
      retValue = 3
    case 2:
      retValue = 1
    default:
      retValue = 0
    }
    
    return retValue
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var retValue = ""
    
    switch section {
    case 0:
      retValue = "Menu"
    case 1:
      retValue = "Add"
//    case 3:
//      retValue = "Loggout"
    default:
      retValue = ""
    }
    
    return retValue //return your text here, may be

  }
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    switch indexPath.section{
    case 0:
      addLabelTextForSectionOne(forRow: indexPath.row, forCell: cell)
      break
    case 1:
      addLabelTextForSectionTwo(forRow: indexPath.row, forCell: cell)
    case 2:
      addLabelTextForSectionThree(forRow: indexPath.row, forCell: cell)
    default:
      break
    }
   // Configure the cell...
   
   return cell
   }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section{
    case 0:
      break
    case 1:
      break
    case 2:
      cellSelectedInSectionThree(forRow: indexPath.row)
      break
    default:
      break
    }
  }
 
  func cellSelectedInSectionThree(forRow row:Int){
    if row == 0{
      debugPrint("Should loggout user")
      delegate?.logout()
    }
  }
  
  func addLabelTextForSectionOne(forRow row:Int, forCell cell: UITableViewCell){
    guard let textLabel = cell.textLabel else{ return }
    switch row {
    case 0:
      textLabel.text = "About"
    case 1:
      textLabel.text = "Print Ledger"
    default:
      break
    }
  }
  
  func addLabelTextForSectionTwo(forRow row:Int, forCell cell: UITableViewCell){
    guard let textLabel = cell.textLabel else{ return }
    switch row {
    case 0:
      textLabel.text = "Game"
    case 1:
      textLabel.text = "Gega"
    case 2:
      textLabel.text = "Table"
    default:
      break
    }
  }
  
  func addLabelTextForSectionThree(forRow row:Int, forCell cell: UITableViewCell){
    guard let textLabel = cell.textLabel else { return }
    if row == 0{
      textLabel.text = "Logout"
    }
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
