//
//  MenuTableViewController.swift
//  CloudNotes
//
//  Created by 오승기 on 2021/09/03.
//

import UIKit

protocol MenuTableViewControllerDelegate: AnyObject {
    func didTapTableItem(data: Memo)
}

class MenuTableViewController: UITableViewController {
    
    private weak var delegate: MenuTableViewControllerDelegate?
    private var memoList = [Memo]()
    
    init(style: UITableView.Style, buttonDelegate: MenuTableViewControllerDelegate) {
        super.init(style: style)
        delegate = buttonDelegate
        title = "메모"
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        
        navigationItem.rightBarButtonItem = plusButton
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func add() {
        let actionsheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shared = UIAlertAction(title: "Share...", style: .default, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionsheetController.addAction(shared)
        actionsheetController.addAction(delete)
        actionsheetController.addAction(cancel)
        
        present(actionsheetController, animated: true, completion: nil)
    }
    
    func makeTest() {
        guard let assetData = NSDataAsset.init(name: "sample") else { return }
        guard let memoData = ParsingManager.decodingModel(data: assetData.data, model: [Memo].self) else {
            return
        }
        memoList = memoData
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell else {
            return UITableViewCell()
        }
        let memoInfo = memoList[indexPath.row]
        cell.configure(memoInfo: memoInfo)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailText = memoList[indexPath.row]
        delegate?.didTapTableItem(data: detailText)
    }
}
