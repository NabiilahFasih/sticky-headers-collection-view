//
//  StickyHeaderFlowLayout.swift
//  StickyHeader
//
//  Created by Nabiilah Fasih on 2018-06-23.
//  Copyright © 2017 Nabiilah Fasih. All rights reserved.
//

import UIKit

//NOTES: 
// indexpath.section corresponds to a row, indexpath.item corresponds to a column

class StickyHeaderFlowLayout: UICollectionViewFlowLayout
{
    private var cellAttributesDict = [IndexPath: UICollectionViewLayoutAttributes]()
    private var initialLayout = true
    
    private var itemWidth: CGFloat
    {
        return itemSize.width
    }
    
    private var itemHeight: CGFloat
    {
        return itemSize.height
    }
    
    private var spacing: CGFloat
    {
        return minimumInteritemSpacing
    }
    
    override var collectionViewContentSize: CGSize
    {
        get
        {
            let width = CGFloat(self.collectionView!.numberOfItems(inSection: 0)) * (itemWidth + spacing) + spacing
            let height = CGFloat(self.collectionView!.numberOfSections) * (itemHeight + spacing)
            return CGSize(width: width, height: height)
        }
    }
    
    override func prepare()
    {
        if initialLayout
        {
            //Set attributes for all cells
        
            let numberOfRows = collectionView!.numberOfSections
            
            for row in 0...numberOfRows-1
            {
                let numberOfColumns = collectionView!.numberOfItems(inSection: row)
                
                for column in 0...numberOfColumns-1
                {
                    let indexPath = IndexPath(item: column, section: row)
                    let x = CGFloat(column) * (itemWidth + spacing)
                    let y = CGFloat(row) * (itemHeight + spacing)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
                    
                    //Make sure to bring the header row/column to front with zIndex
                    
                    if row == 0 && column == 0
                    {
                        attributes.zIndex = 3
                    }
                    else if row == 0 || column == 0
                    {
                        attributes.zIndex = 2
                    }
                    else
                    {
                        attributes.zIndex = 1
                    }
                    
                    cellAttributesDict[indexPath] = attributes
                }
            }
            
            initialLayout = false
        }
        else
        {
            let currentXOffset = collectionView!.contentOffset.x
            let currentYOffset = collectionView!.contentOffset.y
            let numberOfRows = collectionView!.numberOfSections
            
            //Header column
            for row in 0...numberOfRows
            {
                let indexPath = IndexPath(item: 0, section: row)
                if let attributes = cellAttributesDict[indexPath]
                {
                    //Update x-position to follow the user's scroll
                    var frame = attributes.frame
                    frame.origin.x = currentXOffset
                    attributes.frame = frame
                }
            }
            
            ///TODO
            for row in 0...numberOfRows-1
            {
                //Header row
                if row == 0
                {
                    let numberOfColumns = collectionView!.numberOfItems(inSection: row)
                    
                    for column in 0...numberOfColumns-1
                    {
                        let indexPath = IndexPath(item: column, section: row)
                        if let attributes = cellAttributesDict[indexPath]
                        {
                            //Update y-position to follow the user's scroll
                            var frame = attributes.frame
                            frame.origin.y = currentYOffset
                            
                            //Also update x-position for top left corner cell
                            if column == 0
                            {
                                frame.origin.x = currentXOffset
                            }
                            
                            attributes.frame = frame
                        }
                    }
                }
                else
                {
                    //Header column
                    let indexPath = IndexPath(item: 0, section: row)
                    if let attributes = cellAttributesDict[indexPath]
                    {
                        //Update x-position to follow the user's scroll
                        var frame = attributes.frame
                        frame.origin.x = currentXOffset
                        attributes.frame = frame
                    }
                }
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        return cellAttributesDict[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        for attribute in cellAttributesDict.values
        {
            if rect.intersects(attribute.frame)
            {
                attributesInRect.append(attribute)
            }
        }
        return attributesInRect
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool
    {
        return true
    }
}
