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
    @IBOutlet weak var selectedImageView: UIImageView!
    
    private var newJournalEntry: Entry?
    private var imagePickerController = UIImagePickerController()
    private var selectedImage: UIImage? /*{
        didSet {
            DispatchQueue.main.async {
                print("Image selected")
                self.selectedImageView.image = self.selectedImage
            }
        }
    } */
    private let dataPersistence = DataPersistence<Entry>(filename: "entries.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
    private func appendNewEntryToCollection() {
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
            print("Entry saved")
        } catch {
            print("Error saving journal entry: \(error)")
        }
    }
    @IBAction func libraryPressed() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    @IBAction func cameraPressed() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true)
        } else {
            showAlert(title: "No camera available", message: "Please select Photo library to add an image")
        }
    }
    @IBAction func saveButtonPressed() {
        appendNewEntryToCollection()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}
extension AddEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newJournalEntry?.caption = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        newJournalEntry?.caption = textField.text ?? ""
    }
}

extension AddEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        selectedImageView.image = image
        print("Image selected")
        imagePickerController.dismiss(animated: true)
    }
    
}
