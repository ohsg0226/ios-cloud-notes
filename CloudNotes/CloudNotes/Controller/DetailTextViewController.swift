//
//  DetailTextViewController.swift
//  CloudNotes
//
//  Created by 오승기 on 2021/09/03.
//

import UIKit

protocol DetailTextViewControllerDelegate: AnyObject {
    func showDetailTextView()
}

class DetailTextViewController: UIViewController {
    
    static let identifier = "DetailTextViewController"
    weak var detailTextViewControllerDelegate: DetailTextViewControllerDelegate?
    
    private let detailTextView: UITextView = {
        let detailTextView = UITextView()
        detailTextView.font = UIFont.systemFont(ofSize: 18)
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        
        return detailTextView
    }()
    
    private func addView() {
        view.addSubview(detailTextView)
    }
    
    override func viewDidLoad() {
        addView()
        textViewLayout()
    }
    
    private func textViewLayout() {
        NSLayoutConstraint.activate([
            detailTextView.topAnchor.constraint(equalTo: view.topAnchor),
            detailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension DetailTextViewController: MenuTableViewControllerDelegate {
    func didTapTableItem(data: String) {
        detailTextView.text = data
        detailTextViewControllerDelegate?.showDetailTextView()
    }
}
