//
//  StickyHeaderViewController.swift
//  StickyHeader
//
//  Created by Nabiilah Fasih on 2018-06-23.
//  Copyright © 2018 Nabiilah Fasih. All rights reserved.
//

import UIKit

class StickyHeaderViewController: UIViewController
{
    let columnTitles = ["", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let rowTitles = ["", "7:00am", "8:00am", "9:00am", "10.00am", "11.00am", "12.00pm", "1.00pm", "2.00pm", "3.00pm", "4.00pm", "5.00pm", "6.00pm"]
}

extension StickyHeaderViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //Each item corresponds to a column
        return columnTitles.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        //Each section corresponds to a row
        return rowTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SampleCell", for: indexPath) as! SampleCollectionViewCell
        
        let row = indexPath.section
        let column = indexPath.item
        var contents = "contents"
        
        switch (row, column)
        {
            case (0, _): contents = columnTitles[column]
            case (_, 0): contents = rowTitles[row]
            default: break
        }
        
        cell.detailsLabel.text = contents
        
        return cell
    }
}

