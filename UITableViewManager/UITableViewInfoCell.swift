//
//  UITableViewInfoCell.swift
//  UITableViewManager
//
//  Created by Yuri Fox on 01.09.2018.
//  Copyright © 2018 Yuri Lysytsia. All rights reserved.
//

import class UIKit.UITableViewCell

public class UITableViewInfoCell: UITableViewCell {

    private lazy var iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    init(icon: UIImage?, attributedTitle: NSAttributedString?) {
        super.init(style: .default, reuseIdentifier: "\(type(of: self).self)")
        self.iconView.image = icon
        self.infoLabel.attributedText = attributedTitle
        self.initialize()
    }
    
    public convenience init(icon: UIImage?, title: String?, text: String?) {
        
        let attrString: NSAttributedString? = {
            let attr = NSMutableAttributedString()
            if let title = title, let text = text {
                attr.append(.title(string: title))
                attr.append(.init(string: "\n"))
                attr.append(.text(string: text))
            } else if let title = title {
                attr.append(.title(string: title))
            } else if let text = text {
                attr.append(.text(string: text))
            } else {
                return nil
            }
            return attr
        }()
        
        self.init(icon: icon, attributedTitle: attrString)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Initialization
private extension UITableViewInfoCell {
    
    private func initialize() {
        self.selectionStyle = .none
        
        self.iconView.removeFromSuperview()
        self.infoLabel.removeFromSuperview()
        
        let hasIcon = self.iconView.image != nil
        let hasText = self.infoLabel.attributedText != nil
        
        if hasIcon && hasText {
            self.initializeWhenLabelWithIcon()
        } else if hasIcon {
            self.initializeWhenOnlyIcon()
        } else if hasText {
            self.initializeWhenOnlyLabel()
        } else {
            fatalError("initialize() something from icon or text is requaired")
        }
        
    }
    
    private func initializeWhenOnlyLabel() {
        let label = self.infoLabel
        let content = self.contentView
        content.addSubview(label)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: label.topAnchor, constant: -20),
            content.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant:-20),
            content.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
            content.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
            ])
    }
    
    private func initializeWhenOnlyIcon() {
        let icon = self.iconView
        let content = self.contentView
        content.addSubview(icon)
        NSLayoutConstraint.activate([
            content.centerXAnchor.constraint(equalTo: icon.centerXAnchor),
            content.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            ])
    }
    
    private func initializeWhenLabelWithIcon() {
        let label = self.infoLabel
        let icon = self.iconView
        let content = self.contentView
        content.addSubview(label)
        content.addSubview(icon)
        NSLayoutConstraint.activate([
            content.centerXAnchor.constraint(equalTo: icon.centerXAnchor),
            content.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            icon.widthAnchor.constraint(equalTo: content.widthAnchor, multiplier: 0.3),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor),
            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
            content.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -20),
            content.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
            content.bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: 20)
            ])
    }
    
}

// MARK: - NSAttributedString
fileprivate extension NSAttributedString {

    static func title(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [
            .font : UIFont.systemFont(ofSize: 18, weight: .bold),
            .paragraphStyle : NSParagraphStyle.style(aligment: .center),
            .foregroundColor : UIColor.black
            ])
    }
    
    static func text(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [
            .font : UIFont.systemFont(ofSize: 16, weight: .semibold),
            .paragraphStyle : NSParagraphStyle.style(aligment: .center),
            .foregroundColor : UIColor.gray
            ])
    }
    
}

// MARK: - NSParagraphStyle
extension NSParagraphStyle {
    
    public static func style(aligment: NSTextAlignment) -> NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = aligment
        return style
    }
    
}
