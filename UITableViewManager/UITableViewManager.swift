//
//  UITableViewManager.swift
//  UITableViewManager
//
//  Created by Yuri Lysytsia on 17.07.2018.
//  Copyright © 2018 Yuri Lysytsia. All rights reserved.
//

import UIKit

public class UITableViewManager: NSObject {
    
    /// Reference of table view
    public weak var tableView: UITableView?
    
    /// Sections of table view
    public var sections: [UITableViewSection] = []
    
    /// Visible sections of table view
    public var visibleSections: [UITableViewSection] {
        return self.sections.filter { $0.isVisible }
    }
    
    /// Initialize manager with the reference of table view
    public init(tableView: UITableView) {
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
    }
    
    func section(at index: Int, visible: Bool) -> UITableViewSection? {
        let sections = visible ? self.visibleSections : self.sections
        return sections.indices.contains(index) ? sections[index] : nil
    }
    
    func row(at indexPath: IndexPath, visible: Bool) -> UITableViewRow? {
        guard let section = self.section(at: indexPath.section, visible: visible) else {
            return nil
        }
        
        let rows = visible ? section.visibleRows : section.rows
        return rows.indices.contains(indexPath.row) ? rows[indexPath.row] : nil
    }
    
//    convertToIncludeAllIndexPath(withToRenderIndexPath indexPath: IndexPath) -> IndexPath? {
    
    /// Returns an index of the section if exist
    public func index(for section: UITableViewSection, visible: Bool) -> Int? {
        let sections = visible ? self.visibleSections : self.sections
        return sections.index(of: section)
    }
    
    /// Returns an indexPath of the row if exist
    public func indexPath(for row: UITableViewRow, visible: Bool) -> IndexPath? {
        let sections = visible ? self.visibleSections : self.sections
        
        for (sectionIndex, section) in sections.enumerated() {
            guard let row = section.index(for: row, visible: visible) else { continue }
            return IndexPath(row: row, section: sectionIndex)
        }
        
        return nil
        
    }
    
    //    /// If exist, return the Row that correspond the selected cell
    //    open func selectedRow() -> Row? {
    //        guard let indexPath = tableView.indexPathForSelectedRow else {
    //            return nil
    //        }
    //
    //        return row(atIndexPath: indexPath)
    //    }
    
    
    //    /// If exist, return the Rows that are appearing to the user in the table
    //    open func visibleRows() -> [Row]? {
    //        guard let indexPaths = tableView.indexPathsForVisibleRows else {
    //            return nil
    //        }
    //
    //        return indexPaths.map {
    //            row(atIndexPath: $0)
    //        }
    //    }
    
    /// Add a new section with UITableViewSection in the table view.
    public func addSection(_ section: UITableViewSection) {
        self.sections.append(section)
    }
    
    /// Add a new section in the table view.
    public func addSection(visible: Bool) -> UITableViewSection{
        let section = UITableViewSection(visible: visible)
        self.addSection(section)
        return section
    }
    
    /// Add a new row with UITableViewRow in the first section of the table view. A new section will be added if don't exist yet.
    public func addRow(_ row: UITableViewRow) {
        let section = self.section(at: 0, visible: false) ?? self.addSection(visible: true)
        section.addRow(row)
    }
    
    /// Add a new row in the first section of the table view. A new section will be added if don't exist yet.
    @discardableResult
    public func addRow(visible: Bool = true, configurationHandler: @escaping UITableViewRow.ConfigurationHandler) -> UITableViewRow {

        let row = UITableViewRow(visible: visible, configurationHandler: configurationHandler)
        self.addRow(row)
        return row
        
    }

    public func deleteRow(_ row: UITableViewRow) {
        guard
            let indexPath = self.indexPath(for: row, visible: false),
            self.sections.indices.contains(indexPath.section)
        else { return }
        self.sections[indexPath.section].rows.remove(at: indexPath.row)
        self.tableView?.deleteRows(at: [indexPath], with: .automatic)
//            delegate?.tableManagerDidDelete(row, atIndexPath: indexPath)
    }
    
    public func deleteRow(at indexPath: IndexPath, visible: Bool) {
        guard let row = self.row(at: indexPath, visible: visible) else { return }
        self.deleteRow(row)
    }
    
    public func reloadData() {
        self.tableView?.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension UITableViewManager: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.visibleSections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        guard let section = self.section(at: section, visible: true) else { return 0 }
        return section.visibleRows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.row(at: indexPath, visible: true) ?? UITableViewRow.default
        return row.configurationHandler(tableView, indexPath)
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let row = self.row(at: indexPath, visible: true) else { return 44 }
        let height = row.heightForRowHandler?(tableView, indexPath)
        return height ?? row.height
        
    }
    
    //    public func tableView(_ tableView: UITableView, titleForHeaderInSection index: Int) -> String? {
    //        let section = self.section(atIndex: index)
    //
    //        if let titleForHeader = section.titleForHeader {
    //            return titleForHeader(section, tableView, index)
    //        }
    //
    //        return nil
    //    }
    //
    //    public func tableView(_ tableView: UITableView, titleForFooterInSection index: Int) -> String? {
    //        let section = self.section(atIndex: index)
    //
    //        if let titleForFooter = section.titleForFooter {
    //            return titleForFooter(section, tableView, index)
    //        }
    //
    //        return nil
    //    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = self.row(at: indexPath, visible: true)
        return row?.actions?.isEmpty == false
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
        guard let row = self.row(at: indexPath, visible: true) else { return nil }
        return row.actions
        
    }
    
}

// MARK: - UITableViewDelegate
extension UITableViewManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = self.row(at: indexPath, visible: true)
        row?.willDisplayHandler?(tableView, cell, indexPath)
        row?.cell = cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.row(at: indexPath, visible: true)
        row?.didSelectHandler?(tableView, indexPath)
    }
    
    //    public func tableView(_ tableView: UITableView, heightForHeaderInSection index: Int) -> CGFloat {
    //        let section = self.section(atIndex: index)
    //
    //        if let heightForHeader = section.heightForHeader {
    //            return CGFloat(heightForHeader(section, tableView, index))
    //        }
    //
    //        return CGFloat(0.0)
    //    }
    //
    //    public func tableView(_ tableView: UITableView, viewForHeaderInSection index: Int) -> UIView? {
    //        let section = self.section(atIndex: index)
    //
    //        if let viewForHeader = section.viewForHeader {
    //            return viewForHeader(section, tableView, index)
    //        }
    //
    //        return nil
    //    }
    //
    //    public func tableView(_ tableView: UITableView, heightForFooterInSection index: Int) -> CGFloat {
    //        let section = self.section(atIndex: index)
    //
    //        if let heightForFooter = section.heightForFooter {
    //            return CGFloat(heightForFooter(section, tableView, index))
    //        }
    //
    //        return CGFloat(0.0)
    //    }
    //
    //    public func tableView(_ tableView: UITableView, viewForFooterInSection index: Int) -> UIView? {
    //        let section = self.section(atIndex: index)
    //
    //        if let viewForFooter = section.viewForFooter {
    //            return viewForFooter(section, tableView, index)
    //        }
    //
    //        return nil
    //    }
    //
    //    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //        return sections.flatMap { $0.indexTitle }
    //    }
    //
    //    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    //        guard let section = (sections.filter { $0.indexTitle == title }.first) else {
    //            return 0
    //        }
    //
    //        guard let indexOfSection = sections.index(of: section) else {
    //            return 0
    //        }
    //
    //        return indexOfSection
    //    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = self.row(at: indexPath, visible: true)
        row?.cell = nil
        
    }
    
}
