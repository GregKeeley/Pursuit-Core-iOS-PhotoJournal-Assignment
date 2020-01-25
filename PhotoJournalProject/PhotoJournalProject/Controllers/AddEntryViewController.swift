//
//  AddEntryVeiwController.swift
//  PhotoJournalProject
//
//  Created by Gregory Keeley on 1/25/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import AVFoundation
import DataPersistence

class AddEntryViewController: UIViewController {

    @IBOutlet weak var entryTextField: UITextField!
    
    private var newJournalEntry: Entry?
    private var selectedImage: UIImage? {
        didSet {
            appendNewImageToCollection()
        }
    }
    private let dataPersistence = DataPersistence<Entry>(filename: "entries.plist")
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    private func appendNewImageToCollection() {
        guard let image = selectedImage else {
            print("Image is nil")
            return
        }
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        guard let resizedImageData = resizedImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        let entryObject = Entry(imageData: resizedImageData, date: Date(), caption: entryTextField.text ?? "")
        do {
            try dataPersistence.createItem(entryObject)
        } catch {
            print("Error saving journal entry: \(error)")
        }
    }

}
