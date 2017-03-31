//
//  HomeSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class HomeSection: IGListDiffable {
    
    var team: Team!
    
    func diffIdentifier() -> NSObjectProtocol {
        return teamId
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? Team else { return false }
        return image == other.image &&
            name == other.name &&
            type == other.type &&
            currentSeasonId == other.currentSeasonId
    }
    
}


class HomeSectionController: IGListSectionController {
    
    var section: HomeSection!
    var user: User
    
    var settingsPressed: (() -> Void) = { }
    var editPressed: (() -> Void) = { }
    var switchTeamPressed: (() -> Void) = { }
    
    init(user: User) {
        super.init()
        self.user = user
        inset = UIEdgeInsets.zero
    }
    
}

extension HomeSectionController: IGListSectionType {
    
    func numberOfItems() -> Int {
        return user.isOwnerOrManager(of: team) ? 6 : 5
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        let fullWidth = collectionContext.containerSize.width
        let headerHeight = collectionContext.containerSize.width * 0.65
        let rows: CGFloat = user.isOwnerOrManager(of: team) ? 3 : 4
        let height = (collectionContext.containerSize.height - headerHeight) / rows
        
        switch index {
        case 0:
            return CGSize(width: fullWidth, height: headerHeight)
        case 1:
            return CGSize(width: fullWidth, height: height)
        case _ where !user.isOwnerOrManager(of: team):
            return CGSize(width: fullWidth, height: height)
        default:
            return CGSize(width: fullWidth / 2, height: height)
        }
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        switch index {
        case 0:
            let cell = collectionContext?.dequeueReusableCell(withNibName: TeamHeaderCell.reuseIdentifier, bundle: nil, for: self, at: index) as! TeamHeaderCell
            cell.update(with: team, canEdit: user.isOwnerOrManager(of: team))
            return cell
            
        default:
            let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: HomeCollectionViewCell.reuseIdentifier, for: self, at: index) as! HomeCollectionViewCell
            let items = user.isOwnerOrManager(of: team) ? HomeMenuItem.managerItems : HomeMenuItem.fanItems
            cell.update(with: items[index])
            return cell
        }
    }
    
    func didUpdate(to object: Any) {
        team = object as? Team
    }
    
    func didSelectItem(at index: Int) {
        return
    }
    
}
