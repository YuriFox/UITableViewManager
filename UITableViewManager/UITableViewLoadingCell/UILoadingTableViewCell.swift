//
//  UILoadingTableViewCell.swift
//  UITableViewManager
//
//  Created by Yuri Fox on 23.05.2018.
//  Copyright © 2018 WayApp Development. All rights reserved.
//

import class UIKit.UITableViewCell

public class UILoadingTableViewCell: UITableViewCell {
  
    public private(set) var preferredActivityIndicatorViewStyle: UIActivityIndicatorViewStyle
    
    public lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: preferredActivityIndicatorViewStyle)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    public init(style: UIActivityIndicatorViewStyle) {
        self.preferredActivityIndicatorViewStyle = style
        super.init(style: .default, reuseIdentifier: "\(UILoadingTableViewCell.self)")
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.preferredActivityIndicatorViewStyle = .gray
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        self.contentView.addSubview(self.activityIndicatorView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.contentView, attribute: .centerX, relatedBy: .equal, toItem: self.activityIndicatorView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .centerY, relatedBy: .equal, toItem: self.activityIndicatorView, attribute: .centerY, multiplier: 1, constant: 0)
            ])
    }
    
}
