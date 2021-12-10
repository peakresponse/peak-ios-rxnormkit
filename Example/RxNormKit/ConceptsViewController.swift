//
//  ConceptsViewController.swift
//  RxNormKit
//
//  Created by Francis Li on 12/09/2021.
//  Copyright (c) 2021 Francis Li. All rights reserved.
//

import UIKit
import RxNormKit
import RealmSwift

class ConceptsViewController: UITableViewController, UIDocumentPickerDelegate {
    var results: Results<RxNConcept>?
    var notificationToken: NotificationToken?

    deinit {
        notificationToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        results = RxNRealm.open().objects(RxNConcept.self).sorted(by: [
            SortDescriptor(keyPath: "rxcui", ascending: true),
            SortDescriptor(keyPath: "name", ascending: true)
        ])
        notificationToken = results?.observe { [weak self] (changes) in
            self?.didObserveRealmChanges(changes)
        }
    }

    func didObserveRealmChanges(_ changes: RealmCollectionChange<Results<RxNConcept>>) {
        switch changes {
        case .initial:
            tableView.reloadData()
        case .update(_, let deletions, let insertions, let modifications):
            tableView.beginUpdates()
            tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            tableView.endUpdates()
        case .error(let error):
            print(error)
        }
    }

    func showSpinner() {
        for item in navigationItem.leftBarButtonItems ?? [] {
            item.isEnabled = false
        }
        for item in navigationItem.rightBarButtonItems ?? [] {
            item.isEnabled = false
        }
        var spinner: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            spinner = UIActivityIndicatorView(activityIndicatorStyle: .medium)
        } else {
            spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        }
        spinner.startAnimating()
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: spinner))
    }

    func hideSpinner() {
        _ = navigationItem.leftBarButtonItems?.popLast()
        for item in navigationItem.rightBarButtonItems ?? [] {
            item.isEnabled = true
        }
    }

    @IBAction func importPressed() {
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeItem)], in: .open)
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func openPressed() {

    }

    @IBAction func exportPressed() {
        showSpinner()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let realm = RxNRealm.open()
            let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                                 appropriateFor: nil, create: false)
            let url = documentDirectory?.appendingPathComponent( "rxnorm.realm")
            if let url = url {
                do {
                    try realm.writeCopy(toFile: url, encryptionKey: nil)
                    DispatchQueue.main.async { [weak self] in
                        let picker = UIDocumentPickerViewController(url: url, in: .moveToService)
                        picker.shouldShowFileExtensions = true
                        self?.present(picker, animated: true)
                    }
                } catch {
                    // noop
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.hideSpinner()
            }
        }
    }

    // MARK: - UIDocumentPickerDelegate

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        if url.pathExtension.lowercased() == "rrf" {
            showSpinner()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let realm = RxNRealm.open()
                url.read { (line, _) in
                    let cols = line.split(separator: "|", omittingEmptySubsequences: false)
                    if let rxcui = Int(cols[0]), cols[11] == "RXNORM", cols[12] == "BN" || cols[12] == "IN" || cols[12] == "PSN" {
                        let concept = RxNConcept()
                        concept.rxcui = rxcui
                        concept.rxaui = String(cols[7])
                        concept.sab = String(cols[11])
                        concept.tty = String(cols[12])
                        concept.code = String(cols[13])
                        concept.name = String(cols[14])
                        concept.isCurrentPrescribable = cols[17] == "4096"
                        try! realm.write {
                            realm.add(concept, update: .modified)
                        }
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.hideSpinner()
                }
            }
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Concept", for: indexPath)
        if let concept = results?[indexPath.row] {
            cell.textLabel?.text = "\(concept.rxcui): \(concept.name)"
        }
        return cell
    }
}
