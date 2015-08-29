//
//  RecordedAudio.swift
//  New Pitch Perfect
//
//  Created by  Trung Trinh on 8/17/15.
//  Copyright (c) 2015 Trung Trinh. All rights reserved.
//

import Foundation

class RecordedAudio {
    var title: String!
    var filePathUrl: NSURL!
    init(title:String, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
}