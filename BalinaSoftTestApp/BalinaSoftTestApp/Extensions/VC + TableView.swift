//
//  VC + TableView.swift
//  BalinaSoftTestApp
//
//  Created by Artyom Butorin on 25.09.23.
//

import UIKit
import AVFoundation

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let photoType = photoTypes[indexPath.row]
        cell.configure(with: photoType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhotoType = photoTypes[indexPath.row]
        
        selectedTypeId = selectedPhotoType.id
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("The camera is not available on the device")
            return
        }
        
        // Проверяем, разрешено ли использование камеры
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            self.openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.openCamera()
                    }
                } else {
                    print("Access to the camera is denied")
                }
            }
        default:
            print("The camera is inaccessible or access to the camera is denied")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            if !self.isLoading {
                self.loadData()
            }
        }
    }
}
