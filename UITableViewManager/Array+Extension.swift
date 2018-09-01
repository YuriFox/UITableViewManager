//
//  Array+Extension.swift
//  UITableViewManager
//
//  Created by Yuri Fox on 31.08.2018.
//  Copyright © 2018 Yuri Lysytsia. All rights reserved.
//

import Foundation

extension Array {
    
    func element(at index: Int) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
    
}

