//
//  C8HSelectCasinoViewController.swift
//  ledge
//
//  Created by robert on 9/18/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit

protocol C8HSelectCasinoProtocol {
  func setCasinoFromSelectCasino(_ casino: Casino)
}

class C8HSelectCasinoViewController: UIViewController {
  // MARK: - Data for table
  var casinos: [Casino]?
  var delegate: C8HSelectCasinoProtocol?
  var selectedCasino : Casino?
  
  // MARK: - Outlets
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var selectButton: UIButton!
  
  convenience init(nibName: String, bundle: Bundle?, casinos: [Casino]?, delegate: C8HSelectCasinoProtocol){
    self.init(nibName: nibName, bundle: bundle)
    self.casinos = casinos
    self.delegate = delegate
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Actions
  
  @IBAction func selectCasino(_ sender: Any) {
    guard let casino = selectedCasino else {return}
    delegate?.setCasinoFromSelectCasino(casino)
    self.dismiss(animated: true, completion: nil)
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

extension C8HSelectCasinoViewController: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let casinos = casinos else {return 0}
    return casinos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "casinoCells")
    guard let casinos = casinos, let label = cell.textLabel, let detailLabel = cell.detailTextLabel else {return cell}
    
    label.text = casinos[indexPath.row].casinoName
    detailLabel.text = casinos[indexPath.row].casinoCode
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    guard let casino = casinos?[indexPath.row] else {return}
    
    selectedCasino = casino
    debugPrint("Did select row with title \(casino.casinoName)")
    selectButton.alpha = 1.0
    selectButton.isEnabled = true
  }
  
  
}
