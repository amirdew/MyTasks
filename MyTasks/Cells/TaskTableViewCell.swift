//
//  TaskTableViewCell.swift
//  MyTasks
//
//  Created by amir on 6/27/17.
//  Copyright © 2017 Amir Khorsandi. All rights reserved.
//

import UIKit

protocol TaskTableViewCellDelegate {
    func taskTableViewCellRemoveButtonAction(cell:TaskTableViewCell)
    func taskTableViewCellEditButtonAction(cell:TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {

    

    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var colorCircleView: UIView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var fullViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var ButtonsView: UIView!
    
    
    @IBOutlet weak var taskNameFullLabel: UILabel!
    @IBOutlet weak var taskDescriptionFullLabel: UILabel!
    @IBOutlet weak var taskDateFullLabel: UILabel!
    @IBOutlet weak var taskAuthorFullLabel: UILabel!
    
    var task:Task!
    var delegate:TaskTableViewCellDelegate!
    var indexPath:IndexPath!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code 
        self.selectionStyle = .none
        whiteView.layer.cornerRadius = 4
        whiteView.layer.shadowColor = UIColor.black.cgColor
        whiteView.layer.shadowOffset = CGSize(width: 0, height: 0)
        whiteView.layer.shadowRadius = 10
        whiteView.layer.shadowOpacity = 0.06
        whiteView.layer.shouldRasterize = true
        whiteView.layer.rasterizationScale = UIScreen.main.scale
        fullView.layer.cornerRadius = 4
        
        colorCircleView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - buttons action
    
    
    @IBAction func removeButtonAction(_ sender: Any) {
        
        if let delegate = self.delegate {
            delegate.taskTableViewCellRemoveButtonAction(cell: self)
        }
        
    }
    
    
    @IBAction func editButtonAction(_ sender: Any) {
        
        if let delegate = self.delegate {
            delegate.taskTableViewCellEditButtonAction(cell: self)
        }
    }
    
    
    
    //MARK: - fill data
    
    func setCellData(task:Task, indexPath:IndexPath, isExpanded:Bool, delegate:TaskTableViewCellDelegate){
        
        
        self.task = task
        self.indexPath = indexPath
        self.delegate = delegate
        
        
        
        let instanceURL = task.objectID.uriRepresentation()
        let instanceId = Int(instanceURL.lastPathComponent.replacingOccurrences(of: "p", with: ""))
        
        
        //set details in normal view
        colorCircleView.backgroundColor = getColorByNumber(number: instanceId!)
        taskNameLabel.text = task.name
        dateLabel.text = UtilityHelper.getHumanDateString(date: task.date!)
        authorNameLabel.text = "By " + task.author!
        
        
        
        //set details in full view
        
        taskNameFullLabel.text = taskNameLabel.text
        taskDescriptionFullLabel.text = task.desc
        taskDateFullLabel.text = dateLabel.text
        taskAuthorFullLabel.text = authorNameLabel.text
        
        
        
        
        //handle expanded
        
        fullViewHeightConstrain.priority = isExpanded ? 800:999
        fullViewBottomConstraint.priority =  isExpanded ? 999:800
        
        fullView.isHidden = !isExpanded
        ButtonsView.isHidden = !isExpanded
        
        bottomSpaceConstraint.constant = isExpanded ? 35:12
        
        
    }
    
    
    
    func getColorByNumber(number: Int) -> UIColor{
        
        let colors = [
        UIColor(red:1.00, green:0.69, blue:0.00, alpha:1.00),
        UIColor(red:1.00, green:0.00, blue:0.62, alpha:1.00),
        UIColor(red:0.66, green:1.00, blue:0.00, alpha:1.00),
        UIColor(red:0.00, green:0.89, blue:1.00, alpha:1.00),
        UIColor(red:0.55, green:0.34, blue:0.16, alpha:1.00),
        UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.00)
        ]
        
        let index: Int = number % colors.count
        
        return colors[index]
    }
    
    
    
    
}
