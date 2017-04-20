//
//  AtBatSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 4/19/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class AtBatSection: IGListDiffable {
    
    var atBat: AtBat
    
    init(atBat: AtBat) {
        self.atBat = atBat
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return atBat.id as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? AtBatSection else { return false }
        return atBat == other.atBat &&
        atBat.gameId == other.atBat.gameId &&
        atBat.order == other.atBat.order &&
        atBat.playerId == other.atBat.playerId &&
        atBat.rbis == other.atBat.rbis &&
        atBat.resultCode == other.atBat.resultCode &&
        atBat.seasonId == other.atBat.seasonId &&
        atBat.teamId == other.atBat.teamId
    }
    
}

class AtBatSectionController: IGListSectionController {
    
    var section: AtBatSection!
    var didSelectAtBat: (() -> Void) = { }
    
}

extension AtBatSectionController: IGListSectionType {

    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        return CGSize(width: context.containerSize.width, height: 80)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: AtBatCell.reuseIdentifier, bundle: nil, for: self, at: index) as! AtBatCell
        cell.update(with: section.atBat)
        return cell
    }
    
    func didUpdate(to object: Any) {
        section = object as? AtBatSection
    }
    
    func didSelectItem(at index: Int) {
        didSelectAtBat()
    }
    
}
