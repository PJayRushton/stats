//
//  StatSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 4/25/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

enum Place: Int {
    case first
    case second
    case third
    
    var emoji: String {
        switch self {
        case .first:
            return "🥇"
        case .second:
            return "🥈"
        case .third:
            return "🥉"
        }
    }
}

class StatSection: IGListDiffable {
    
    var stat: Stat
    var place: Place?
    
    init(stat: Stat, place: Place? = nil) {
        self.stat = stat
        self.place = place
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return stat.player.id as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? StatSection else { return false }
        return stat.player == other.stat.player &&
        stat.statType == other.stat.statType &&
        stat.value == other.stat.value
    }
    
}

class StatSectionController: IGListSectionController {
    
    var section: StatSection!
    var didSelectStat: ((Stat) -> Void) = { _ in }
    
    override init() {
        super.init()
        inset = UIEdgeInsets.zero
    }
    
}

extension StatSectionController: IGListSectionType {
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        return CGSize(width: context.containerSize.width, height: 60)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: StatCell.reuseIdentifier, bundle: nil, for: self, at: index) as! StatCell
        cell.update(with: section.stat, place: section.place)
        return cell
    }
    
    func didUpdate(to object: Any) {
        section = object as? StatSection
    }
    
    func didSelectItem(at index: Int) {
        didSelectStat(section.stat)
    }
    
}
