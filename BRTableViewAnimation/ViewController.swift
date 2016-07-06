//
//  ViewController.swift
//  BRTableViewAnimation
//
//  Created by 白海瑞 on 16/7/6.
//  Copyright © 2016年 白海瑞. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {

    var dataArray:NSMutableArray = ["one","two","three","four","five","six","seven","eight","night","ten"]
    var snapshotView:UIView?
    var sourceIndexPath :NSIndexPath?
    
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = dataArray[indexPath.row] as? String
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func longPressGestureRecognized(gesture: UILongPressGestureRecognizer) {
        let point = gesture.locationInView(tableView)
        
        let indexPahth = tableView.indexPathForRowAtPoint(point)
        
        switch gesture.state {
        case .Began:
            if let index = indexPahth {
                sourceIndexPath = index
                let cell = tableView.cellForRowAtIndexPath(index)
                snapshotView = self.getSnapshotView(cell!)
                var center = cell?.center
                snapshotView?.center = center!
                snapshotView?.alpha = 0.0
                self.tableView.addSubview(snapshotView!)
                UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: { [unowned self] in
                    center?.y = point.y
                    self.snapshotView?.center = center!
                    self.snapshotView?.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    self.snapshotView?.alpha = 0.9
                    cell?.alpha = 0
                    }, completion: nil)
            }
             break
        case.Changed:
            var center = snapshotView?.center
            center?.y = point.y
            snapshotView?.center = center!

            guard let index = indexPahth else{
                return
            }
            print("indexPaht = \(index.row)")
            print("sourceIndexPath = \(sourceIndexPath?.row)")
            if let sourIndex = sourceIndexPath {
                if !index.isEqual(sourIndex) {
                    dataArray.exchangeObjectAtIndex(sourIndex.row, withObjectAtIndex: index.row)
                   
                    tableView.moveRowAtIndexPath(sourIndex, toIndexPath:index )
                     sourceIndexPath = index
                }
            }
            break
            
        default:
            if let index = sourceIndexPath {
                let cell = tableView.cellForRowAtIndexPath(index)
                UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: { [unowned self] in
                    self.snapshotView?.center = (cell?.center)!
                    self.snapshotView?.transform = CGAffineTransformIdentity
                    self.snapshotView?.alpha = 0
                    cell?.backgroundColor = UIColor.whiteColor()
                    cell?.contentView.backgroundColor = UIColor.whiteColor()
                     cell?.alpha = 1
                    
                    }, completion: {[unowned self](finished:Bool) in
                        self.snapshotView?.removeFromSuperview()
                        self.snapshotView = nil
                    })

            }
            break
        }
    }
    
    @objc private func getSnapshotView(inputView:UIView) -> UIView {
        let  snapView = inputView.snapshotViewAfterScreenUpdates(true)
        snapView.layer.cornerRadius = 0
        snapView.layer.masksToBounds = false
        snapView.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        snapView.layer.shadowRadius = 5.0
        snapView.layer.shadowOpacity = 0.4
        return snapView
    }

}



