//
//  journalEntryCell.swift
//  PhotoJournalProject
//
//  Created by Gregory Keeley on 1/25/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

protocol JournalEntryCellDelegate: AnyObject {
    func didLongPress(_ journalEntryCell: JournalEntryCell)
}

class JournalEntryCell: UICollectionViewCell {
    @IBOutlet weak var entryImage: UIImageView!
    weak var delegate: JournalEntryCellDelegate?
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
         let gesture = UILongPressGestureRecognizer()
         gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
         return gesture
     }()
    @objc private func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            gesture.state = .cancelled
            return
        }
        delegate?.didLongPress(self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        backgroundColor = .darkGray
        addGestureRecognizer(longPressGesture)
    }
    func configureCell(entry: Entry) {
        guard let image = UIImage(data: entry.imageData) else {
            return
        }
        entryImage.image = image
    }
    
    
}
