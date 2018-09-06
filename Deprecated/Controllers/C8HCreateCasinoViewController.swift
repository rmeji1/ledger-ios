//
//  C8HCreateCasinoViewController.swift
//  ledge
//
//  Created by robert on 3/24/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Alamofire

class C8HCreateCasinoViewController: UIViewController {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var casino : C8HCasino?
//    var activeField : UITextField?
    var keyboardHandler: C8HKeyboardHandler?
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        casino = (NSEntityDescription.insertNewObject(forEntityName: "Casino", into: managedObjectContext) as! C8HCasino)
        keyboardHandler = C8HKeyboardHandler(stackView: stackView, scrollView: scrollView, view: self.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    /**
     Should make sure all the componets of a casino are valid.
     Then send casino to server to save. If saved check if user is in the casino.
     When the users the address of the current casino then check if the user is currently in that casino
     If the user is not then tell the address is incorrect., 
     */
    @IBAction func createCasino(_ sender: Any) {
        
//        let repo = C8HCasinoRepository()
//        do{
//            try repo.saveToServer(casino: casino)
//        }catch{
//            debugPrint(error)
//        }
        dismissSelf()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Customization
    func dismissSelf(){
        if let vc = self.presentingViewController as? C8HSetGegaBalAndTableVC{
            vc.viewWillReturnFromCreateCasino(self.casino!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func casinoAddressPresentMap(){
        C8HOverlayViews.indicatorViewWithMessage("Waiting", for: self.view)
        let alert = UIAlertController(style: .alert)
        alert.addLocationPicker() { location in
            guard let lat = location?.location.coordinate.longitude else {return}
            guard let long = location?.location.coordinate.latitude else {return}
            self.casino?.longitude = Float(lat)
            self.casino?.latitude = Float(long)
//            DispatchQueue.main.async {
                self.keyboardHandler?.activeField.text = location?.address
//            }
            
        }
        alert.addAction(title: "Done", style: .cancel)
        C8HOverlayViews.disableOverlayView(for: self.view)
        self.present(alert, animated: true, completion: nil)
    }

}

extension C8HCreateCasinoViewController : UITextFieldDelegate{
    func validateCasinoNameTextfield(_ textField: UITextField){
        guard let text = textField.text, !text.isEmpty else {
            textField.text = "Casino Name"
            return
        }
        casino?.identifer = text
    }
    
    func validateCasinoAddressTextfield(_ textField: UITextField){
        guard let text = textField.text, !text.isEmpty else {
            textField.text = "Casino Address"
            return
        }
    }
    
    func validateBeginningBalanceTextfield(_ textField: UITextField){
        guard let text = textField.text, !text.isEmpty else {
            textField.text = "Beginning Balance"
            return
        }
        
        guard let num = Decimal(string: text) else{
            let title = "Error"
            let message = "Please check beginning balance."
            let alert = UIAlertController(style: .actionSheet, title: title , message: message)
            alert.addAction(title: "Ok", style: .destructive)
            self.present(alert, animated: true, completion: nil)
            return
        }
        casino?.balance = num as NSDecimalNumber
    }
    
    // MARK: UITextFieldDelegate functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardHandler?.enableKeyboardNotification()
        keyboardHandler?.activeField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField.tag == 2 {
            if keyboardHandler?.activeField != nil{
                _ = textFieldShouldReturn((keyboardHandler?.activeField)!)
            }
            keyboardHandler?.activeField = textField
            casinoAddressPresentMap()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        keyboardHandler?.removeObserveNoticationForKeyboard()
        keyboardHandler?.activeField = nil
        return true
    }
    
    // Add any text validation here.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        switch textField.tag{
        case 1: // Casino name
            validateCasinoNameTextfield(textField)
        case 2: // Casino address
            validateCasinoAddressTextfield(textField)
        case 3:
            validateBeginningBalanceTextfield(textField)
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){

    }
}
