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
    private let lineBreak = "\n\n"
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
        addCircleButton()
        textViewLayout()
        addKeyboardObserver()
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addKeyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addKeyboardWiilHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func addCircleButton() {
        let circleButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(presentActionSheet))
        
        navigationItem.rightBarButtonItem = circleButton
    }
    
    @objc private func presentActionSheet() {
        let actionsheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shared = UIAlertAction(title: "Share...", style: .default, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionsheetController.addAction(shared)
        actionsheetController.addAction(delete)
        actionsheetController.addAction(cancel)
        
        present(actionsheetController, animated: true, completion: nil)
    }
    
    @objc private func addKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        
        detailTextView.contentInset.bottom = keyboardFrame.height
        detailTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func addKeyboardWiilHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        detailTextView.contentInset = contentInset
        detailTextView.scrollIndicatorInsets = contentInset
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
    func didTapTableItem(data: Memo) {
        detailTextView.text = data.title + lineBreak + data.description
        detailTextViewControllerDelegate?.showDetailTextView()
    }
}
