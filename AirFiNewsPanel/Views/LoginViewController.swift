//
//  LoginViewController.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 21/07/25.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var syncBttn: UIButton!
    @IBOutlet weak var loginBttn: UIButton!

    // MARK: - Properties
    private let viewModel: LoginViewModel
    private var activityIndicator: UIActivityIndicatorView!

    // Dependency Injection (default for storyboard)
    required init?(coder: NSCoder) {
        self.viewModel = LoginViewModel()
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        textField.delegate = self
        setupActivityIndicator()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Safe to do after layout pass
        textField.setLeftPadding(14)

        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.05
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 4
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    // MARK: - UI Setup
    private func setupUI() {
        containerView.backgroundColor = .clear

        // TextField Styling (excluding layout-related attributes)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 0.8
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .white
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .label
        textField.placeholder = "Enter your username"
        textField.autocapitalizationType = .none
        textField.clipsToBounds = true

        // Sync Button Styling
        style(button: syncBttn, title: "Sync", backgroundColor: .systemIndigo)

        // Login Button Styling
        style(button: loginBttn, title: "Login", backgroundColor: .systemGreen)
    }

    private func style(button: UIButton, title: String, backgroundColor: UIColor) {
        button.layer.cornerRadius = 12
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
    }

    // MARK: - Actions
    @IBAction func syncTapped(_ sender: UIButton) {
        guard let username = textField.text, !username.isEmpty else {
            showAlert("Please enter username first.")
            return
        }

        syncBttn.isEnabled = false
        activityIndicator.startAnimating()

        viewModel.syncData { [weak self] result in
            DispatchQueue.main.async {
                self?.syncBttn.isEnabled = true
                self?.activityIndicator.stopAnimating()

                switch result {
                case .success(let success):
                    let message = success ? "Data synced successfully." : "Sync failed. Try again."
                    self?.showAlert(message)
                case .failure(let error):
                    self?.showAlert("Sync failed: \(error.localizedDescription)")
                }
            }
        }
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = textField.text, !username.isEmpty else {
            showAlert("Please enter username.")
            return
        }

        if viewModel.isDataSynced {
            activityIndicator.startAnimating()
            viewModel.storeLoginUser(username)
            navigateToNewsScreen(for: viewModel.getUserRole(for: username))
            activityIndicator.stopAnimating()
        } else {
            showAlert("Please sync the app.")
        }
    }

    // MARK: - Navigation
    private enum StoryboardIDs {
        static let authorNews = "AuthorNewsViewController"
        static let reviewerNews = "ReviewerNewsViewController"
    }

    private func navigateToNewsScreen(for role: UserRole) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcID = role == .author ? StoryboardIDs.authorNews : StoryboardIDs.reviewerNews
        let newsVC = storyboard.instantiateViewController(withIdentifier: vcID)

        startAutoSyncing()
        navigationController?.pushViewController(newsVC, animated: true)
    }

    // MARK: - Alerts
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Auto Sync
    private func startAutoSyncing() {
        AutoSyncManager.shared.startAutoSync {
            self.viewModel.performFullSync { result in
                switch result {
                case .success(let success):
                    print("Auto sync result: \(success)")
                case .failure(let error):
                    print("Auto sync failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
