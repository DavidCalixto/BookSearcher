//
//  BookViewCell.swift
//  BookSearcher
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import UIKit
import Combine

class BookViewCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let coverImageView = UIImageView()
    private var cancellable: AnyCancellable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }
}
extension BookViewCell {
    func bind(to viewModel: BookViewModel) {
           cancelImageLoading()
           titleLabel.text = viewModel.description
           cancellable = viewModel.cover.sink { [weak self] image in self?.showImage(image: image) }
       }

       private func showImage(image: UIImage?) {
           cancelImageLoading()
           UIView.transition(with: self.coverImageView,
           duration: 0.3,
           options: [.curveEaseOut, .transitionCrossDissolve],
           animations: {
               self.coverImageView.image = image
           })
       }

       private func cancelImageLoading() {
           coverImageView.image = nil
           cancellable?.cancel()
       }
}
extension BookViewCell {
    func configure() {

        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .systemIndigo
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        coverImageView.layer.cornerRadius = 8
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        
        
        let stackView = UIStackView(arrangedSubviews: [coverImageView, titleLabel ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layoutMargins =   contentView.layoutMargins
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                    ])
        stackView.setCustomSpacing(5, after: coverImageView)

    }
}
