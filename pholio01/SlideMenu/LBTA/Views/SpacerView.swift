//
//  SpacerView.swift
//  SlideOutMenuLBTA
//
//  Created by Brian Voong on 10/2/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class SpacerView: UIView {
    
    let space: CGFloat

    override var intrinsicContentSize: CGSize {
        return .init(width: space, height: space)
    }
    
    init(space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
