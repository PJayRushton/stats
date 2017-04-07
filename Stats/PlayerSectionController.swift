//
//  PlayerSectionController.swift
//  Stats
//
//  Created by Parker Rushton on 4/7/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import IGListKit

class PlayerSection: IGListDiffable {
    
    var player: Player
    
    init(player: Player) {
        self.player = player
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return player.id as NSString
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? PlayerSection else { return false }
        return player == other.player &&
            player.name == other.player.name &&
            player.order == other.player.order &&
            player.jerseyNumber == other.player.jerseyNumber &&
            player.isSub == other.player.isSub
    }
    
}

class PlayerSectionController: IGListSectionController {
    
    var section: PlayerSection!
    
    var didSelectPlayer: ((Player) -> Void) = { _ in }
    var didUpPlayer: ((Player) -> Void) = { _ in }
    
    init(insets: UIEdgeInsets = .zero) {
        super.init()
        inset = insets
    }
    
}

extension PlayerSectionController: IGListSectionType {
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let collectionContext = collectionContext else { return .zero }
        let fullWidth = collectionContext.containerSize.width
        return CGSize(width: fullWidth, height: 50)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: PlayerCell.reuseIdentifier, bundle: nil, for: self, at: index) as! PlayerCell
        cell.update(with: section.player)
        cell.upButtonPressed = {
            self.didUpPlayer(self.section.player)
        }
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        section = object as? PlayerSection
    }
    
    func didSelectItem(at index: Int) {
        didSelectPlayer(section.player)
    }
    
}

