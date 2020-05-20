//
//  CharactersVC.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

class CharactersVC: UIViewController {
    
    enum Section { case main }
    
    lazy var tableView = update(UITableView()) {
        $0.backgroundColor = .systemBackground
        $0.frame = self.view.bounds
        $0.rowHeight = 200
        $0.delegate = self
        $0.dataSource = self
        $0.removeExcessCells()
        $0.register(BBCell.self, forCellReuseIdentifier: BBCell.reuseID)
    }
    lazy var activityIndicator = update(UIActivityIndicatorView()){
        $0.startAnimating()
        $0.style = .large
        $0.color = .systemOrange
    }
    lazy var searchController = update(UISearchController()){
        $0.searchResultsUpdater = self
        $0.searchBar.placeholder = "Search for a character name"
        $0.obscuresBackgroundDuringPresentation = false
    }
    
    private var characters = Characters()
    private var filteredCharacters: [Character] = []
    private var dataSource: CustomDataSource<Section, Character>!

    override func viewDidLoad() {
        super.viewDidLoad()
        characters.delegate = self
        configureViewController()
        navigationItem.searchController = searchController
        layoutUI()
        dataSource = createDataSource()
        loadAllCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        backRowToNormalState()
    }
    
    private func loadAllCharacters() {
        characters.loadAll()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "All BB Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func layoutUI() {
        view.addSubview(tableView)
        tableView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createDataSource() -> CustomDataSource<Section, Character> {
        CustomDataSource<Section, Character>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, character -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: BBCell.reuseID, for: indexPath) as! BBCell
                cell.set(character: character)
                return cell
        })
    }
    
    private func backRowToNormalState() {
        tableView.setEditing(false, animated: true)
        if let index = tableView.indexPathForSelectedRow { tableView.deselectRow(at: index, animated: false) }
    }
    
    private func updateData(on characters: [Character]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CharactersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.characters.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BBCell.reuseID) as! BBCell
        if let character = characters.characters.value?[indexPath.row] {
            cell.set(character: character)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //передавай SearchingCharacters в инит контроллера
        let activeArray = SearchingCharacters.isSearching ? filteredCharacters : characters.characters.value
        let character = activeArray?[indexPath.row]
        let destVC = CharacterInfoVC(character: character!)
        // передавай в конструктор
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = favoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var character = characters.characters.value?[indexPath.row]
//        character.loadFavouriteStatus()

        let action = UIContextualAction(style: .normal, title: "Favorite") { (action, _, completition) in
//            character.isFavorite?.toggle()
//            character.updateFavoriteStatusInDB()
 
//            self.presentAlert(
//                title: "\(character.name)",
//                message: character.isFavorite! ? "♥︎" : "♡",
//                buttonTitle: "ОК"
//            )
            completition(true)
        }
        
//        action.image = character.isFavorite! ? Images.heartIcon : Images.unselectedHeart
        action.backgroundColor = .systemBackground
        return action
    }
}

extension CharactersVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        var textChecker = TextChecker(text: text)
        textChecker.checkUserInput()
        if !textChecker.isValid {
           filteredCharacters.removeAll()
//            updateData(on: characters)
            // от этой штуки надо избавиться или подругому сделать
            SearchingCharacters.isSearching = textChecker.isValid
            return
        }
        
        SearchingCharacters.isSearching = textChecker.isValid
//        filteredCharacters = Characters.filterCharactersByName(characters: characters, name: textChecker.text)
        filteredCharacters = characters.fetch(name: textChecker.text)
        updateData(on: filteredCharacters)
    }
}

extension CharactersVC: CharactersProtocol {
    func didChangedChatacters(result: Result<[Character], Error>) {
        switch result {
        case .success(_):
            tableView.reloadData()
            view.bringSubviewToFront(tableView)
            activityIndicator.stopAnimating()
            updateData(on: characters.characters.value!)
        case .failure(let error):
            self.presentAlert(title: AlertTitle.oops, message: error.localizedDescription, buttonTitle: "ОК")
            self.showEmptyStateView(with: error.localizedDescription, in: self.view)
            self.activityIndicator.stopAnimating()
            return
        }
    }
}
