//
//  NewAtBatSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 4/19/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class NewAtBatSection: IGListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSNull()
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return true
    }
    
}

class NewAtBatSectionController: IGListSectionController {
    
    var section: NewAtBatSection!
    var cellSelected: (() -> Void) = { }
    
}

extension NewAtBatSectionController: IGListSectionType {
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        return CGSize(width: context.containerSize.width, height: 80)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: NewAtBatCell.reuseIdentifier, bundle: nil, for: self, at: index) as! AtBatCell
        return cell
    }
    
    func didUpdate(to object: Any) {
        section = object as? NewAtBatSection
    }
    
    func didSelectItem(at index: Int) {
        cellSelected()
    }
    
}
