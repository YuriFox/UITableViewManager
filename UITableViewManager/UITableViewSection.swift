//
//  UITableViewSection.swift
//  UITableViewManager
//
//  Created by Yuri Lysytsia on 17.07.2018.
//  Copyright © 2018 Yuri Lysytsia. All rights reserved.
//

import UIKit

public class UITableViewSection: NSObject {
    
//    /// Defines if it needs to be showed in vertical scrollbar.
//    open var indexTitle: String?

    /// Determines whether this section is visible after the table is reloaded
    var isVisible: Bool
    
    /// Rows of section
    public var rows: [UITableViewRow] = []

    /// Visible rows of section
    public var visibleRows: [UITableViewRow] {
        return self.rows.filter { $0.isVisible }
    }

//    /// The closure that will be called when the table request the header's height
//    open var heightForHeader: HeightForHeader?
//
//    /// The closure that will be called when the table request the header's title
//    open var titleForHeader: TitleForHeader?
//
//    /// The closure that will be called when the table request the header's view
//    open var viewForHeader: ViewForHeader?
//
//    /// The closure that will be called when the table request the footer's height
//    open var heightForFooter: HeightForFooter?
//
//    /// The closure that will be called when the table request the footer's title
//    open var titleForFooter: TitleForFooter?
//
//    /// The closure that will be called when the table request the footer's view
//    open var viewForFooter: ViewForFooter?

    public init(visible: Bool = true) {
        self.isVisible = visible
    }

    /// Return true if row exist
    public func containsRow(_ row: UITableViewRow) -> Bool {
        return self.rows.contains(row)
    }

    /// Return index of the row if that exist
    public func index(for row: UITableViewRow, visible: Bool) -> Int? {
        let rows = visible ? self.rows : self.visibleRows
        return rows.index(of: row)
    }
    
    /// Return row at index
    public func row(at index: Int, visible: Bool) -> UITableViewRow? {
        let rows = visible ? self.visibleRows : self.rows
        return rows.indices.contains(index) ? rows[index] : nil
    }
    
    /// Append new row with created UITableViewRow in this section.
    public func addRow(_ row: UITableViewRow) {
        self.rows.append(row)
    }
    
    /// Append new row in this section.
    public func addRow(visible: Bool = true, configuration: @escaping UITableViewRow.ConfigurationHandler) -> UITableViewRow {
        let row = UITableViewRow(visible: visible, configurationHandler: configuration)
        self.addRow(row)
        return row
    }
    
    //    /// Set indexTitle to be showed in vertical scrollbar.
    //    @discardableResult
    //    open func setIndexTitle(_ title: String) -> Section {
    //        self.indexTitle = title
    //        return self
    //    }

//    /// Remove all rows
//    @discardableResult
//    open func clearRows() -> Section {
//        rows.removeAll()
//        return self
//    }
//
//    // MARK: Header Configuration
//
//    /// Set the header using a closure that will be called when the table request a title
//    @discardableResult
//    open func setHeaderView(withDynamicText dynamicText: @escaping TitleForHeader) -> Section {
//        titleForHeader = dynamicText
//        return self
//    }
//
//    /// Set the header using a static title
//    @discardableResult
//    open func setHeaderView(withStaticText staticText: String) -> Section {
//        setHeaderView { _ in
//            return staticText
//        }
//        return self
//    }
//
//    /// Set the header using a closure that will be called when the table request a view
//    @discardableResult
//    open func setHeaderView(withDynamicView dynamicView: @escaping ViewForHeader) -> Section {
//        viewForHeader = dynamicView
//        return self
//    }
//
//    /// Set the header using a static view
//    @discardableResult
//    open func setHeaderView(withStaticView staticView: UIView) -> Section {
//        setHeaderView { _ in
//            return staticView
//        }
//        return self
//    }
//
//    /// Set the header's height using a closure that will be called when the table request the a height
//    @discardableResult
//    open func setHeaderHeight(withDynamicHeight dynamicHeight: @escaping HeightForHeader) -> Section {
//        heightForHeader = dynamicHeight
//        return self
//    }
//
//    /// Set the header's height using a static height
//    @discardableResult
//    open func setHeaderHeight(withStaticHeight staticHeight: Double) -> Section {
//        setHeaderHeight { _ in
//            return staticHeight
//        }
//        return self
//    }
//
//    public typealias HeightForHeader = (_ section: Section, _ tableView: UITableView, _ index: Int) -> Double
//    public typealias ViewForHeader = (_ section: Section, _ tableView: UITableView, _ index: Int) -> UIView
//    public typealias TitleForHeader = (_ section: Section, _ tableView: UITableView, _ index: Int) -> String
//
//    // MARK: Footer Configuration
//
//    /// Set the footer using a closure that will be called when the table request a title
//    @discardableResult
//    open func setFooterView(withDynamicText dynamicText: @escaping TitleForFooter) -> Section {
//        titleForFooter = dynamicText
//        return self
//    }
//
//    /// Set the footer using a static title
//    @discardableResult
//    open func setFooterView(withStaticText staticText: String) -> Section {
//        setFooterView { _ in
//            return staticText
//        }
//        return self
//    }
//
//    /// Set the footer using a closure that will be called when the table request a view
//    @discardableResult
//    open func setFooterView(withDynamicView dynamicView: @escaping ViewForFooter) -> Section {
//        viewForFooter = dynamicView
//        return self
//    }
//
//    /// Set the footer using a static view
//    @discardableResult
//    open func setFooterView(withStaticView staticView: UIView) -> Section {
//        setFooterView { _ in
//            return staticView
//        }
//        return self
//    }
//
//    /// Set the footer's height using a closure that will be called when the table request the a height
//    @discardableResult
//    open func setFooterHeight(withDynamicHeight dynamicHeight: @escaping HeightForFooter) -> Section {
//        heightForFooter = dynamicHeight
//        return self
//    }
//
//    /// Set the footer's height using a static height
//    @discardableResult
//    open func setFooterHeight(withStaticHeight staticHeight: Double) -> Section {
//        setFooterHeight { _ in
//            return staticHeight
//        }
//        return self
//    }
//
//    public typealias HeightForFooter = (_ section: Section, _ tableView: UITableView, _ index: Int) -> Double
//    public typealias ViewForFooter = (_ section: Section, _ tableView: UITableView, _ index: Int) -> UIView
//    public typealias TitleForFooter = (_ section: Section, _ tableView: UITableView, _ index: Int) -> String
    
}
