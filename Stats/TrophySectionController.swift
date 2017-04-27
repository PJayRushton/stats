//
//  TrophySectionController.swift
//  Trophys
//
//  Created by Parker Rushton on 4/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class TrophySection: IGListDiffable {
    
    var trophy: Trophy
    var firstStat: Stat
    var secondStat: Stat?
    
    init(trophy: Trophy, firstStat: Stat, secondStat: Stat?) {
        self.trophy = trophy
        self.firstStat = firstStat
        self.secondStat = secondStat
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return trophy.displayName as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? TrophySection else { return false }
        return trophy == other.trophy &&
        firstStat == other.firstStat &&
        secondStat == other.secondStat
    }
    
}

class TrophySectionController: IGListSectionController {
    
    var section: TrophySection!
    
    override init() {
        super.init()
        inset = UIEdgeInsets.zero
    }
    
}

extension TrophySectionController: IGListSectionType {
    
    func numberOfItems() -> Int {
        return 2
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        switch index {
        case 0:
            return CGSize(width: context.containerSize.width, height: 80)
        case 1:
            if let _ = section.secondStat {
                return CGSize(width: context.containerSize.width, height: 100)
            } else {
                return CGSize(width: context.containerSize.width, height: 70)
            }
        default:
            fatalError()
        }
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        switch index {
        case 0:
            let cell = collectionContext?.dequeueReusableCell(withNibName: TrophyHeaderCell.reuseIdentifier, bundle: nil, for: self, at: index) as! TrophyHeaderCell
            cell.update(with: section.trophy)
            return cell
        case 1:
            let cell = collectionContext?.dequeueReusableCell(withNibName: TrophyWinnerCell.reuseIdentifier, bundle: nil, for: self, at: index) as! TrophyWinnerCell
            cell.update(withTrophy: section.trophy, winner: section.firstStat, firstLoser: section.secondStat)
            return cell
        default:
            fatalError()
        }
    }
    
    func didUpdate(to object: Any) {
        section = object as? TrophySection
    }
    
    func didSelectItem(at index: Int) {
        return
    }
    
}
