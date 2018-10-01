//
//  UITableViewSection.swift
//  UITableViewManager
//
//  Created by Yuri Lysytsia on 17.07.2018.
//  Copyright © 2018 Yuri Lysytsia. All rights reserved.
//

import class UIKit.UITableView

public class UITableViewSection: NSObject {
    
    /// Unique section identificator
    public var id: String?
    
    /// Rows of section
    public var rows: [UITableViewRow]
    
    /// Defines if it needs to be showed in vertical scrollbar.
    public var indexTitle: String?
    
    /// Table view section header title
    public var titleForHeader: String?
    
    /// Table view section header height
    public var heightForHeader: CGFloat?
    
    /// Table view section footer title
    public var titleForFooter: String?
    
    /// Table view section footer height
    public var heightForFooter: CGFloat?

    private(set) var titleForHeaderHandler: TitleForHeaderFooterHandler?
    private(set) var titleForFooterHandler: TitleForHeaderFooterHandler?
    private(set) var heightForHeaderHandler: HeightForHeaderFooterHandler?
    private(set) var heightForFooterHandler: HeightForHeaderFooterHandler?
    private(set) var viewForHeaderHandler: ViewForHeaderFooterHandler?
    private(set) var viewForFooterHandler: ViewForHeaderFooterHandler?
    
    public init(rows: [UITableViewRow]) {
        self.rows = rows
    }
    
    /// Return true if row exist
    public func containsRow(_ row: UITableViewRow) -> Bool {
        return self.rows.contains(row)
    }

    /// Return index of the row if that exist
    public func index(for row: UITableViewRow) -> Int? {
        return self.rows.index(of: row)
    }
    
    /// Return row at index
    public func row(at index: Int) -> UITableViewRow? {
        return self.rows.element(at: index)
    }
    
    /// Return first row with unique id
    public func row(id: String) -> UITableViewRow? {
        return self.rows(id: id).first
    }
    
    /// Return rows with unique id
    public func rows(id: String) -> [UITableViewRow] {
        return self.rows.filter { $0.id == id }
    }
    
    /// Set the header title using a closure that will be called when the table view titleForHeaderAtIndex
    public func titleForHeader(handler: @escaping TitleForHeaderFooterHandler) {
        self.titleForHeaderHandler = handler
    }
    
    /// Set the header height using a closure that will be called when the table view heightForHeaderAtIndex
    public func heightForHeader(handler: @escaping HeightForHeaderFooterHandler) {
        self.heightForHeaderHandler = handler
    }
    
    /// Set the header view using a closure that will be called when the table view viewForHeaderAtIndex
    public func viewForHeader(handler: @escaping ViewForHeaderFooterHandler) {
        self.viewForHeaderHandler = handler
    }
    
    /// Set the footer title using a closure that will be called when the table view titleForFooterAtIndex
    public func titleForFooter(handler: @escaping TitleForHeaderFooterHandler) {
        self.titleForFooterHandler = handler
    }
    
    /// Set the header height using a closure that will be called when the table view heightForHeaderAtIndex
    public func heightForFooter(handler: @escaping HeightForHeaderFooterHandler) {
        self.heightForFooterHandler = handler
    }
    
    /// Set the footer view using a closure that will be called when the table view viewForHeaderAtIndex
    public func viewForFooter(handler: @escaping ViewForHeaderFooterHandler) {
        self.viewForFooterHandler = handler
    }
    
    public typealias TitleForHeaderFooterHandler = (UITableView, Int) -> String?
    public typealias HeightForHeaderFooterHandler = (UITableView, Int) -> CGFloat
    public typealias ViewForHeaderFooterHandler = (UITableView, Int) -> UIView?
    
}
