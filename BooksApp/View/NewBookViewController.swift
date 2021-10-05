//
//  NewBookViewController.swift
//  BookApp
//
//  Created by Кирилл Заборский on 01.10.2021.
//

import UIKit

protocol NewBookViewControllerDelegate {
    func saveBook(_ book: Book)
    func updateBook(_ book: Book)
}

class NewBookViewController: UIViewController, UITextFieldDelegate {
    
    private var dateChanged = ""
    var book: Book!
    var currentDate: Date = Date()
    var count = 0
    var bookId = 0
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var bookNameTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBAction func datePickerChanged(_ sender: Any) {
        _ = getFormattedDate(format: dateChanged)
    }
    
    var delegate: NewBookViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookNameTextField.delegate = self
        
        bookNameTextField.addTarget(
            self,
            action: #selector(bookNameTextFieldDidChanged),
            for: .allEvents
        )
        setupEditScreen()
        addButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
    }
    
    @IBAction func addButtonTab(_ sender: Any) {
        if book != nil {
            updateAndExit()
            self.navigationController?.popViewController(animated: true)
        } else {
            saveAndExit()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
    
    @objc private func bookNameTextFieldDidChanged() {
        guard let bookName = bookNameTextField.text else { return }
        addButton.isEnabled = !bookName.isEmpty ? true : false
    }
    
    private func minMaxDate() {
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        _ = getFormattedDate(format: dateChanged)
    }
    
    private func setupEditScreen() {
        if book != nil {
            bookNameTextField.text = book?.bookName
            bookId = book.idBook
            addButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
            datePicker.date = currentDate
            minMaxDate()
        } else {
            minMaxDate()
            addButton.isEnabled = false
        }
    }
    // MARK: - save/update
    private func saveAndExit() {
        if dateChanged != "" {
            bookId = count + 1
            let book = Book(idBook: bookId, bookName: bookNameTextField.text ?? "", date: dateChanged)
            StorageManager.shared.saveBookToFile(with: book)
            delegate?.saveBook(book)
        }
    }
    
    private func updateAndExit() {
        let newBook = Book(idBook: bookId, bookName: bookNameTextField.text ?? "", date: dateChanged)
        StorageManager.shared.updateBookToFile(with: newBook)
        delegate?.updateBook(book)
    }
}
// MARK: - extension NewBookViewController
extension NewBookViewController {
    func getFormattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let strDate = dateFormatter.string(from: datePicker.date)
        dateChanged = strDate
        return dateFormatter.string(from: Date())
    }
}
