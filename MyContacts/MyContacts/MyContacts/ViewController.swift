//
//  ViewController.swift
//  MyContacts
//
//  Created by cis290 on 10/8/18.
//  Copyright © 2018 Rock Valley College. All rights reserved.
//

import UIKit
import CoreData;

class ViewController: UIViewController {
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnEmail: UITextField!
    @IBOutlet weak var btnPhone: UITextField!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    var contactdb:NSManagedObject!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (contactdb != nil) {
            txtFullname.text = contactdb.value(forKey: "fullname") as? String
            txtEmail.text = contactdb.value(forKey: "email") as? String
            txtPhone.text = contactdb.value(forKey: "phone") as? String
            
            btnCall.isHidden = true
            btnEdit.isHidden = false
            btnSave.isHidden = true
            
            txtEmail.isEnabled = false
            txtPhone.isEnabled = false
            txtFullname.isEnabled = false
            
            btnSave.setTitle("Update", for: UIControlState())
        }
        
        btnCall.isHidden = true
        btnEdit.isHidden = true
        txtEmail.isEnabled = true
        txtPhone.isEnabled = true
        txtEmail.isEnabled = true
        
        txtFullname.becomeFirstResponder()
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnSave_Click(_ sender: Any) {
        if (contactdb != nil) {
            contactdb.setValue(txtFullname.text, forKey: "fullname")
            contactdb.setValue(txtEmail.text, forKey: "email")
            contactdb.setValue(txtPhone.text, forKey: "phone")
        } else {
            let entityDescription = NSEntityDescription.entity(forEntityName: "Contact", in: managedObjectContext)
            let contact = Contact(entity: entityDescription!, insertInto: managedObjectContext)
            contact.fullname = txtFullname.text!
            contact.email = txtEmail.text!
            contact.phone = txtPhone.text!
        }
        
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let ex as NSError {
            error = ex
        }
        
        if (error == nil) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnEdit_Click(_ sender: Any) {
        txtFullname.isEnabled = true
        txtEmail.isEnabled = true
        txtPhone.isEnabled = true
        
        btnSave.isHidden = false
        btnEdit.isHidden = false
        
        txtFullname.becomeFirstResponder();
    }
    
    @IBAction func btnCall_Click(_ sender: Any) {
        if (txtPhone.text != "") {
            return;
        }
 
        let formattedNumber = txtPhone.text!.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        let phoneURL = "tel://\(formattedNumber)"
        let url:URL! = URL(string: phoneURL)
        
        UIApplication.shared.open(url)
        
        print("Calling \(formattedNumber)")
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        if (touches.first as UITouch?) != nil {
            dismissKeyboard()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @objc func dismissKeyboard() {
        txtFullname.endEditing(true)
        txtEmail.endEditing(true)
        txtPhone.endEditing(true)
    }
}

