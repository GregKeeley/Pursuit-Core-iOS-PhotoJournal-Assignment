//
//  ViewController.swift
//  PhotoJournalProject
//
//  Created by Gregory Keeley on 1/25/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import AVFoundation
import DataPersistence

class ViewController: UIViewController {
    
    //  cell reuseID: entryCell
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var journalEntries = [Entry]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var imagePickerController = UIImagePickerController()
    
    private var dataPersistence = DataPersistence<Entry>(filename: "entries.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadPhotos()
    }
    private func loadPhotos() {
        guard journalEntries.isEmpty else {
            showAlert(title: "There are no photos", message: "Please add photos in the add photo tab")
            return
        }
        do {
            journalEntries = try dataPersistence.loadItems()
        } catch {
            showAlert(title: "Error", message: "There was an error loading the photo: \(error)")
        }
    }
    
    
}
extension UICollectionViewDelegate {
    
}
extension UICollectionViewDataSource {
    
}
extension UICollectionViewDelegateFlowLayout {
    
}
extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
