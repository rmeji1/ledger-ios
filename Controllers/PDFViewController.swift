//
//  PDFViewController.swift
//  ledge
//
//  Created by robert on 6/12/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
  
  var pdfdocument: PDFDocument?
  
  var pdfview: PDFView!
  var ledger: Ledger!
  
  @IBOutlet weak var printView : UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //makeNavigationBarBlackColor()
    navigationController?.navigationBar.backgroundColor = UIColor.black
    let barView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:UIApplication.shared.statusBarFrame.height))
    barView.backgroundColor = UIColor.black
    view.addSubview(barView)
    
    addLogo()
    let ledgerPrintView = LedgerPrintView.instanceFromNib();
    // edit all the things needed in the view.
    addLedgerData(to: ledgerPrintView)

    // Do any additional setup after loading the view.
    pdfview = PDFView(frame: CGRect(x: 0, y: 0, width: printView.frame.width, height: printView.frame.height))
    pdfdocument = PDFDocument()
    let pdfPage = PDFPage(image: ledgerPrintView.asImage());
    pdfdocument?.insert(pdfPage!, at: 0)
    pdfview.document = pdfdocument
    
    pdfview.displayMode = .singlePage
    //pdfview.displayDirection = .horizontal
    //pdfview.autoScales = true
    
    printView.addSubview(pdfview)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func addLedgerData(to ledgerPrintView: UIView){
    if
      let casinoName = ledgerPrintView.viewWithTag(33) as? UILabel,
      let primaryOwner = ledgerPrintView.viewWithTag(34) as? UILabel,
      let  dateIn = ledgerPrintView.viewWithTag(1) as? UILabel,
      let  timeIn = ledgerPrintView.viewWithTag(2) as? UILabel,
      let  dateOut = ledgerPrintView.viewWithTag(3) as? UILabel,
      let  timeOut = ledgerPrintView.viewWithTag(4) as? UILabel,
      let name = ledgerPrintView.viewWithTag(5) as? UILabel,
      let badge = ledgerPrintView.viewWithTag(6) as? UILabel,
      let gega = ledgerPrintView.viewWithTag(7) as? UILabel,
      let gameTable = ledgerPrintView.viewWithTag(8) as? UILabel,
      let ledgerId = ledgerPrintView.viewWithTag(35) as? UILabel
      {
      casinoName.text = ledger.casinoDetails.casinoName
      primaryOwner.text = "Blackstone Gaming, Inc."
      
      if let date = ledger.ledgerDate?.startDateTime?.split(separator: " "){
        dateIn.text = String(date[0])
        timeIn.text = "\(String(date[1])) \(String(date[2]))"
      }
      if let date = ledger.ledgerDate?.endDateTime?.split(separator: " "){
        dateOut.text = String(date[0])
        timeOut.text = "\(String(date[1])) \(String(date[2]))"
      }
      
      name.text = ledger.empDetails?.name
      badge.text = ledger.empDetails?.badgeNumber
      gega.text = ledger.tableDetails?.gega
      
      if
        let game = ledger.tableDetails?.game,
        let number = ledger.tableDetails?.number{
         gameTable.text = "\(game) Table \(number)"
      }

      ledgerId.text = ledger.ledgerId
      displaySignature(to: ledgerPrintView)
      displayTotals(to: ledgerPrintView)
        displayTransactions(to: ledgerPrintView)
      // function to display transactions
    }
  }
  
  func displayTotals(to ledgerPrintView : UIView){
    if
      let begBalance = ledgerPrintView.viewWithTag(36) as? UILabel,
      let totalAdditions = ledgerPrintView.viewWithTag(37) as? UILabel,
      let totalSubtractions = ledgerPrintView.viewWithTag(38) as? UILabel,
      let endBalance = ledgerPrintView.viewWithTag(39) as? UILabel,
      let result = ledgerPrintView.viewWithTag(40) as? UILabel
    {
      begBalance.text = ledger.beginningBalance?.description
      totalAdditions.text = ledger.additionsTotal?.description
      totalSubtractions.text = ledger.subtractionTotal?.description
      endBalance.text = " "
      //
      result.text = (ledger.beginningBalance! + ledger.additionsTotal! - ledger.subtractionTotal!).description
    }
  }
  
  func displayTransactions(to ledgerPrintView: UIView){
    var addFromIndex = 9
    var addAmountIndex  = 13
    var addInitialIndex = 17
    
    var subFromIndex = 21
    var subAmountIndex  = 25
    var subInitialIndex = 29
    
    if let transactions = ledger.transactions {
      for transaction in transactions{
        switch transaction.type!{
        case Transaction.Transaction_Type.ADDITION:
          if let amountLabel = ledgerPrintView.viewWithTag(addAmountIndex) as? UILabel,
            let initialLabel = ledgerPrintView.viewWithTag(addInitialIndex) as? UILabel,
            let fromLabel = ledgerPrintView.viewWithTag(addFromIndex) as? UILabel{
            fromLabel.text = "Podium"
            amountLabel.text = transaction.amount.description
            initialLabel.text = "\(transaction.employeeInitials)/\(transaction.managerInitials)"
            
            addFromIndex += 1
            addAmountIndex += 1
            addInitialIndex += 1
          }
          
          break
        case Transaction.Transaction_Type.SUBTRACTION:
          if let amountLabel = ledgerPrintView.viewWithTag(subAmountIndex) as? UILabel,
            let initialLabel = ledgerPrintView.viewWithTag(subInitialIndex) as? UILabel,
            let fromLabel = ledgerPrintView.viewWithTag(subFromIndex) as? UILabel{
            fromLabel.text = "Podium"
            amountLabel.text = transaction.amount.description
            initialLabel.text = "\(transaction.employeeInitials)/\(transaction.managerInitials)"
            
            subFromIndex += 1
            subAmountIndex += 1
            subInitialIndex += 1
          }
          
          break
        }
      }
    }
  }
  
  func displaySignature(to ledgerPrintView: UIView){
    if
      let decodedData = Data(base64Encoded: ledger.employeeSignature! , options: .ignoreUnknownCharacters),
      let employeeSignature = ledgerPrintView.viewWithTag(41) as? UIImageView
    {
      let image = UIImage(data: decodedData)
      employeeSignature.image = image
    }
  }
  
  func share(_ document: PDFDocument?) {
    guard let data = document?.dataRepresentation() else { return }
    let vc = UIActivityViewController(activityItems: [data], applicationActivities: [])
    vc.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
      if !completed {
        // User canceled
        return
      }
      // User completed activity
      self.navigationController?.popViewController(animated: true)
      self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    present(vc, animated: true)
   // , completion: {       })
  }
  
  @IBAction func shareButton(_ sender: UIButton){
    share(pdfdocument)
  }
  /**
   Add logo to navigation bar.
   */
  func addLogo(){
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 24.151))
    imageView.contentMode = .scaleAspectFit
    
    let image = UIImage(named: "blackstone-logo-white.png")
    imageView.image = image
    logoContainer.addSubview(imageView)
    navigationItem.titleView = logoContainer
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
