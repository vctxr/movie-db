//
//  BottomMenuView.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 13/12/20.
//

import UIKit

protocol BottomMenuViewDelegate: AnyObject {
    func didSelect(menu: MenuOption)
}

final class BottomMenuView: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: tableView.contentSize.height)
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    weak var delegate: BottomMenuViewDelegate?
    var isPresented = false
    var menuOptions: [MenuOption] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var heightConstraint: NSLayoutConstraint!
    private var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            tableView.reloadRows(at: [oldValue, selectedIndexPath], with: .automatic)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(in view: UIView, above anchorView: UIView) {
        view.addSubview(self)

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: anchorView.topAnchor),
        ])
        view.layoutIfNeeded()
        
        heightConstraint?.constant = intrinsicContentSize.height
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            view.layoutIfNeeded()
        } completion: { _ in
            self.isPresented = true
        }
    }
    
    func dismiss() {
        guard let superview = superview else { return }
        heightConstraint.constant = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            superview.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
            self.isPresented = false
        }
    }
}


// MARK: - Table View Delegate and Data Source

extension BottomMenuView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuOptions[indexPath.row].title
        
        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        delegate?.didSelect(menu: menuOptions[indexPath.row])
        dismiss()
    }
}


// MARK: - Configurations

extension BottomMenuView {
    
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: -5)
    }
    
    private func configureLayout() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
