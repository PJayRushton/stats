//
//  HomeSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class TeamHeaderSection: IGListDiffable {
    
    var team: Team
    
    init(team: Team) {
        self.team = team
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return team.id as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? TeamHeaderSection else { return false }
        return team.imageURLString == other.team.imageURLString && team.name == other.team.name
    }
    
}


class TeamHeaderSectionController: IGListSectionController {
    
    var section: TeamHeaderSection!
    var user: User
    
    var settingsPressed: () -> Void = { }
    var editPressed: (() -> Void) = { }
    var switchTeamPressed: (() -> Void) = { }
    
    init(user: User) {
        self.user = user
        super.init()
        inset = UIEdgeInsets.zero
    }
    
}

extension TeamHeaderSectionController: IGListSectionType {
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        let fullWidth = collectionContext.containerSize.width
        let height = collectionContext.containerSize.width * (2 / 3)
        return CGSize(width: fullWidth, height: height)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: TeamHeaderCell.reuseIdentifier, bundle: nil, for: self, at: index) as! TeamHeaderCell
        cell.update(with: section.team, canEdit: user.isOwnerOrManager(of:section.team))
        cell.settingsPressed = settingsPressed
        cell.editPressed = editPressed
        cell.switchTeamPressed = switchTeamPressed
        
        return cell
    }
    
    func didUpdate(to object: Any) {
       section = object as? TeamHeaderSection
    }
    
    func didSelectItem(at index: Int) {
        return
    }
    
}
