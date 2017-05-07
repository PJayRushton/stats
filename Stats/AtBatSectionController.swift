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
    var order: Int
    
    init(atBat: AtBat, order: Int) {
        self.atBat = atBat
        self.order = order
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return atBat.id as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? AtBatSection else { return false }
        return atBat == other.atBat &&
            order == other.order &&
            atBat.gameId == other.atBat.gameId &&
            atBat.playerId == other.atBat.playerId &&
            atBat.rbis == other.atBat.rbis &&
            atBat.resultCode == other.atBat.resultCode &&
            atBat.seasonId == other.atBat.seasonId &&
            atBat.teamId == other.atBat.teamId
    }
    
}

class AtBatSectionController: IGListSectionController {
    
    var section: AtBatSection!
    var canEdit: Bool
    var didSelectAtBat: ((AtBat) -> Void) = { _ in }
    
    init(canEdit: Bool) {
        self.canEdit = canEdit
        super.init()
        inset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
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
        cell.update(with: section.atBat, order: section.order, canEdit: canEdit)
        return cell
    }
    
    func didUpdate(to object: Any) {
        section = object as? AtBatSection
    }
    
    func didSelectItem(at index: Int) {
        didSelectAtBat(section.atBat)
    }
    
}
