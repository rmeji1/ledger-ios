//
//  C8HAddTableViewController.swift
//  ledge
//
//  Created by robert on 9/6/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

class C8HAddGameViewController: UIViewController {
  
  var casinoId : Int64?
  
  @IBOutlet weak var addGameView: C8HTwoLabelModalView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    addGameView.cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
    addGameView.submitButton.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
    
    // round corners
    addGameView.roundCorners(by: 10)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /**
    Actions for view
   */
  @IBAction func cancel(_ sender: UIButton){
    debugPrint("Cancel pressed.")
    dismiss(animated: true)
  }
 
  @IBAction func submit(_ sender: UIButton){
    debugPrint("submit pressed.")
    if let game = createGame() {
      _ = C8HGameStore().save(game: game).done{
        debugPrint($0)
        self.dismiss(animated: true)
      }
    }
  }
  
  func createGame() -> Game?{
    if let casinoId = casinoId{
      return Game(id: nil, description: addGameView.name!, gega: addGameView.gega!, casinoId: casinoId)
    }
    return nil
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

//extension C8HAddTableViewController : UITableViewDataSource, UITableViewDelegate{
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return 1
//  }
//  
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 2
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
//    cell.textLabel?.text = "This is row \(indexPath.row)"
//    return cell
//  }
//  
//  
//}
