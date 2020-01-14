//
//  CTView.swift
//  LYCoreText
//
//  Created by 李玉臣 on 2020/1/14.
//  Copyright © 2020 LYfinacial.com. All rights reserved.
//

import UIKit

class CTView: UIScrollView {

//    var attrString:NSAttributedString!
//
//    func importAttrString(_ attrString: NSAttributedString) {
//        self.attrString = attrString
//    }
//
//
//    //1
//    override func draw(_ rect: CGRect) {
//
//
//        // 2
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.textMatrix = .identity
//        context.translateBy(x: 0, y: bounds.size.height)
//        context.scaleBy(x: 1.0, y: -1.0)
//        // 3
//        let path = CGMutablePath()
//        path.addRect(bounds)
//        // 4
////        let attrString = NSAttributedString(string: "Hello World")
//        // 5
//        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
//        // 6
//        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
//        // 7
//        CTFrameDraw(frame, context)
//    }

    // 1
    func buildFrames(withAttrString attrString: NSAttributedString, andImages images:[[String : Any]]) {
        // 3
        isPagingEnabled = true
        // 4
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)

        var pageView = UIView()
        var textPos = 0
        var columnIndex: CGFloat = 0
        var pageIndex: CGFloat = 0
        let settings = CTSettings()

        while textPos < attrString.length {
            if columnIndex.truncatingRemainder(dividingBy: settings.columnsPerPage) == 0 {
                columnIndex = 0
                pageView = UIView(frame: settings.pageRect.offsetBy(dx: pageIndex * bounds.width, dy: 0))
                addSubview(pageView)

                pageIndex += 1
            }

            let columnXOrigin = pageView.frame.size.width / settings.columnsPerPage
            let columnOffset = columnIndex * columnXOrigin
            let columnFrame = settings.columnRect.offsetBy(dx: columnOffset, dy: 0)

            let path = CGMutablePath()
            path.addRect(CGRect(origin: .zero, size: columnFrame.size))
            let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, nil)

            let colum = CTColumnView(frame: columnFrame, ctframe: ctframe)
            pageView.addSubview(colum)

            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            textPos += frameRange.length

            columnIndex += 1
        }

        contentSize = CGSize(width: CGFloat(pageIndex * bounds.size.width), height: bounds.size.height)

        


    }
}
