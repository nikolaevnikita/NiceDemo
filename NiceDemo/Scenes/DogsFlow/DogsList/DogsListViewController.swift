//
//  DogsListViewController.swift
//  NiceDemo
//
//  Created by Serhii Kharauzov on 3/9/18.
//  Copyright © 2018 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

class DogsListViewController: BaseViewController {
    
    // MARK: Properties

    var presenter: DogsListPresentation!
    lazy var customView = view as! DogsListView
    
    // MARK: Lifecycle
    
    override func loadView() {
        view = DogsListView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        registerTableViewForForceTouchInteractions()
        showNavigationBar()
        presenter.onViewDidLoad()
    }
    
    // MARK: Public methods
    
    func setPresenter(_ presenter: DogsListPresentation) {
        self.presenter = presenter
    }
    
    func registerTableViewForForceTouchInteractions() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: customView.tableView)
        }
    }
    
    func setupNavigationItem() {
        navigationItem.title = "List of dogs"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    }
}

extension DogsListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let tableView = previewingContext.sourceView as? UITableView else {
            return nil
        }
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        return presenter.getGalleryViewForItem(at: indexPath)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let viewController = (viewControllerToCommit as? UINavigationController)?.viewControllers[0] {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: DogsListViewInterface

extension DogsListViewController: DogsListViewInterface {
    func reloadData() {
        customView.reloadDataInTableView()
    }
    
    func setTableViewProvider(_ provider: TableViewProvider) {
        customView.setTableViewProvider(provider)
    }
    
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
    
    func showHUD(animated: Bool) {
        customView.showHUD(animated: animated)
    }
    
    func hideHUD(animated: Bool) {
        customView.hideHUD(animated: animated)
    }
}