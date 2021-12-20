//
//  StargazersListViewController.swift
//  Subito
//
//  Created by Ariel Congestri on 19/12/2021.
//

import UIKit

class StargazersListViewController: UIViewController {

    // MARK: - Properties
    static let cellAccessibilityIdentifier = "StargazersListViewController.Cell"
    private lazy var tableView: UITableView = {
      return UITableView()
    }()

    private lazy var headerView: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .primaryBlue
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private let viewModel: StargazersListViewModel
    private let minimumLabelHeight: CGFloat = 50

    // MARK: - Initializers
    init(viewModel: StargazersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        addSubviews()
        setUpConstraints()
        setUpUI()
        configureTableView()
        setUpBindings()
    }

    deinit {
        viewModel.state.remove(observer: self)
    }
}
// MARK: - Private Methods
private extension StargazersListViewController {
    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(headerView)
    }

    func setUpConstraints() {
        
        headerView.pin(.top, to: view.safeAreaLayoutGuide, itemAttribute: .top)
            .pin(.leading, to: view.safeAreaLayoutGuide, itemAttribute: .leading)
            .pin(.trailing, to: view.safeAreaLayoutGuide, itemAttribute: .trailing)
            .pin(.height, relation: .greaterThanOrEqual, constant: minimumLabelHeight)

        tableView.pin(.top, to: headerView, itemAttribute: .bottom)
            .pin(.leading, to: view.safeAreaLayoutGuide, itemAttribute: .leading)
            .pin(.trailing, to: view.safeAreaLayoutGuide, itemAttribute: .trailing)
            .pin(.bottom, to: view.safeAreaLayoutGuide, itemAttribute: .bottom)
    }

    func setUpUI() {
        title = viewModel.title
        view.backgroundColor = .white
        headerView.text = viewModel.headerTitle
    }

    func configureTableView() {
        tableView.register(TitleImageCell.self, forCellReuseIdentifier: String(describing: TitleImageCell.self))
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 56.0
        tableView.dataSource = self
    }

    func setUpBindings() {
        viewModel.state.observe(observer: self) { [weak self] in
            guard let self = self else { return }
            self.headerView.text = self.viewModel.headerTitle
            switch $0 {
            case .success:
                self.tableView.reloadData()
            case let .failure(error):
                self.showAlert(error: error)
            default:
                break
            }
        }
    }

    func showAlert(error: ErrorViewData) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension StargazersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(forSections: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleImageCell.self))
        guard let cell = reusableCell as? TitleImageCell else {
            fatalError("Could not found cell")
        }
        let item = viewModel.getItem(forIndexPath: indexPath)
        let viewData = TitleImageCell.ViewData(
            title: item.userName,
            imageURL: item.imageURL,
            placeHolderImage: UIImage(named: "icon-image-placeholder"),
            emptyImage: UIImage(named: "no-image-icon"))
        cell.configure(with: viewData)
        cell.accessibilityIdentifier = StargazersListViewController.cellAccessibilityIdentifier
        return cell
    }
}
