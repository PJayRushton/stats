//
//  ShowMessage.swift
//  Stats
//
//  Created by Parker Rushton on 4/20/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import Whisper

struct ShowMessage: Command {
    
    var title: String
    var barColor: UIColor
    var textColor: UIColor
    
    init(title: String, barColor: UIColor = UIColor.mainAppColor, textColor: UIColor = .white) {
        self.title = title
        self.barColor = barColor
        self.textColor = textColor
    }
    
    func execute(state: AppState, core: Core<AppState>) {
        let font = FontType.lemonMilk.font(withSize: 10)
        let murmur = Murmur(title: title, backgroundColor: barColor, titleColor: textColor, font: font, action: nil)
        show(whistle: murmur, action: WhistleAction.show(1))
    }
    
}
