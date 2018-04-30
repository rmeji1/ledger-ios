//
//  tableViewContoller.swift
//  ledge
//
//  Created by robert on 2/2/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class C8HTableViewContoller: UITableViewController{
    
//    MARK - DATA
    var MovieData = [["title":"$900", "type":"-", "in1":"RM", "in2":"RS"], ["title":"$400", "type":"+","in1":"RM", "in2":"RS"]]
//    MARK - PROPERTIES
    public enum TableSection: Int{
        case action = 0, addition, subtraction, total
    }
    // This is the size of our header sections that we will use later on.
    let SectionHeaderHeight: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sortData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // If we wanted to always show a section header regardless of whether or not there were rows in it,
        // then uncomment this line below:
//        return SectionHeaderHeight
        
//        if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection], movieData.count > 0 {
//            return SectionHeaderHeight
//        }
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //return TableSection.total.rawValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if let tableSection = TableSection(rawValue: section), let movieData = data[tableSection] {
//            return movieData.count
//        }
        return MovieData.count
    }
    
    // Data variable to track our sorted data.
    var data = [TableSection: [[String: String]]]()
    
    func sortData() {
        data[.addition] = MovieData.filter({ $0["type"] == "-" })
        data[.subtraction] = MovieData.filter({ $0["type"] == "+" })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let image = cell.viewWithTag(10) as? UIImageView {
            if MovieData[indexPath.row]["type"] == "+"{
                image.image = #imageLiteral(resourceName: "plus")
            }else{
                image.image = #imageLiteral(resourceName: "negative")
            }
        }
        if let label = cell.viewWithTag(20) as? UILabel{
            label.text = MovieData[indexPath.row]["title"]
        }
        
        if let label = cell.viewWithTag(30) as? UILabel{
            label.text = MovieData[indexPath.row]["in1"]
        }
        
        if let label = cell.viewWithTag(40) as? UILabel{
            label.text = MovieData[indexPath.row]["in2"]
        }
//         Configure the cell...
       // if let tableSection = TableSection(rawValue: indexPath.section), let movie = //data[tableSection]?[indexPath.row] {
           //cell.textLabel?.text = MovieData[indexPath.row]["title"]
            //cell.detailTextLabel?.text = MovieData[indexPath.row]["type"]
        

      //  }
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
//        view.backgroundColor = UIColor(red: 14.0/255.0, green: 88.0/255.0, blue: 159.0/255.0, alpha: 1)
//        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: tableView.sectionHeaderHeight))
//        label.font = UIFont.boldSystemFont(ofSize: 15)
//        label.textColor = UIColor.white
//        if let tableSection = TableSection(rawValue: section) {
//            switch tableSection {
//            case .addition:
//                label.text = "Addition"
//            case .subtraction:
//                label.text = "Subtraction"
//            default:
//                break
////                label.text = ""
//            }
//        }
//        view.addSubview(label)
//        return view
//    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navVC = segue.destination
        if let vc = navVC as? C8HNumberPadView
        {
            print("Sucessful performaing segue.")
            vc.delegate = self
        }
    }
 
}

extension C8HTableViewContoller: C8HNumberPadDelegate{
    func updateTable(_ data: [String: String]) {
        print("Should be updating")
        MovieData.append(data)
        tableView.reloadData()
    }
}
