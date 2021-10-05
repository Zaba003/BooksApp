//
//  BookListViewController.swift
//  BooksApp
//
//  Created by Кирилл Заборский on 02.10.2021.
//

import UIKit

class BookListViewController: UITableViewController {
    
    private var books: [Book] = []
    private var sortName = false
    private var sortDate = false
    
    @IBAction func sortBtn(_ sender: Any) {
        showActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        books = StorageManager.shared.fetchBooksFromFile()
        setupNavBarStyle()
        
    }
    
    func setupNavBarStyle() {
        let navBar = self.navigationController!.navigationBar
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        
        let compactAppearance = standardAppearance.copy()
        
        navBar.standardAppearance = standardAppearance
        navBar.scrollEdgeAppearance = standardAppearance
        navBar.compactAppearance = compactAppearance
        if #available(iOS 15.0, *) { // For compatibility with earlier iOS.
            navBar.compactScrollEdgeAppearance = compactAppearance
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if books.count == 0 {
            tableView.setEmptyView(title: NSLocalizedString("Emty list", comment: ""))
        } else {
            tableView.restore()
        }
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookName", for: indexPath)
        cell.textLabel?.text = books[indexPath.row].bookName
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = books[indexPath.row].date
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.deleteBookFromFile(at: indexPath.row)
            books.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newBookVC = segue.destination as! NewBookViewController
        if segue.identifier == "editBook" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let book = books[indexPath.row]
            
            newBookVC.book = book
            newBookVC.bookNameTextField?.text = book.bookName
            
            let bookDate = book.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.locale = Locale(identifier: "ru_RU")
            guard let date = dateFormatter.date(from: bookDate) else {
                fatalError()
            }
            
            newBookVC.bookId = book.idBook
            newBookVC.currentDate = date
            newBookVC.title = NSLocalizedString("Edit info", comment: "")
            newBookVC.delegate = self
            
        } else if segue.identifier == "newBook" {
            newBookVC.count = books.count
            newBookVC.delegate = self
            newBookVC.modalPresentationStyle = .fullScreen
        }
    }
    // MARK: - sorting
    private func sorting() {
        
        if sortName == true {
            books = books.sorted(by: { $0.bookName < $1.bookName })
        }
        
        if sortDate == true {
            books = books.sorted(by: { $0.date < $1.date })
        }
        
        tableView.reloadData()
        
    }
    // MARK: - AlertController
    private func showActionSheet() {
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Sort by name", comment: ""), style: .default, handler: { (_) in
            self.sortName = true
            self.sortDate = false
            self.sorting()
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Sort by date", comment: ""), style: .default, handler: { (_) in
            self.sortName = false
            self.sortDate = true
            self.sorting()
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (_) in
        }))
        
        self.present(alertController, animated: true, completion: {
        })
    }
}

// MARK: - NewBookViewControllerDelegate
extension BookListViewController: NewBookViewControllerDelegate {
    func saveBook(_ book: Book) {
        books.append(book)
        tableView.reloadData()
    }
    func updateBook(_ book: Book) {
        books = StorageManager.shared.fetchBooksFromFile()
        tableView.reloadData()
    }
}

// MARK: - setEmptyView
extension UITableView {
    func setEmptyView(title: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        titleLabel.font = UIFont(name: "SF Pro Text", size: 24)
        titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        emptyView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.text = title
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
