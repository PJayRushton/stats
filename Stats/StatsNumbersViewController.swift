//
//  StatsNumbersViewController.swift
//  Stats
//
//  Created by Parker Rushton on 4/24/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit
import IGListKit

class StatsNumbersViewController: Component, AutoStoryboardInitializable {

    @IBOutlet weak var collectionView: IGListCollectionView!
    @IBOutlet weak var pickerView: AKPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerView()
    }
    
}

extension StatsNumbersViewController: AKPickerViewDelegate, AKPickerViewDataSource {
    
    func setUpPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.font = FontType.lemonMilk.font(withSize: 15)
        pickerView.highlightedFont = FontType.lemonMilk.font(withSize: 16)
        pickerView.highlightedTextColor = UIColor.mainAppColor
        pickerView.interitemSpacing = 44
        pickerView.pickerViewStyle = .flat
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return StatType.allValues.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return StatType.allValues[item].abbreviation
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        let selectedStat = StatType.allValues[item]
        core.fire(event: Selected<StatType>(selectedStat))
    }
    
}
