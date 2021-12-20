//
//  StargazersSearchViewController.swift
//  Subito
//
//  Created by Ariel Congestri on 15/12/2021.
//
import UIKit

class StargazersSearchViewController: UIViewController, KeyboardDismissable,  UITextFieldDelegate {

    // MARK: - Properties
    private let viewModel: StargazersSearchViewModel
    private let minimumTextFieldSize: CGFloat = 50
    private var loadingView: UIView?

    private lazy var clearButton: StyledButton = {
        let button = StyledButton(style: .primary, size: .regular)
        button.setTitle(viewModel.clearFieldsButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(clearFieldsButtonDidTouchUpInside), for: .touchUpInside)
        return button
    }()

    private lazy var containerView: UIView = {
        return UIView()
    }()

    private lazy var getStargazersButton: StyledButton = {
        let button = StyledButton(style: .secondary, size: .regular)
        button.setTitle(viewModel.getStargazersButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(getStargazersButtonDidTouchUpInside), for: .touchUpInside)
        return button
    }()

    private lazy var repositoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.isAccessibilityElement = false
        label.text = viewModel.repositoryTextFieldTile
        return label
    }()

    private lazy var repositoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        textField.accessibilityLabel = viewModel.repositoryTextFieldTile + " Field"
        textField.adjustsFontForContentSizeCategory = true
        textField.font = .preferredFont(forTextStyle: .body)
        textField.placeholder = viewModel.repositoryTextFieldPlaceholder
        textField.addTarget(self, action: #selector(repositoryNameTextFieldValueDidChange), for: .editingDidEnd)
        textField.delegate = self
        return textField
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.isAccessibilityElement = false
        label.text = viewModel.userNameTextFieldTile
        return label
    }()

    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        textField.accessibilityHint = "Double Tap To Edit"
        textField.accessibilityLabel = viewModel.userNameTextFieldTile + " Field"
        textField.adjustsFontForContentSizeCategory = true
        textField.font = .preferredFont(forTextStyle: .body)
        textField.placeholder = viewModel.userNameTextFieldPlaceholder
        textField.addTarget(self, action: #selector(userNameTextFieldValueDidChange), for: .editingDidEnd)
        textField.delegate = self
        return textField
    }()

    // MARK: - Initializers
    init(viewModel: StargazersSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardOnTouchUpOutside()
        addSubviews()
        setUpConstraints()
        setUpUI()
        setUpBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTextField.text = nil
        repositoryNameTextField.text = nil
        viewModel.clearFields()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - Private Methods
private extension StargazersSearchViewController {

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(userNameTextField)
        containerView.addSubview(repositoryNameLabel)
        containerView.addSubview(repositoryNameTextField)
        containerView.addSubview(getStargazersButton)
        containerView.addSubview(clearButton)
        updateLoader()
    }

    private func setUpBindings() {
        viewModel.state.observe(observer: self) { [weak self] in
            self?.updateLoader()
            guard case let .failure(error) = $0 else { return }
            self?.showAlert(error: error)
        }

        viewModel.isGetStargazersButtonEnabled.observe(observer: self, shouldReadCurrent: true) { [weak self] in
            self?.getStargazersButton.isEnabled = $0
            self?.getStargazersButton.alpha = $0 ? 1 : 0.5
        }
    }

    private func setUpConstraints() {
        scrollView.pinEdges(to: view.safeAreaLayoutGuide)
        containerView.pinEdges(to: self.scrollView)
        containerView.pin(.width, to: scrollView, itemAttribute: .width)
            .pin(.height, to: scrollView, itemAttribute: .height, priority: .defaultLow)

        userNameLabel.pin( .top, to: containerView, itemAttribute: .top, constant: Spacing.medium.rawValue)
            .pin( .leading, to: containerView, itemAttribute: .leading, constant: Spacing.large.rawValue)
            .pin( .trailing, to: containerView, itemAttribute: .trailing, constant: -Spacing.large.rawValue)

        userNameTextField.pin( .top, to: userNameLabel, itemAttribute: .bottom, constant: Spacing.small.rawValue)
            .pin( .leading, to: containerView, itemAttribute: .leading, constant: Spacing.large.rawValue)
            .pin( .trailing, to: containerView, itemAttribute: .trailing, constant: -Spacing.large.rawValue)
            .pin(.height, priority: .required - 1, relation: .greaterThanOrEqual, constant: minimumTextFieldSize)

        repositoryNameLabel.pin( .top, to: userNameTextField, itemAttribute: .bottom, constant: Spacing.medium.rawValue)
            .pin( .leading, to: containerView, itemAttribute: .leading, constant: Spacing.large.rawValue)
            .pin( .trailing, to: containerView, itemAttribute: .trailing, constant: -Spacing.large.rawValue)

        repositoryNameTextField.pin( .top, to: repositoryNameLabel, itemAttribute: .bottom, constant: Spacing.small.rawValue)
            .pin( .leading, to: containerView, itemAttribute: .leading, constant: Spacing.large.rawValue)
            .pin( .trailing, to: containerView, itemAttribute: .trailing, constant: -Spacing.large.rawValue)
            .pin(.height, priority: .required - 1, relation: .greaterThanOrEqual, constant: minimumTextFieldSize)

        getStargazersButton.pin(
            .top,
            to: repositoryNameTextField,
            itemAttribute: .bottom,
            relation: .greaterThanOrEqual,
            constant: Spacing.medium.rawValue
        )
            .pin( .leading, to: containerView, itemAttribute: .leading, constant: Spacing.large.rawValue)
            .pin( .trailing, to: containerView, itemAttribute: .trailing, constant: -Spacing.large.rawValue)

        clearButton.pin( .top, to: getStargazersButton, itemAttribute: .bottom, constant: Spacing.medium.rawValue)
            .pin( .leading, to: containerView, itemAttribute: .leading, constant: Spacing.large.rawValue)
            .pin( .trailing, to: containerView, itemAttribute: .trailing, constant: -Spacing.large.rawValue)
            .pin(.bottom, to: containerView, itemAttribute: .bottom, relation: .lessThanOrEqual, constant: -Spacing.medium.rawValue)
        
    }

    private func setUpUI() {
        title = viewModel.title
        containerView.backgroundColor = .white
    }

    private func showAlert(error: ErrorViewData) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    private func updateLoader() {
        guard viewModel.shouldShowLoader else {
            loadingView?.removeFromSuperview()
            loadingView = nil
            return
        }
        loadingView?.removeFromSuperview()
        let loadingView = UIView()
        let indicator = UIActivityIndicatorView(style: .large)
        view.addSubview(loadingView)
        loadingView.addSubview(indicator)
        loadingView.pinEdges(to: view)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.pin(.centerX, to: loadingView, itemAttribute: .centerX)
            .pin(.centerY, to: loadingView, itemAttribute: .centerY)
        loadingView.backgroundColor = .init(white: 1, alpha: 0.6)
        self.loadingView = loadingView
    }
}

// MARK: - Selector Functions
extension StargazersSearchViewController {
    @objc func userNameTextFieldValueDidChange() {
        viewModel.userNameDidChange(userNameTextField.text)
    }

    @objc func repositoryNameTextFieldValueDidChange() {
        viewModel.repositoryNameDidChange(repositoryNameTextField.text)
    }


    @objc func getStargazersButtonDidTouchUpInside() {
        viewModel.getStargazers()
    }

    @objc func clearFieldsButtonDidTouchUpInside() {
        repositoryNameTextField.text = nil
        userNameTextField.text = nil
        viewModel.clearFields()
    }

}
