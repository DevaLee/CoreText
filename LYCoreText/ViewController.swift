//
//  ViewController.swift
//  LYCoreText
//
//  Created by 李玉臣 on 2020/1/14.
//  Copyright © 2020 LYfinacial.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 1
        guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }

        do {
          let text = try String(contentsOfFile: file, encoding: .utf8)
          // 2
          let parser = MarkupParser()
          parser.parseMarkup(text)
//          (view as? CTView)?.importAttrString(parser.attrString)
            (view as? CTView)?.buildFrames(withAttrString: parser.attrString, andImages: parser.images)
        } catch _ {
        }
    }


}

