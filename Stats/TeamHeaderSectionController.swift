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
    var season: Season?
    
    init(team: Team, season: Season?) {
        self.team = team
        self.season = season
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return team.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? TeamHeaderSection, let currentUser = App.core.state.userState.currentUser else { return false }
        return team.imageURLString == other.team.imageURLString &&
            team.name == other.team.name &&
            currentUser.owns(team) == currentUser.owns(other.team) &&
            season == other.season
    }
    
}


class TeamHeaderSectionController: ListSectionController {
    
    var headerSection: TeamHeaderSection!
    
    var settingsPressed: () -> Void = { }
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
        let userCanSwitchTeams = user.allTeamIds.count > 1
        cell.update(with: headerSection.team, season: headerSection.season, canSwitch: userCanSwitchTeams)
        cell.settingsPressed = settingsPressed
        cell.switchTeamPressed = switchTeamPressed
        cell.seasonPressed = seasonPressed
        return cell
    }
    
    override func didUpdate(to object: Any) {
       headerSection = object as? TeamHeaderSection
    }
    
}
