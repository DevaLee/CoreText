//
//  CTSettings.swift
//  LYCoreText
//
//  Created by 李玉臣 on 2020/1/14.
//  Copyright © 2020 LYfinacial.com. All rights reserved.
//

import Foundation
import UIKit

class CTSettings {

    let margin: CGFloat = 20
    var columnsPerPage: CGFloat!
    var pageRect: CGRect!
    var columnRect: CGRect!

    init() {
        columnsPerPage = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
        pageRect = UIScreen.main.bounds.insetBy(dx: margin, dy: margin)

        columnRect = CGRect(x: 0, y: 0, width: pageRect.width / columnsPerPage, height: pageRect.height).insetBy(dx: margin, dy: margin)
    }

}
