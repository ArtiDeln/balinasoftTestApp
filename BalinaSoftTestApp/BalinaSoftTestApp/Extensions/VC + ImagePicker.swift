//
//  VC + ImagePicker.swift
//  BalinaSoftTestApp
//
//  Created by Artyom Butorin on 25.09.23.
//

import UIKit

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            sendPhotoToServer(selectedTypeId: selectedTypeId, selectedImage: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
