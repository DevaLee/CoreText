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

    var imageIndex: Int!
    
    
    // 1
    func buildFrames(withAttrString attrString: NSAttributedString, andImages images:[[String : Any]]) {
        
        imageIndex = 0
        // 3
        isPagingEnabled = true
        // 4
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        // container for each page's column subviews
        var pageView = UIView()
        var textPos = 0
        var columnIndex: CGFloat = 0
        var pageIndex: CGFloat = 0
        let settings = CTSettings()

        /*
         self 可能包含多个pageView， pageView可能包含多个 CTColumnView
         
         */
        
        while textPos < attrString.length {
            // 取余
            if columnIndex.truncatingRemainder(dividingBy: settings.columnsPerPage) == 0 {
                // 新的一页
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
            
            if images.count > imageIndex {
                // 添加图片
                attachImagesWithFrame(images, ctframe: ctframe, margin: settings.margin, columnView: colum)
            }
            
            // 获取当前CTFrame中，可见字符串的Range （0，639）（639，748）等
            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            textPos += frameRange.length

            columnIndex += 1
        }

        contentSize = CGSize(width: CGFloat(pageIndex * bounds.size.width), height: bounds.size.height)
    }
    
    func attachImagesWithFrame(_ images:[[String: Any]],
                               ctframe: CTFrame,
                               margin: CGFloat,
                               columnView: CTColumnView) {
        let lines = CTFrameGetLines(ctframe) as NSArray
        
        var origins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &origins)
        
        var nextImage = images[imageIndex]
        guard var imgLocation = nextImage["location"] as? Int else {
            return
        }
        
        for lineIndex in 0..<lines.count {
            let line = lines[lineIndex] as! CTLine
            //5
            if let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun],
                let imageFileName = nextImage["filename"] as? String,
            let img = UIImage(named: imageFileName)  {
                for run in glyphRuns {
                    //1
                    let runRange = CTRunGetStringRange(run)
                    if runRange.location > imgLocation || runRange.location + runRange.length <= imgLocation {
                        // 当前 CTRun 不包含图片，跳过绘制图片这一步
                        continue
                    }
                    
                    var imgBounds: CGRect = .zero
                    var ascent: CGFloat = 0
                    // 根据 CTRun 计算出image的 height
                    imgBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, nil, nil))
                    imgBounds.size.height = ascent
                    // 得到 CTLine的x 值
                    let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                    imgBounds.origin.x = origins[lineIndex].x + xOffset
                    imgBounds.origin.y = origins[lineIndex].y
                    // 4
                    columnView.images += [(image: img, frame: imgBounds)]
                    //5
                    imageIndex! += 1
                    if imageIndex < images.count {
                        nextImage = images[imageIndex]
                        imgLocation = (nextImage["location"] as AnyObject).intValue
                    }
                    
                }
            }
            
        }
        
        
    }
}
