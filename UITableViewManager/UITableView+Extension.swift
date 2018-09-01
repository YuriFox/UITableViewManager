//
//  UITableView+Extension.swift
//  YFTableViewManager
//
//  Created by Yuri Fox on 17.07.2018.
//  Copyright © 2018 Yuri Lysytsia. All rights reserved.
//

import class UIKit.UITableView

fileprivate var InstanceKey = "UITableViewManagerInstance"

public extension UITableView {
    
    /// UITableViewManager instance of this table view. A new one will be created if not exist.
    var manager: UITableViewManager {
        set {
            objc_setAssociatedObject(self, &InstanceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let m = objc_getAssociatedObject(self, &InstanceKey) as? UITableViewManager {
                return m
            } else {
                let manager = UITableViewManager(tableView: self)
                self.manager = manager
                return manager
            }
        }
        
    }
    
}

// MARK: - Reusable
public extension UITableView {
    
    func reusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let id = String(describing: T.self)
        return self.dequeueReusableCell(withIdentifier: id, for: indexPath) as! T
    }
    
    func reusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T? {
        let id = String(describing: T.self)
        return self.dequeueReusableHeaderFooterView(withIdentifier: id) as? T
    }
    
}

//fileprivate var LoadingRowKey = "UITableViewLoadingRowKey"

// MARK: - Loading Cell
public extension UITableView {
    
//    public private(set) var loadingRow: UITableViewRow {
//        set {
//            objc_setAssociatedObject(self, &LoadingRowKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            if let row = objc_getAssociatedObject(self, &LoadingRowKey) as? UITableViewRow {
//                return row
//            } else {
//                return self.registerLoadingRow()
//            }
//        }
//    }
    
//    private func registerLoadingRow() -> UITableViewRow {
//        let name = String(describing: UILoadingTableViewCell.self)
//        let nib = UINib(nibName: name, bundle: .main)
//        self.register(nib, forCellReuseIdentifier: name)
//
//        let row = UITableViewRow.loading(style: .gray)
//        self.loadingRow = row
////        self.addRow(row)
//        return row
//    }
//
//    public func showLoadingRow() {
//        self.sections.forEach { (section) in
//            section.rows.forEach { (row) in
////                row.isVisible = row == self.loadingRow
//            }
//        }
//        self.reloadData()
//    }
    
}

//    func infoCell(text: String, for indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.reusableCell(UITableViewCell.self, for: indexPath)
//        cell.selectionStyle = .none
//        cell.backgroundColor = self.backgroundColor
//        cell.contentView.backgroundColor = self.backgroundColor
//        cell.textLabel?.numberOfLines = 2
//        cell.textLabel?.textAlignment = .center
//        cell.textLabel?.textColor = .HCDarkGray
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        cell.textLabel?.text = text
//        return cell
//    }
