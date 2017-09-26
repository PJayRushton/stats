//
//  TrophySectionController.swift
//  Trophys
//
//  Created by Parker Rushton on 4/26/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class TrophySection: ListDiffable {
    
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
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? TrophySection else { return false }
        return trophy == other.trophy &&
        firstStat == other.firstStat &&
        secondStat == other.secondStat
    }
    
    func displayString(stat: Stat) -> String {
        let format = NSLocalizedString("%@ (%@ %@)", comment: "Player name ({Stat Number} Stat Type) e.g Parker (0.785 BA)")
        return String.localizedStringWithFormat(format, stat.player!.name, stat.displayString, statType.displayString(isSingular: stat.value == 1))
    }
    
}

class TrophySectionController: ListSectionController {
    
    var trophySection: TrophySection!
    
    override init() {
        super.init()
        inset = UIEdgeInsets.zero
    }
    
}

extension TrophySectionController {
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        switch index {
        case 0:
            return CGSize(width: context.containerSize.width, height: 80)
        case 1:
            if let _ = trophySection.secondStat {
                return CGSize(width: context.containerSize.width, height: 90)
            } else {
                return CGSize(width: context.containerSize.width, height: 70)
            }
        default:
            fatalError()
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        switch index {
        case 0:
            let cell = collectionContext?.dequeueReusableCell(withNibName: TrophyHeaderCell.reuseIdentifier, bundle: nil, for: self, at: index) as! TrophyHeaderCell
            cell.update(with: trophySection.trophy)
            return cell
        case 1:
            let cell = collectionContext?.dequeueReusableCell(withNibName: TrophyWinnerCell.reuseIdentifier, bundle: nil, for: self, at: index) as! TrophyWinnerCell
            cell.update(withTrophy: trophySection.trophy, winner: trophySection.firstStat, firstLoser: trophySection.secondStat)
            return cell
        default:
            fatalError()
        }
    }
    
    override func didUpdate(to object: Any) {
        trophySection = object as? TrophySection
    }
    
}
