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
        guard let other = object as? TeamHeaderSection, let currentUser = App.core.state.userState.currentUser else { return false }
        return team.imageURLString == other.team.imageURLString &&
            team.name == other.team.name &&
            currentUser.owns(team) == currentUser.owns(other.team) &&
            team.currentSeason == other.team.currentSeason
    }
    
}


class TeamHeaderSectionController: IGListSectionController {
    
    var section: TeamHeaderSection!
    
    var settingsPressed: () -> Void = { }
    var editPressed: (() -> Void) = { }
    var switchTeamPressed: (() -> Void) = { }
    var seasonPressed: (() -> Void) = { }
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
        guard let user = App.core.state.userState.currentUser else { fatalError() }
        cell.update(with: section.team, canEdit: user.owns(section.team))
        cell.settingsPressed = settingsPressed
        cell.editPressed = editPressed
        cell.switchTeamPressed = switchTeamPressed
        cell.seasonPressed = seasonPressed
        return cell
    }
    
    func didUpdate(to object: Any) {
       section = object as? TeamHeaderSection
    }
    
    func didSelectItem(at index: Int) {
        return
    }
    
}
