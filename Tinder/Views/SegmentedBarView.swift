//
//  SegmentedBarView.swift
//  Tinder
//
//  Created by Beavean on 30.12.2022.
//

import UIKit

final class SegmentedBarView: UIStackView {
    
    init(numberOfSegments: Int) {
        super.init(frame: .zero)
        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = K.UI.barDeselectedColor
            addArrangedSubview(barView)
        }
        spacing = 4
        distribution = .fillEqually
        arrangedSubviews.first?.backgroundColor = .white
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlighted(index: Int) {
        arrangedSubviews.forEach({ $0.backgroundColor = K.UI.barDeselectedColor })
        arrangedSubviews[index].backgroundColor = .white
    }
}
