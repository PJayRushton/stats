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
    
    init(team: Team, menuItem: HomeMenuItem) {
        self.team = team
        self.menuItem = menuItem
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSNumber(value: menuItem.rawValue)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? TeamActionSection else { return false }
        var isSameOwnership = true
        if let user = App.core.state.userState.currentUser {
            isSameOwnership = user.isOwnerOrManager(of: team) == user.isOwnerOrManager(of: other.team)
        }
        return team == other.team && menuItem.title == other.menuItem.title && isSameOwnership
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
        guard let collectionContext = collectionContext, let user = App.core.state.userState.currentUser else { return .zero }
        let fullWidth = collectionContext.containerSize.width
        let headerHeight = collectionContext.containerSize.width * (2 / 3)
        let hasEditRights = user.isOwnerOrManager(of: actionSection.team)
        let rows: CGFloat = hasEditRights ? 3 : 2
        let height = (collectionContext.containerSize.height - headerHeight) / rows
        let width = fullWidth / actionSection.menuItem.itemsPerRow
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: HomeCollectionViewCell.reuseIdentifier, for: self, at: index) as! HomeCollectionViewCell
        cell.update(with: actionSection.menuItem)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        actionSection = object as? TeamActionSection
    }
    
    override func didSelectItem(at index: Int) {
        didSelectItem(actionSection.menuItem)
    }
    
}
