//
//  AddPlaceViewController.swift
//  FoursquareClone
//
//  Created by Berkay YAY on 12.12.2022.
//

import UIKit
import Photos
import PhotosUI

class AddPlaceViewController: UIViewController,PHPickerViewControllerDelegate {

    
    @IBOutlet weak var placeNameLabel: UITextField!
    
    
    @IBOutlet weak var placeTypeLabel: UITextField!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
    }
    

    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if placeNameLabel.text != "" && placeTypeLabel.text != "" && commentLabel.text != "" {
            if let chosenImage = imageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameLabel.text!
                placeModel.placeType = placeTypeLabel.text!
                placeModel.placeComment = commentLabel.text!
                placeModel.placeImage = chosenImage
            }
        } else {
            self.makeAlert(title: "Error", message: "Place Name/Type/Comment not found.")
        }
        
       
        
        self.performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else{
                    return
                }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
//                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] url, error in
//                    print("Here is the url: \(url)")
//                }
            }
        }
    }
    
    @objc func selectImage(){
        var pickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        pickerConfig.selectionLimit = 1
        pickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        let pickerVC = PHPickerViewController(configuration: pickerConfig)
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    

}
