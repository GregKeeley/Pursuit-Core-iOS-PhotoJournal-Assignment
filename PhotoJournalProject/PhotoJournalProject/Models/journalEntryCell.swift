//
//  journalEntryCell.swift
//  PhotoJournalProject
//
//  Created by Gregory Keeley on 1/25/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

protocol JournalEntryCellDelegate: AnyObject {
    func didLongPress(_ journalEntryCell: JournalEntryCell, entry: Entry)
    
}

class JournalEntryCell: UICollectionViewCell {
    
    @IBOutlet weak var journalImage: UIImageView!
    @IBOutlet weak var entryNameLabel: UILabel!

    weak var delegate: JournalEntryCellDelegate?
    private var entryForDelegate: Entry?
        
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
         let gesture = UILongPressGestureRecognizer()
         gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
         return gesture
     }()
    
    @objc private func longPressAction(gesture: UILongPressGestureRecognizer) {
        
//        guard let entryForDelegate = entryForDelegate else {
//            return
//        }
        
     
        if gesture.state == .began {
            gesture.state = .cancelled
            return
        }
        
        delegate?.didLongPress(self, entry: entryForDelegate!)
                        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        backgroundColor = .darkGray
        addGestureRecognizer(longPressGesture)
    }
    func configureCell(entry: Entry) {
        guard let image = UIImage(data: entry.imageData!) else {
            return
        }
        entryForDelegate = entry
        print("caption: \(entry.caption)")
        
        journalImage.image = image
        entryNameLabel.text = entry.caption
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        journalImage.image = nil
    }
    
}
