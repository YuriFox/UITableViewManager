//
//  UITableViewManager.swift
//  UITableViewManager
//
//  Created by Yuri Lysytsia on 17.07.2018.
//  Copyright © 2018 Yuri Lysytsia. All rights reserved.
//

import class UIKit.UITableView

// TODO:
// 1. UpdateSection(_ section: UITableViewSection, updateBlock: (UITableViewSection.Builder) -> Void)
// 2. UITableViewSection.Builder has tableView, insert, delete, reload

public class UITableViewManager: NSObject {
    
    /// Reference of table view
    public weak var tableView: UITableView?
    
    /// Sections of table view
    public var sections: [UITableViewSection] = []
    
    /// Initialize manager with the reference of table view
    public init(tableView: UITableView) {
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
    }
    
    /// Return true if section exist in table view
    public func containsSection(_ section: UITableViewSection) -> Bool {
        return self.sections.contains(section)
    }
    
    /// Return section at index if exist
    public func section(at index: Int) -> UITableViewSection? {
        return self.sections.element(at: index)
    }
    
    /// Return row at index path if exist
    public func row(at indexPath: IndexPath) -> UITableViewRow? {
        let section = self.section(at: indexPath.section)
        return section?.rows.element(at: indexPath.row)
    }
    
    /// Returns an index of the section if exist
    public func index(for section: UITableViewSection) -> Int? {
        return self.sections.index(of: section)
    }
    
    /// Returns an indexPath of the row if exist
    public func indexPath(for row: UITableViewRow) -> IndexPath? {
        
        for (sectionIndex, section) in self.sections.enumerated() {
            guard let rowIndex = section.index(for: row) else { continue }
            return IndexPath(row: rowIndex, section: sectionIndex)
        }
        
        return nil
        
    }
    
    /// The selected row identifying the index path.
    public var selectedRow: UITableViewRow? {
        guard let indexPath = self.tableView?.indexPathForSelectedRow else { return nil }
        return self.row(at: indexPath)
    }
    
    /// The selected rows identifying the index paths.
    public var selectedRows: [UITableViewRow]? {
        guard let indexPath = self.tableView?.indexPathsForSelectedRows else { return nil }
        return indexPath.compactMap { self.row(at: $0) }
    }
    
    /// Append a new section in the table view with animation.
    public func appendSection(_ section: UITableViewSection, with animation: UITableViewRowAnimation) {
        self.sections.append(section)
        self.updateData {
            let index = self.index(for: section)!
            let indexSet = IndexSet(integer: index)
            self.tableView?.insertSections(indexSet, with: animation)
        }
    }
    
    /// Insert a new section in the table view with animation.
    public func insertSection(_ section: UITableViewSection, at index: Int, with animation: UITableViewRowAnimation) {
        self.sections.insert(section, at: index)
        self.updateData {
            let indexSet = IndexSet(integer: index)
            self.tableView?.insertSections(indexSet, with: animation)
        }
    }

    /// Reload existing section in the table view with animation.
    public func reloadSection(_ section: UITableViewSection, with animation: UITableViewRowAnimation) {
        guard let index = self.index(for: section) else {
            assertionFailure("Section not exist on this table view")
            return
        }
        self.updateData {
            let indexSet = IndexSet(integer: index)
            self.tableView?.reloadSections(indexSet, with: animation)
        }
    }
    
    /// Delete existing section in the table view with animation.
    public func deleteSection(_ section: UITableViewSection, with animation: UITableViewRowAnimation) {
        guard let index = self.index(for: section) else {
            assertionFailure("Section not exist on this table view")
            return
        }
        self.sections.remove(at: index)
        self.updateData {
            let indexSet = IndexSet(integer: index)
            self.tableView?.deleteSections(indexSet, with: animation)
        }
    }
    
    /// Append a new rows in the table view with animation. If the section doesn't exist it will be added to the end
    public func appendRows(_ rows: [UITableViewRow], to section: UITableViewSection, with animation: UITableViewRowAnimation) {

        rows.forEach { section.rows.append($0) }

        guard self.containsSection(section) else {
            self.appendSection(section, with: animation)
            return
        }

        self.updateData {
            let indexPaths = rows.compactMap { self.indexPath(for: $0) }
            self.tableView?.insertRows(at: indexPaths, with: animation)
        }

    }

    /// Insert a new rows in the table view with animation.
    ///
    /// - Parameters:
    ///   - rows: Dictionary where Key is index, Value is Row
    public func insertRows(_ rows: [Int : UITableViewRow], to section: UITableViewSection, with animation: UITableViewRowAnimation) {
        
        rows.forEach { section.rows.insert($0.value, at: $0.key) }
        
        guard self.containsSection(section) else {
            assertionFailure("Section not exist on this table view")
            return
        }
        
        self.updateData {
            let indexPaths = rows.compactMap { self.indexPath(for: $0.value) }
            self.tableView?.insertRows(at: indexPaths, with: animation)
        }
        
    }
    
    /// Insert a new rows in the table view with animation.
    public func reloadRows(_ rows: [UITableViewRow], with animation: UITableViewRowAnimation) {
        
        self.updateData {
            let indexPaths = rows.compactMap { self.indexPath(for: $0) }
            self.tableView?.reloadRows(at: indexPaths, with: animation)
        }
        
    }
    
    /// Insert a new rows in the table view with animation.
    public func deleteRows(_ rows: [UITableViewRow], with animation: UITableViewRowAnimation) {
        
        let indexPaths = rows.compactMap { self.indexPath(for: $0) }
        indexPaths.forEach { self.section(at: $0.section)?.rows.remove(at: $0.row) }
        
        self.updateData {
            self.tableView?.deleteRows(at: indexPaths, with: animation)
        }
        
    }
    
    /// Update table view data with animation
    ///
    /// - Parameter updateHandler: Handler between beginUpdates and endUpdates
    public func updateData(updateHandler: () -> Void) {
        self.tableView?.beginUpdates()
        updateHandler()
        self.tableView?.endUpdates()
    }
    
    /// Reload table view data when you change UITableViewSection or UITableViewRow
    public func reloadData() {
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension UITableViewManager: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.section(at: section)?.rows.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.row(at: indexPath) ?? UITableViewRow.default
        return row.configurationHandler(tableView, indexPath)
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let row = self.row(at: indexPath) else { return 44 }
        return row.heightForRowHandler?(tableView, indexPath) ?? row.height
        
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection index: Int) -> String? {
        
        guard let section = self.section(at: index) else { return nil }
        
        if let titleForHeader = section.titleForHeader {
            return titleForHeader
        } else if let titleForHeaderHandler = section.titleForHeaderHandler {
            return titleForHeaderHandler(tableView, index)
        } else {
            return nil
        }

    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection index: Int) -> String? {
        
        guard let section = self.section(at: index) else { return nil }
        
        if let titleForFooter = section.titleForFooter {
            return titleForFooter
        } else if let titleForFooterHandler = section.titleForFooterHandler {
            return titleForFooterHandler(tableView, index)
        } else {
            return nil
        }
        
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = self.row(at: indexPath)
        return row?.actions?.isEmpty == false
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
        guard let row = self.row(at: indexPath) else { return nil }
        return row.actions
        
    }
    
}

// MARK: - UITableViewDelegate
extension UITableViewManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = self.row(at: indexPath)
        row?.willDisplayHandler?(tableView, cell, indexPath)
        row?.cell = cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.row(at: indexPath)
        row?.didSelectHandler?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection index: Int) -> CGFloat {
        
        guard let section = self.section(at: index) else { return 0 }
        
        if let heightForHeader = section.heightForHeader {
            return heightForHeader
        } else if let heightForHeaderHandler = section.heightForHeaderHandler {
            return heightForHeaderHandler(tableView, index)
        } else {
            return UITableViewAutomaticDimension
        }
        
    }
    
    public func tableView(_ tableView: UITableView,viewForHeaderInSection index:Int) -> UIView? {
        guard let section = self.section(at: index) else { return nil }
        return section.viewForHeaderHandler?(tableView, index)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection index: Int) -> CGFloat {
        
        guard let section = self.section(at: index) else { return 0 }
        
        if let heightForFooter = section.heightForFooter {
            return heightForFooter
        } else if let heightForFooterHandler = section.heightForFooterHandler {
            return heightForFooterHandler(tableView, index)
        } else {
            return UITableViewAutomaticDimension
        }
        
    }
    
    public func tableView(_ tableView: UITableView,viewForFooterInSection index:Int) -> UIView? {
        guard let section = self.section(at: index) else { return nil }
        return section.viewForFooterHandler?(tableView, index)
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections.compactMap { $0.indexTitle }
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        guard
            let section = (self.sections.first { $0.indexTitle == title }),
            let sectionIndex = sections.index(of: section)
        else {
            assertionFailure()
            return 0
        }

        return sectionIndex
        
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = self.row(at: indexPath)
        row?.cell = nil
        
    }
    
}
