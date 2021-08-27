//
//  FilterButtons.swift
//  pholio01
//
//  Created by Chris  Ransom on 9/14/18.
//  Copyright © 2018 Chris Ransom. All rights reserved.
//

import UIKit

class FilterButtons: UIButton {

    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        
        setShadow()

        setTitleColor(.white, for: .normal)
        
        backgroundColor      = Colors.coolBlue
        titleLabel?.font     = UIFont(name: "AvenirNext-DemiBold", size: 18)
        layer.cornerRadius   = frame.size.height/2
        layer.borderWidth    = 3.0
        layer.borderColor    = UIColor.darkGray.cgColor
        
        addTarget(self, action: #selector(FilterButtons.buttonPressed), for: .touchUpInside)
    }
    
    
    private func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        
        isOn = bool
        
        let color = bool ? Colors.twitterBlue : .clear
        let title = bool ? "All Users" : "All Users"
        let titleColor = bool ? .white : Colors.twitterBlue
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }


}
