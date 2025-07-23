//
//  AuthorNewsTableViewCell.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 22/07/25.
//

import UIKit

class AuthorNewsTableViewCell: UITableViewCell {

    static let identifier = "AuthorNewsTableViewCell"

    // MARK: - UI Components

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let approveCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(approveCountLabel)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            approveCountLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            approveCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            approveCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            approveCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        approveCountLabel.text = nil
    }

    // MARK: - Configure

    func configure(with description: String, approveCount: Int) {
        descriptionLabel.text = description
        approveCountLabel.text = "Approved by \(approveCount) user(s)"
    }
}
