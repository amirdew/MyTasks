//
//  AddEditTaskViewController.swift
//  MyTasks
//
//  Created by amir on 6/27/17.
//  Copyright © 2017 Amir Khorsandi. All rights reserved.
//

import UIKit

class AddEditTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pageTitleLabel: UILabel!
    
    var editTask:Task!
    
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var whiteViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmButtonCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var datePicker:UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupData()
        
        //add notification to watch keyboard frame
        NotificationCenter.default.addObserver(self, selector: #selector(keyboarFrameChange(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        if (editTask) != nil{
            pageTitleLabel.text = "Edit Task"
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Buttons action
    
  
    @IBAction func cancelButtonAction(_ sender: Any) {
      
        (sender as! UIButton).superview?.bringSubview(toFront: sender as! UIButton)
        
        dismiss()
    }
    
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        
        //Validation: check name not empty
        if (nameTextField.text?.lengthOfBytes(using: .utf8))! < 1 {
            
            let alert = UIAlertController(title: "", message: "Write some text in name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        //edit
        if let editTask = editTask{
            
            editTask.name = nameTextField.text!
            editTask.date = datePicker.date
            editTask.desc = descriptionTextField.text!
            
            TaskRepository.edit(task: editTask)
            
            
        }
        //create new task
        else{
            
            TaskRepository.new(name: nameTextField.text!,
                               date: datePicker.date,
                               author: UtilityHelper.getUserName(),
                               desc: descriptionTextField.text!)
            
        }
        
        
        
        (sender as! UIButton).superview?.bringSubview(toFront: sender as! UIButton)
    
        dismiss()
        
    }
    
    //MARK: -

    
    func dismiss(){
        
        //hide keyboard
        if isInEditing(){
            self.view.endEditing(true)
        }
        
        //animation buttons
        confirmButtonCenterConstraint.constant = 0
        cancelButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.30) {
            self.view.layoutIfNeeded()
        }

        
        //animate and dismiss vc
        let when = DispatchTime.now() + 0.36
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
 
    func isInEditing() -> Bool{
        
        return nameTextField.isEditing || descriptionTextField.isEditing || dateTextField.isEditing
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
    
    
    //MARK: - date picker
    
    func datePickerValueChanged(sender:Any) {
        
        dateTextField.text = UtilityHelper.getHumanDateString(date: datePicker.date)
        
    }
    
    
    func datePickerTextFieldValueChanged(sender:Any){
    
        dateTextField.text = UtilityHelper.getHumanDateString(date: datePicker.date)
    }
    
   
    
    //MARK: - keyboard
    
    
    func keyboarFrameChange(notification:NSNotification){
        
        
        let userInfo = notification.userInfo as! [String:AnyObject]
        
        let topOfKetboard = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue .origin.y
        
        
        var animationDuration:TimeInterval = 0.25
        var animationCurve:UIViewAnimationCurve = .easeOut
        
        if let animDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            
            animationDuration = animDuration.doubleValue
        }
        
        if let animCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            
            animationCurve =  UIViewAnimationCurve.init(rawValue: animCurve.intValue)!
        }
        
        let superHeight = (self.view.frame.size.height)
        var bottomInset = superHeight - topOfKetboard + 50
        
        if bottomInset < 40 {
            bottomInset = 40
        }
        
        whiteViewBottomConstraint.constant = bottomInset
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        self.view.layoutIfNeeded()

        
        UIView.commitAnimations()
        
        
    }

    
    //MARK: - setup
    
    
    func setupData(){
    
        
        if let editTask = editTask{
        
            datePicker.date = editTask.date!
            nameTextField.text = editTask.name
            descriptionTextField.text = editTask.desc
            
        }
        else{
        
            datePicker.date = Date().addingTimeInterval(24*60*60)
        }
        
        
        dateTextField.text = UtilityHelper.getHumanDateString(date: datePicker.date)

    }
    
    
    func setupViews(){
        
        //setup white view
        whiteView.layer.cornerRadius = 4
        whiteView.layer.shadowColor = UIColor.black.cgColor
        whiteView.layer.shadowOffset = CGSize(width: 0, height: 0)
        whiteView.layer.shadowRadius = 10
        whiteView.layer.shadowOpacity = 0.06
        
        
        
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
        dateTextField.tintColor = .clear
        dateTextField.addTarget(self, action: #selector(datePickerTextFieldValueChanged), for: .editingChanged)
    }


}
