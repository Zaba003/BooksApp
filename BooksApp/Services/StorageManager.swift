//
//  StorageManager.swift
//  BookApp
//
//  Created by Кирилл Заборский on 01.10.2021.
//

import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let bookKey = "books"
    private let documentsDirecory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var archiveURL: URL!
    
    private init() {
        archiveURL = documentsDirecory.appendingPathComponent("Book").appendingPathExtension("plist")
    }
    
    func saveBookToFile(with book: Book) {
        var books = fetchBooksFromFile()
        books.append(book)
        guard let data = try? PropertyListEncoder().encode(books) else { return }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
    
    func updateBookToFile(with newBook: Book) {
        var books = fetchBooksFromFile()
        for book in books {
            if book.idBook == newBook.idBook {
                if let index = books.firstIndex(of: book) {
                    books.remove(at: index)
                }
            }
        }
        books.append(newBook)
        guard let data = try? PropertyListEncoder().encode(books) else { return }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
    
    func fetchBooksFromFile() -> [Book] {
        guard let data = try? Data(contentsOf: archiveURL) else { return [] }
        guard let books = try? PropertyListDecoder().decode([Book].self, from: data) else { return [] }
        return books
    }
    
    func deleteBookFromFile(at index: Int) {
        var books = fetchBooksFromFile()
        books.remove(at: index)
        
        guard let data = try? PropertyListEncoder().encode(books) else { return }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
}
