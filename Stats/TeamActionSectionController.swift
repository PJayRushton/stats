//
//  TeamActionSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 3/31/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class TeamActionSection: IGListDiffable {
    
    var team: Team
    var menuItem: HomeMenuItem
    
    init(team: Team, menuItem: HomeMenuItem) {
        self.team = team
        self.menuItem = menuItem
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return menuItem.title as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? TeamActionSection else { return false }
        var isSameOwnership = true
        if let user = App.core.state.userState.currentUser {
            isSameOwnership = user.isOwnerOrManager(of: team) == user.isOwnerOrManager(of: other.team)
        }
        return team == other.team && menuItem.title == other.menuItem.title && isSameOwnership
    }
    
}

class TeamActionSectionController: IGListSectionController {
    
    var section: TeamActionSection!
    var user: User
    
    var didSelectItem: ((HomeMenuItem) -> Void) = { _ in }
    
    init(user: User) {
        self.user = user
        
        super.init()
        inset = UIEdgeInsets.zero
    }
    
}

extension TeamActionSectionController: IGListSectionType {
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        let fullWidth = collectionContext.containerSize.width
        let headerHeight = collectionContext.containerSize.width * (2 / 3)
        let hasEditRights = user.isOwnerOrManager(of: section.team)
        let rows: CGFloat = hasEditRights ? 3 : 4
        let height = (collectionContext.containerSize.height - headerHeight) / rows
        let width = hasEditRights ? fullWidth / section.menuItem.itemsPerRow : fullWidth
        
        return CGSize(width: width, height: height)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: HomeCollectionViewCell.reuseIdentifier, for: self, at: index) as! HomeCollectionViewCell
        cell.update(with: section.menuItem)
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        section = object as? TeamActionSection
    }
    
    func didSelectItem(at index: Int) {
        didSelectItem(section.menuItem)
    }
    
}
