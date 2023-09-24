//
//  ViewController.swift
//  BalinaSoftTestApp
//
//  Created by Artyom Butorin on 24.09.23.
//

import UIKit

class ViewController: UIViewController {
    
    let developerName: String = "Butorin Artyom"
    let baseURL: String = "https://junior.balinasoft.com/"
    
    lazy var photoTypes: [PhotoType] = []
    
    lazy var selectedTypeId: Int = 0
    lazy var isLoading: Bool = false
    lazy var isLastPage: Bool = false
    
    private lazy var currentPage: Int = 0
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.frame = view.bounds
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.tableView)
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.loadData()
    }
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadData() {
        guard !isLoading && !isLastPage else {
            return
        }
        
        self.isLoading = true
        
        let session = URLSession.shared
        guard let pageURL = URL(string: "\(self.baseURL)api/v2/photo/type?page=\(self.currentPage)") else { return }
        
        let task = session.dataTask(with: pageURL) { [weak self] (data, response, error) in

            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let photoTypeResponse = try decoder.decode(PhotoTypeResponse.self, from: data)
                    print(photoTypeResponse)
                    self?.photoTypes += photoTypeResponse.content
                    self?.currentPage += 1
                    
                    if (photoTypeResponse.page + 1) >= photoTypeResponse.totalPages {
                        self?.isLastPage = true
                    }
                    
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.tableView.reloadData()
                    }
                } catch {
                    print("Error decode JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func sendPhotoToServer(selectedTypeId: Int, selectedImage: UIImage) {
        
        guard
            let photo = selectedImage.jpegData(compressionQuality: 1.0),
            let url = URL(string: "\(self.baseURL)api/v2/photo")
        else {
            print("Error photo or url")
            return
        }
        
        let photoData = PhotoUploadData(name: developerName, typeId: selectedTypeId, photo: photo)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
        
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"typeId\"\r\n\r\n".data(using: .utf8)!)
        httpBody.append("\(photoData.typeId)\r\n".data(using: .utf8)!)
        
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        httpBody.append("\(photoData.name)\r\n".data(using: .utf8)!)
        
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpeg\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        httpBody.append(photoData.photo)
        httpBody.append("\r\n".data(using: .utf8)!)
        
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = httpBody as Data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending POST request: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let responseDict = json as? [String: String], let id = responseDict["id"] {
                        print("Успешно загружено. ID: \(id)")
                    }
                } catch {
                    print("JSON parsing error: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
}

