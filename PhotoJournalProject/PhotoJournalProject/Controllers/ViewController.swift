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
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "JournalEntryCell", bundle: nil), forCellWithReuseIdentifier: "entryCell")
        
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
extension ViewController: UICollectionViewDelegate {
    
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        journalEntries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as? JournalEntryCell else {
            fatalError("failed to downcast as JournalEntryCell")
        }
        cell.configureCell(entry: journalEntries[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    
}
extension ViewController: JournalEntryCellDelegate {
    func didLongPress(_ journalEntryCell: JournalEntryCell, entry: Entry) {
        print("long press")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertAction in self.deleteEntry(entry)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
        
    private func deleteEntry(_ entry: Entry) {
        guard let index = journalEntries.firstIndex(of: entry) else {
            return
        }
        do {
            try dataPersistence.deleteItem(at: index)
        } catch {
            print("error: \(error)")
        }
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize = UIScreen.main.bounds
        return CGSize(width: maxSize.width, height: maxSize.width)
    }
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
