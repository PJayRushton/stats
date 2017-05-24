//
//  HomeSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class TeamHeaderSection: ListDiffable {
    
    var team: Team
    
    init(team: Team) {
        self.team = team
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return team.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? TeamHeaderSection, let currentUser = App.core.state.userState.currentUser else { return false }
        return team.imageURLString == other.team.imageURLString &&
            team.name == other.team.name &&
            currentUser.owns(team) == currentUser.owns(other.team) &&
            team.currentSeason == other.team.currentSeason
    }
    
}


class TeamHeaderSectionController: ListSectionController {
    
    var headerSection: TeamHeaderSection!
    
    var settingsPressed: () -> Void = { }
    var editPressed: (() -> Void) = { }
    var switchTeamPressed: (() -> Void) = { }
    var seasonPressed: (() -> Void) = { }
}

extension TeamHeaderSectionController {
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        let fullWidth = collectionContext.containerSize.width
        let height = collectionContext.containerSize.width * (2 / 3)
        return CGSize(width: fullWidth, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: TeamHeaderCell.reuseIdentifier, bundle: nil, for: self, at: index) as! TeamHeaderCell
        guard let user = App.core.state.userState.currentUser else { fatalError() }
        cell.update(with: headerSection.team, canEdit: user.owns(headerSection.team))
        cell.settingsPressed = settingsPressed
        cell.editPressed = editPressed
        cell.switchTeamPressed = switchTeamPressed
        cell.seasonPressed = seasonPressed
        return cell
    }
    
    override func didUpdate(to object: Any) {
       headerSection = object as? TeamHeaderSection
    }
    
}
