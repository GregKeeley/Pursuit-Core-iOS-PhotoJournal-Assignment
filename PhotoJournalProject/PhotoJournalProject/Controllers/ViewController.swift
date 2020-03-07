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
                self.collectionView.reloadData()
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
    private func loadPhotos() {
        do {
            journalEntries = try dataPersistence.loadItems().reversed()
        } catch {
            showAlert(title: "Error", message: "There was an error loading the photo: \(error)")
        }
    }
    @IBAction func segueToAddEntryVC(_ sender: UIBarButtonItem) {
        guard let AddEntryVC = storyboard?.instantiateViewController(identifier: "AddEntryViewController") as? AddEntryViewController else { return }
        AddEntryVC.delegate = self
        present(AddEntryVC, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        journalEntries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as? JournalEntryCell else {
            fatalError("failed to downcast as JournalEntryCell")
        }
        cell.delegate = self
        cell.configureCell(entry: journalEntries[indexPath.row])
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
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = maxWidth * 0.95
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}

extension ViewController: EntryCreatedDelegate {
    func entryCreated(entry: Entry) {
        journalEntries.append(entry)
        loadPhotos()
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
