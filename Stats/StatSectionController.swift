//
//  StatSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class StatSection: ListDiffable {
    
    var stat: Stat
    var place: Place?
    
    init(stat: Stat, place: Place? = nil) {
        self.stat = stat
        self.place = place
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return stat.player.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? StatSection else { return false }
        return stat.player == other.stat.player &&
        stat.statType == other.stat.statType &&
        stat.value == other.stat.value
    }
    
}

class StatSectionController: ListSectionController {
    
    var statSection: StatSection!
    var didSelectStat: ((Stat) -> Void) = { _ in }
    
    override init() {
        super.init()
        inset = UIEdgeInsets.zero
    }
    
}

extension StatSectionController {
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        return CGSize(width: context.containerSize.width, height: 60)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: StatCell.reuseIdentifier, bundle: nil, for: self, at: index) as! StatCell
        cell.update(with: statSection.stat, place: statSection.place)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        statSection = object as? StatSection
    }
    
    override func didSelectItem(at index: Int) {
        didSelectStat(statSection.stat)
    }
    
}
