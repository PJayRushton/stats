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
        return team == other.team && menuItem.title == other.menuItem.title
    }
    
}

class TeamActionSectionController: IGListSectionController {
    
    var section: TeamActionSection!
    var user: User
    
    var didSelectItem: ((Int) -> Void) = { _ in }
    
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
        let headerHeight = collectionContext.containerSize.width * 0.65
        let rows: CGFloat = user.isOwnerOrManager(of: section.team) ? 3 : 4
        let height = (collectionContext.containerSize.height - headerHeight) / rows
        let width = fullWidth / section.menuItem.itemsPerRow
        
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
        didSelectItem(index)
    }
    
}
