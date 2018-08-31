//
//  UITableViewRow.swift
//  UITableViewManager
//
//  Created by Yuri Lysytsia on 17.07.2018.
//  Copyright © 2018 Yuri Lysytsia. All rights reserved.
//

import class UIKit.UITableView

public class UITableViewRow: NSObject {

    /// Determines whether this row is visible after the section is reloaded
    public var isVisible: Bool

    /// Preferred height of this row
    public var height: CGFloat = 44
    
    /// Visible table view cell for this row.
    public internal(set) weak var cell: UITableViewCell?
    
    /// Actions for this row
    public var actions: [UITableViewRowAction]?
    
    private(set) var configurationHandler: ConfigurationHandler
    private(set) var didSelectHandler: DidSelectHandler?
    private(set) var willDisplayHandler: WillDisplayHandler?
    private(set) var heightForRowHandler: HeightForRowHandler?
    
    public init(visible: Bool = true, configurationHandler: @escaping ConfigurationHandler) {
        self.isVisible = visible
        self.configurationHandler = configurationHandler
    }

    /// The closure that will be called when table view call tableViewCellForRowAtIndexPath
    public func configuration(_ configuration: @escaping ConfigurationHandler) {
        self.configurationHandler = configuration
    }

    /// The closure that will be called when table view call tableViewDidSelectRowAtIndexPath
    public func didSelect(_ handler: @escaping DidSelectHandler) {
        self.didSelectHandler = handler
    }
    
    /// The closure that will be called when table view call tableViewWillDisplayCellAtIndexPath
    public func willDisplay(_ handler: @escaping WillDisplayHandler) {
        self.willDisplayHandler = handler
    }
    
    /// The closure that will be called when the table view call tableViewHeightForRowAtIndexPath.
    public func heightForRow(_ handler: @escaping HeightForRowHandler) {
        self.heightForRowHandler = handler
    }
    
    public typealias ConfigurationHandler = (UITableView, IndexPath) -> UITableViewCell
    public typealias DidSelectHandler = (UITableView, IndexPath) -> Void
    public typealias WillDisplayHandler = (UITableView, UITableViewCell, IndexPath) -> Void
    public typealias HeightForRowHandler = (UITableView, IndexPath) -> CGFloat
    
}

// MARK: - UITableViewRow Instance
extension UITableViewRow {
    
    public static func `default`(style: UITableViewCellStyle = .default) -> UITableViewRow {
        return UITableViewRow { (_, _) -> UITableViewCell in
            return UITableViewCell(style: style, reuseIdentifier: "UITableViewCell")
        }
    }
    
    public static func loading(style: UIActivityIndicatorViewStyle = .gray) -> UITableViewRow {
        let row = UITableViewRow { (tableView, indexPath) -> UITableViewCell in
            let cell = UILoadingTableViewCell(style: style)
            cell.selectionStyle = .none
            cell.backgroundColor = tableView.backgroundColor
            cell.contentView.backgroundColor = tableView.backgroundColor
            return cell
        }
        row.heightForRow { (tableView, _) -> CGFloat in
            return tableView.frame.height + tableView.contentOffset.y - tableView.contentInset.top - tableView.contentInset.bottom
        }
        return row
    }
    
}
