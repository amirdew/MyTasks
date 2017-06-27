//
//  HomeViewController.swift
//  MyTasks
//
//  Created by Amir on 6/26/17.
//  Copyright © 2017 Amir Khorsandi. All rights reserved.
//

import UIKit
import CoreStore

class HomeViewController: UIViewController, ListObserver, UITableViewDelegate, UITableViewDataSource, TaskTableViewCellDelegate {
    
    
    @IBOutlet weak var emptyListView: UIView!
    @IBOutlet weak var tableViewWrapper: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewMaskAdded = false
    var listMonitor:ListMonitor<Task>!
    var selectedIndexPath:IndexPath!
    
    
    
    // MARK: - ViewControlelr
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupTaskMonitor()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //remove mask
        tableViewMaskAdded = false
        tableViewWrapper.layer.mask = nil
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addMaskGradiantFotTableView()
        getUserNameIfNeeded()
        
        emptyListView.isHidden = tableView.numberOfRows(inSection: 0) > 0
    }
    
    
    
    //MARK: - setup and initialize
    
    
    func setupTableView(){
        
        let nib = UINib(nibName: "TaskTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "TaskTableViewCell")
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 70, left: 0, bottom: 90, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 90, right: 0)
        tableView.tableFooterView = UIView(frame:.zero)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
    
    
    func setupTaskMonitor(){
    
        let dataStack = StoreHelper.sharedInstance.dataStack
        listMonitor = dataStack.monitorList(From<Task>(), OrderBy(.descending("date")))
        listMonitor.addObserver(self)
    }
    
    
    
    
    func addMaskGradiantFotTableView(){
    
        
        // add mask gradiant for tableview
        if !tableViewMaskAdded {
            
            tableViewMaskAdded = true
            
            let gradient = CAGradientLayer()
            gradient.frame = self.tableViewWrapper.bounds
            gradient.colors = [
                UIColor.clear.cgColor,
                UIColor.clear.cgColor,
                UIColor.white.cgColor,
                UIColor.white.cgColor,
                UIColor.clear.cgColor,
                UIColor.clear.cgColor,
            ]
            
            let top = tableView.contentInset.top/tableViewWrapper.bounds.height
            let bottom = tableView.contentInset.bottom/tableViewWrapper.bounds.height
            gradient.locations = [0.0,
                                  NSNumber(value:Float(top/2)),
                                  NSNumber(value:Float(top)),
                                  NSNumber(value:Float(1-bottom)),
                                  NSNumber(value:Float(1-bottom/2)),
                                  1]
            tableViewWrapper.layer.mask = gradient
            var bounds = tableViewWrapper.layer.mask?.bounds
            bounds?.size.height += tableView.contentInset.bottom*2
            tableViewWrapper.layer.mask?.bounds = bounds!
            
            let when = DispatchTime.now() + 0.08
            
            DispatchQueue.main.asyncAfter(deadline: when) {
                CATransaction.begin()
                CATransaction.setValue(NSNumber(value:0.5), forKey: kCATransactionAnimationDuration)
                self.tableViewWrapper.layer.mask?.bounds = self.tableViewWrapper.bounds
                CATransaction.commit()
            }
            
        }
    
    
    }
    
    
    // MARK: - user name
    
    
    func getUserNameIfNeeded(){
        
        if UtilityHelper.getUserName().lengthOfBytes(using: .utf8) > 0{
            return
        }
    
        let alert = UIAlertController(title: "What is your name?", message: "(Author name)", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
            if let textField = alert.textFields?.first{
               
                UtilityHelper.setUserName(textField.text!)
                self.getUserNameIfNeeded()
            }
        }))
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Your name"
        })
        self.present(alert, animated: true)
    }
  
    
    
    // MARK: - ListObserver
    
    func listMonitorWillChange(_ monitor: ListMonitor<Task>) {
    
    }
    
    func listMonitorDidChange(_ monitor: ListMonitor<Task>) {
        
        //only if new object inserted or edit, delete handled by controller
        if monitor.numberOfObjects() >= tableView.numberOfRows(inSection: 0){
            tableView.reloadData()
        }
        
        emptyListView.isHidden = monitor.numberOfObjects() > 0
        
        
    }
    
    func listMonitorDidRefetch(_ monitor: ListMonitor<Task>) {
        
        self.listMonitorDidChange(monitor)
    }
    
    
    // MARK: - TaskTableViewCell Delegate
    
    func taskTableViewCellEditButtonAction(cell: TaskTableViewCell) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditTaskViewController") as? AddEditTaskViewController{
        
            vc.editTask = cell.task
            self.present(vc, animated: true, completion: nil)
        }
        
        selectedIndexPath = nil
        
    }
    
    func taskTableViewCellRemoveButtonAction(cell: TaskTableViewCell) {
        
        TaskRepository.remove(task: cell.task)
        tableView.deleteRows(at: [cell.indexPath], with: .right)
        selectedIndexPath = nil
        
    }
    
    

    // MARK: - UITableView
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let listMonitor = self.listMonitor{
            return listMonitor.numberOfObjectsInSection(0)
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedIndexPath = selectedIndexPath{
            if selectedIndexPath.row == indexPath.row{
                self.selectedIndexPath = nil
                tableView.reloadRows(at: [indexPath], with: .automatic)
                return
            }
            else{ 
                self.selectedIndexPath = nil
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            }
        }
        
        
        selectedIndexPath = indexPath
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        var isExpanded = false
        
        if let selectedIndexPath = selectedIndexPath{
            isExpanded = selectedIndexPath.row == indexPath.row
        }
        
        if let task = (self.listMonitor?[indexPath]){
            cell.setCellData(task: task, indexPath: indexPath, isExpanded: isExpanded, delegate: self)
        }
        
        return cell
    }

}

