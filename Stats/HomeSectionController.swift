//
//  HomeSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 3/29/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class HomeSection: IGListDiffable {
    
    var team: Team
    
    init(team: Team) {
        self.team = team
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return team.id as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? HomeSection else { return false }
        return team.imageURLString == other.team.imageURLString && team.name == other.team.name
    }
    
}


class HomeSectionController: IGListSectionController {
    
    var section: HomeSection!
    var user: User
    
    var settingsPressed: (() -> Void) = { }
    var editPressed: (() -> Void) = { }
    var switchTeamPressed: (() -> Void) = { }
    
    init(user: User) {
        self.user = user
        super.init()
        inset = UIEdgeInsets.zero
    }
    
}

extension HomeSectionController: IGListSectionType {
    
    func numberOfItems() -> Int {
        return user.isOwnerOrManager(of: section.team) ? 6 : 5
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        let fullWidth = collectionContext.containerSize.width
        let headerHeight = collectionContext.containerSize.width * 0.65
        let rows: CGFloat = user.isOwnerOrManager(of: section.team) ? 3 : 4
        let height = (collectionContext.containerSize.height - headerHeight) / rows
        
        switch index {
        case 0:
            return CGSize(width: fullWidth, height: headerHeight)
        case 1:
            return CGSize(width: fullWidth, height: height)
        case _ where !user.isOwnerOrManager(of:section.team):
            return CGSize(width: fullWidth, height: height)
        default:
            return CGSize(width: fullWidth / 2, height: height)
        }
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        switch index {
        case 0:
            let cell = collectionContext?.dequeueReusableCell(withNibName: TeamHeaderCell.reuseIdentifier, bundle: nil, for: self, at: index) as! TeamHeaderCell
            cell.update(with:section.team, canEdit: user.isOwnerOrManager(of:section.team))
            return cell
            
        default:
            let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: HomeCollectionViewCell.reuseIdentifier, for: self, at: index) as! HomeCollectionViewCell
            let items = user.isOwnerOrManager(of:section.team) ? HomeMenuItem.managerItems : HomeMenuItem.fanItems
            cell.update(with: items[index])
            return cell
        }
    }
    
    func didUpdate(to object: Any) {
       section = object as? HomeSection
    }
    
    func didSelectItem(at index: Int) {
        return
    }
    
}
