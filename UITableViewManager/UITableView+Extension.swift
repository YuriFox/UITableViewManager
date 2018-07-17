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
     
        if let m = objc_getAssociatedObject(self, &InstanceKey) as? UITableViewManager {
            return m
        } else {
            let manager = UITableViewManager(tableView: self)
            objc_setAssociatedObject(self, &InstanceKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return manager
        }
        
    }
    
    /// Sections of this table view
    var sections: [UITableViewSection] {
        set { self.manager.sections = newValue }
        get { return self.manager.sections }
    }
    
    /// Visible sections of this table view
    var visibleSections: [UITableViewSection] {
        return self.manager.visibleSections
    }
    
    /// Return section at index if exist
    func section(at index: Int, visible: Bool) -> UITableViewSection? {
        return self.manager.section(at: index, visible: visible)
    }
    
    /// Return row at index path if exist
    func row(at indexPath: IndexPath, visible: Bool) -> UITableViewRow? {
        return self.manager.row(at: indexPath, visible: visible)
    }
    
    /// Return index for section if exist
    func index(for section: UITableViewSection, visible: Bool) -> Int? {
        return self.manager.index(for: section, visible: visible)
    }
    
    /// Return index path for row if exist
    func  indexPath(for row: UITableViewRow, visible: Bool) -> IndexPath? {
        return self.manager.indexPath(for: row, visible: visible)
    }
    
    /// Add a new section with UITableViewSection in the table view.
    func addSection(_ section: UITableViewSection) {
        self.manager.addSection(section)
    }
    
    /// Add a new section in the table view.
    public func addSection(visible: Bool) -> UITableViewSection{
        return self.manager.addSection(visible: visible)
    }
    
    /// Add a new row with UITableViewRow in the first section of the table view. A new section will be added if don't exist yet.
    func addRow(_ row: UITableViewRow) {
        self.manager.addRow(row)
    }
    
    /// Add a new row in the first section of the table view. A new section will be added if don't exist yet.
    public func addRow(visible: Bool = true, configurationHandler: @escaping UITableViewRow.ConfigurationHandler) -> UITableViewRow {
        
        return self.manager.addRow(visible: visible, configurationHandler: configurationHandler)
        
    }
    
}

// MARK: - Reusable Cells
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
