//
//  TableViewCell.swift
//  BalinaSoftTestApp
//
//  Created by Artyom Butorin on 24.09.23.
//

import UIKit

class TableViewCell: UITableViewCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(self.nameLabel)
        addSubview(self.thumbnailImageView)
        
        self.constraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with photoType: PhotoType) {
        self.nameLabel.text = "\(photoType.id). \(photoType.name)"

        if let imageURLString = photoType.image {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURLString) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            self.thumbnailImageView.image = nil

        }
    }

    private func constraints() {
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            self.nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            self.thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            self.thumbnailImageView.widthAnchor.constraint(equalToConstant: 40), // Ширина изображения
            self.thumbnailImageView.heightAnchor.constraint(equalToConstant: 40), // Высота изображения
            self.thumbnailImageView.topAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: 5), // Отступ от названия
            self.thumbnailImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5) // Ограничение снизу
        ])
    }
}

