//
//  TeamActionSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class TeamActionSection: ListDiffable {
    
    var team: Team
    var menuItem: HomeMenuItem
    var badgeCount: Int?
    
    init(team: Team, menuItem: HomeMenuItem, badgeCount: Int? = nil) {
        self.team = team
        self.menuItem = menuItem
        self.badgeCount = badgeCount
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSNumber(value: menuItem.rawValue)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? TeamActionSection else { return false }
        return team == other.team && menuItem.title == other.menuItem.title && badgeCount == other.badgeCount
    }
    
}

class TeamActionSectionController: ListSectionController {
    
    var actionSection: TeamActionSection!
    
    var didSelectItem: ((HomeMenuItem) -> Void) = { _ in }
    
    override init() {
        super.init()
        inset = UIEdgeInsets.zero
    }
    
}

extension TeamActionSectionController {
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        let fullWidth = collectionContext.containerSize.width
        let headerHeight = collectionContext.containerSize.width * (2 / 3)
        let rows = CGFloat(HomeMenuItem.allValues.count) / actionSection.menuItem.itemsPerRow
        let height = (collectionContext.containerSize.height - headerHeight) / rows
        let width = fullWidth / actionSection.menuItem.itemsPerRow
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: HomeCollectionViewCell.reuseIdentifier, for: self, at: index) as! HomeCollectionViewCell
        cell.update(with: actionSection.menuItem, badgeCount: actionSection.badgeCount)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        actionSection = object as? TeamActionSection
    }
    
    override func didSelectItem(at index: Int) {
        didSelectItem(actionSection.menuItem)
    }
    
}
