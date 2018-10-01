//
//  UITableViewLoadingCell.swift
//  UITableViewManager
//
//  Created by Yuri Fox on 23.05.2018.
//  Copyright © 2018 WayApp Development. All rights reserved.
//

import class UIKit.UITableViewCell

public class UITableViewLoadingCell: UITableViewCell {
  
    public private(set) var preferredActivityIndicatorViewStyle: UIActivityIndicatorView.Style
    
    public lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: preferredActivityIndicatorViewStyle)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    public init(style: UIActivityIndicatorView.Style) {
        self.preferredActivityIndicatorViewStyle = style
        super.init(style: .default, reuseIdentifier: "\(type(of: self).self)")
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.selectionStyle = .none
        self.contentView.addSubview(self.activityIndicatorView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.contentView, attribute: .centerX, relatedBy: .equal, toItem: self.activityIndicatorView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .centerY, relatedBy: .equal, toItem: self.activityIndicatorView, attribute: .centerY, multiplier: 1, constant: 0)
            ])
    }
    
}
