//
//  LetterCell.swift
//  Word Search
//
//  Created by Abby Martin on 2020-05-11.
//  Copyright © 2020 Abby Martin. All rights reserved.
//

import UIKit
class WordSearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var letterLabel: UILabel!
    func setCellToCrossedOff() {
        self.backgroundColor = UIColor.darkGray;
    }
    
    func setCellToSelected() {
        self.backgroundColor = UIColor.red;
    }
    
    func setCellToUnselected() {
        self.backgroundColor = UIColor.gray;
    }
}
