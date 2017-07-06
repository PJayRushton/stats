//
//  StatsLayout.swift
//  Stats
//
//  Created by Parker Rushton on 7/7/17
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import UIKit

class StatsLayout: UICollectionViewLayout {
    
    static let headerHeight: CGFloat = 28.0
    var verticalSizeClass: UIUserInterfaceSizeClass?
    
    fileprivate var layoutInformation: [String : [IndexPath : UICollectionViewLayoutAttributes]]?
    fileprivate var maxColumns = 0
    
    fileprivate var rowHeight: CGFloat {
        guard let verticalSizeClass = verticalSizeClass else { return regularSize }
        if verticalSizeClass == .regular {
            return regularSize
        } else {
            return compactSize
        }
    }
    fileprivate var cellWidth: CGFloat {
        return regularSize
    }
    fileprivate let regularSize: CGFloat = 100.0
    fileprivate let compactSize: CGFloat = 80.0
    fileprivate let playerHeaderWidth: CGFloat = 150.0
    
    fileprivate let cellZIndex = 5
    fileprivate let supplementaryDecorationZIndex = 10
    fileprivate let supplementaryZIndex = 15
    fileprivate let roundHeaderZIndex = 25
    fileprivate let supplementaryRoundHeaderZIndex = 30
    fileprivate let roundHeaderDecorationZIndex = 20
    fileprivate let cellKey = "cell"
    
    fileprivate enum DecorationViewKind: String {
        case header = "StatsLayoutPlayerDecoration"
        case row = "StatsLayoutTypeDecoration"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        register(UINib(nibName: DecorationViewKind.header.rawValue, bundle: nil), forDecorationViewOfKind: DecorationViewKind.header.rawValue)
        register(UINib(nibName: DecorationViewKind.row.rawValue, bundle: nil), forDecorationViewOfKind: DecorationViewKind.row.rawValue)
    }
    
    override init() {
        super.init()
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { preconditionFailure("Must have sections to prepare layout") }
        let numberOfSections = collectionView.numberOfSections
        let numberOfPlayerSections = numberOfSections - 1
        guard numberOfPlayerSections > 0 else { return }
        
        maxColumns = 0
        var cellInformation = [IndexPath: UICollectionViewLayoutAttributes]()
        var headerInformation = [IndexPath: UICollectionViewLayoutAttributes]()
        var layoutInformation = [String: [IndexPath : UICollectionViewLayoutAttributes]]()
        var decorationInformation = [IndexPath: UICollectionViewLayoutAttributes]()
        
        for section in 0...numberOfPlayerSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            var columnsInRow = 0
            let yOrigin = section == 0 ? 0 : rowHeight * CGFloat(section - 1) + StatsLayout.headerHeight
            let height = section == 0 ? StatsLayout.headerHeight : rowHeight
            let zIndex = section == 0 ? supplementaryRoundHeaderZIndex : supplementaryZIndex
            let indexPath = IndexPath(item: 0, section: section)
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            headerAttributes.frame = CGRect(x: 0, y: yOrigin, width: playerHeaderWidth, height: height)
            headerAttributes.zIndex = zIndex
            headerInformation[indexPath] = headerAttributes
            
            if section != 0 {
                let rowAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: DecorationViewKind.row.rawValue, with: indexPath)
                rowAttributes.frame = CGRect(x: playerHeaderWidth, y: yOrigin, width: collectionView.bounds.size.width - playerHeaderWidth, height: height)
                decorationInformation[indexPath] = rowAttributes
            }
            
            for item in 0...numberOfItems - 1 {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: cellWidth * CGFloat(item) + playerHeaderWidth, y: yOrigin, width: cellWidth, height: height)
                if section == 0 {
                    attributes.zIndex = roundHeaderZIndex
                } else {
                    attributes.zIndex = cellZIndex
                }
                cellInformation[indexPath] = attributes
                columnsInRow += 1
            }
            
            if columnsInRow > maxColumns {
                maxColumns = columnsInRow
            }
        }
        let indexPath = IndexPath(item: 0, section: 0)
        let headerDecorationAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: DecorationViewKind.header.rawValue, with: indexPath)
        headerDecorationAttributes.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: StatsLayout.headerHeight)
        headerDecorationAttributes.zIndex = roundHeaderDecorationZIndex
        layoutInformation[DecorationViewKind.header.rawValue] = [indexPath : headerDecorationAttributes]

        layoutInformation[cellKey] = cellInformation
        layoutInformation[UICollectionElementKindSectionHeader] = headerInformation
        layoutInformation[DecorationViewKind.row.rawValue] = decorationInformation
        self.layoutInformation = layoutInformation
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { preconditionFailure("Must have collection view to prepare layout") }
        let numberOfSections = collectionView.numberOfSections
        let width = CGFloat(maxColumns) * cellWidth + playerHeaderWidth
        let maxWidth = width > collectionView.bounds.size.width ? width : collectionView.bounds.size.width
        let height = CGFloat(numberOfSections - 1) * rowHeight + StatsLayout.headerHeight
        return CGSize(width: maxWidth, height: height)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutInformation = layoutInformation, let collectionView = collectionView else {
            return []
//            preconditionFailure("Must have layout information to return attributes") }
        }
        let allAttributes = [UICollectionViewLayoutAttributes]()
        
        for (_, attributesDictionary) in layoutInformation {
            for (indexPath, attributes) in attributesDictionary {
                if indexPath.section == 0 {
                    var top = collectionView.contentOffset.y
                    if collectionView.contentOffset.y < 0 {
                        top = 0
                    }
                    attributes.frame = CGRect(x: attributes.frame.origin.x, y: top, width: attributes.frame.size.width, height: attributes.frame.size.height)
                }
                if attributes.representedElementKind == UICollectionElementKindSectionHeader {
                    attributes.frame = CGRect(x: collectionView.contentOffset.x, y: attributes.frame.origin.y, width: attributes.frame.size.width, height: attributes.frame.size.height)
                } else if let elementKind = attributes.representedElementKind, let decorationKind = DecorationViewKind(rawValue: elementKind) {
                    switch decorationKind {
                    case .header:
                        var height = StatsLayout.headerHeight
                        if collectionView.contentOffset.y < 0 {
                            height = abs(collectionView.contentOffset.y) + StatsLayout.headerHeight
                        }
                        attributes.frame = CGRect(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y, width: collectionView.bounds.size.width, height: height)
                    case .row:
                        attributes.frame = CGRect(x: playerHeaderWidth + collectionView.contentOffset.x, y: attributes.frame.origin.y, width: attributes.frame.size.width, height: attributes.frame.size.height)
                    }
                }
            }
        }
        return allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutInformation = layoutInformation else { return nil }
        if let attributesDictionary = layoutInformation[cellKey] {
            let attributes = attributesDictionary[indexPath]
            return attributes
        }
        return nil
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutInformation = layoutInformation else { return nil }
        if let attributesDictionary = layoutInformation[elementKind] {
            let attributes = attributesDictionary[indexPath]
            return attributes
        }
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutInformation = layoutInformation else { return nil }
        switch DecorationViewKind(rawValue: elementKind)! {
        case .header:
            if let attributesDictionary = layoutInformation[DecorationViewKind.header.rawValue], let attributes = attributesDictionary.values.first {
                return attributes
            }
        case .row:
            if let attributesDictionary = layoutInformation[DecorationViewKind.row.rawValue], let attributes = attributesDictionary[indexPath] {
                return attributes
            }
        }
        return nil
    }
    
}
