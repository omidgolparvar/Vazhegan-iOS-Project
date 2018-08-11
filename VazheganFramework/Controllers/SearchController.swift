//
//  SearchController.swift
//  VazheganFramework
//
//  Created by Omid Golparvar on 8/11/18.
//  Copyright © 2018 Omid Golparvar. All rights reserved.
//

import UIKit
import MobileCoreServices

class SearchController: UITableViewController {
	
	private var searchBar		: UISearchBar?
	private var searchManager	: SearchManager!
	
	var queryText				: String? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareForExtension()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		guard let searchManager = searchManager else { return 0 }
		return searchManager.numberOfSections()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchManager.numberOfRows(in: section)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return searchManager.cellForRow(at: indexPath, with: tableView)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 56.0
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchResultTVH") as! SearchResultTVH
		header.setup(forSearchResult: searchManager.searchResult[section])
		return header
	}
	
}

extension SearchController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		guard let text = searchBar.text?.trimmed, !text.isEmpty else {
			searchBar.text = ""
			searchManager.cancelSearchAndRemoveResults()
			return
		}
		searchManager.search(for: text)
	}
	
	func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
		let text = searchBar.text?.trimmed ?? ""
		if text.isEmpty {
			searchBar.text = text
			searchManager.cancelSearchAndRemoveResults()
		}
		return true
	}
	
}

extension SearchController: SearchManagerDelegate {
	
	func searchManagerDidStartSearching(for text: String) {
		tableView.reloadData()
		searchBar?.resignFirstResponder()
		setupViews_TableViewBackgroundView(isNil: true)
	}
	
	func searchManagerDidEndSearching(for section: Int) {
		tableView.reloadSections([section], with: .automatic)
	}
	
	func searchManagerDidCancelSearching() {
		tableView.reloadData()
		setupViews_TableViewBackgroundView(isNil: false)
	}
	
}

extension SearchController {
	
	private func prepareForExtension() {
		if	let textItem = self.extensionContext?.inputItems[0] as? NSExtensionItem,
			let textItemProvider = textItem.attachments?[0] as? NSItemProvider,
			textItemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
			textItemProvider.loadItem( forTypeIdentifier: kUTTypeText as String, options: nil) { [weak self] (result, error) in
				
				if let string = (result as? String)?.trimmed, !string.isEmpty {
					self?.queryText = string
				}
				
				DispatchQueue.main.async { [weak self] in self?.setupViews() }
			}
		} else {
			setupViews()
		}
	}
	
	private func setupViews() {
		tableView.tableFooterView = UIView(frame: .zero)
		if let queryText = queryText {
			setupViews_ForExtension(with: queryText)
		} else {
			setupViews_ForMainApp()
		}
		
		setupSearchManager()
	}
	
	private func setupViews_ForMainApp() {
		searchBar = UISearchBar()
		searchBar!.sizeToFit()
		searchBar!.placeholder = "کلمه مورد نظرتون رو بزنین"
		searchBar!.semanticContentAttribute = .forceRightToLeft
		searchBar!.searchBarStyle = .minimal
		searchBar!.delegate = self
		navigationItem.titleView = searchBar!
	}
	
	private func setupViews_ForExtension(with text: String) {
		navigationItem.title = text
		let button = UIBarButtonItem(title: "بازگشت", style: .done, target: self, action: #selector(actionDismissFromExtension))
		navigationItem.leftBarButtonItem = button
	}
	
	private func setupViews_TableViewBackgroundView(isNil: Bool) {
		if isNil {
			tableView.backgroundView = nil
		} else {
			let bgView = VazheganBackgroundView(frame: tableView.frame)
			bgView.set(viewController: self)
			tableView.backgroundView = bgView
		}
	}
	
	private func setupSearchManager() {
		searchManager = SearchManager(delegate: self)
		searchManager.delegate?.searchManagerDidCancelSearching()
		tableView.reloadData()
		
		if let text = queryText {
			searchManager.search(for: text)
		}
	}
	
	@objc
	private func actionDismissFromExtension() {
		self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
		self.dismiss(animated: true, completion: nil)
	}
	
}
