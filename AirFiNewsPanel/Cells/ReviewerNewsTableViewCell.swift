//
//  ReviewerNewsTableViewCell.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 22/07/25.
//

import UIKit

class ReviewerNewsTableViewCell: UITableViewCell {

    static let identifier = "ReviewerNewsTableViewCell"

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // Let the label wrap naturally
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let checkbox: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var checkboxTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(checkbox)
        contentView.addSubview(descriptionLabel)
        setupConstraints()
        checkbox.addTarget(self, action: #selector(handleCheckboxTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkbox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24),

            descriptionLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with article: ArticleMetadata, isSelected: Bool) {
        descriptionLabel.text = article.desc ?? "No Description"
        let imageName = isSelected ? "checkmark.square.fill" : "square"
        checkbox.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func handleCheckboxTap() {
        checkboxTapped?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        checkbox.setImage(UIImage(systemName: "square"), for: .normal)
    }
}
