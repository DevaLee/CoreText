//
//  CTColumnView.swift
//  LYCoreText
//
//  Created by 李玉臣 on 2020/1/14.
//  Copyright © 2020 LYfinacial.com. All rights reserved.
//

import UIKit
import CoreText
class CTColumnView: UIView {

    var ctFrame: CTFrame!

    required init?(coder: NSCoder) {
        super.init(coder: coder)!
    }

    required init(frame: CGRect, ctframe: CTFrame) {
        super.init(frame: frame)
        self.ctFrame = ctframe
        backgroundColor = .white
    }


    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        CTFrameDraw(ctFrame, context)
    }


}
