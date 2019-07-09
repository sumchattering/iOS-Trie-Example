//
//  CityTrie.swift
//  CoolCities
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import Foundation

/// A node in the city trie
class TrieNode<T: Hashable> {
    var value: T?
    weak var parentNode: TrieNode?
    var children: [T: TrieNode] = [:]
    var isTerminating = false
    var isLeaf: Bool {
        return children.count == 0
    }
    
    /// Initializes a node.
    ///
    /// - Parameters:
    ///   - value: The value that goes into the node
    ///   - parentNode: A reference to this node's parent
    init(value: T? = nil, parentNode: TrieNode? = nil) {
        self.value = value
        self.parentNode = parentNode
    }
    
    /// Adds a child node to self.  If the child is already present,
    /// do nothing.
    ///
    /// - Parameter value: The item to be added to this node.
    func add(value: T) {
        guard children[value] == nil else {
            return
        }
        children[value] = TrieNode(value: value, parentNode: self)
    }
}

/// A trie data structure containing words.  Each node is a single
/// character of a word.
class CityTrie: NSObject, NSCoding {
    typealias Node = TrieNode<Character>

    public var count: Int {
        return cityCount
    }

    public var isEmpty: Bool {
        return cityCount == 0
    }
    
    var wordCitiesMap: [String: [City]] = [String: [City]]()
    
    public var cities: [City] {
        let words = wordsInSubtrie(rootNode: root, partialWord: "")
        return words.flatMap{ wordCitiesMap[$0] ?? [] }
    }
    
    fileprivate let root: Node
    fileprivate var cityCount: Int
    
    override init() {
        root = Node()
        cityCount = 0
        super.init()
    }
    
    // MARK: NSCoding
    /// Initializes the trie with words from an archive
    ///
    /// - Parameter decoder: Decodes the archive
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        let cities = decoder.decodeObject(forKey: "cities") as? [City]
        for city in cities! {
            self.insert(city: city)
        }
    }
    
    /// Encodes the words in the trie by putting them in an array then encoding
    /// the array.
    ///
    /// - Parameter coder: The object that will encode the array
    func encode(with coder: NSCoder) {
        coder.encode(self.cities, forKey: "cities")
    }
}

// MARK: - Adds methods: insert, remove, contains
extension CityTrie {
    /// Inserts a word into the trie.  If the word is already present,
    /// there is no change.
    ///
    /// - Parameter word: the word to be inserted.
    func insert(city: City) {
        
        let word = city.name
        guard !word.isEmpty else {
            return
        }
        
        var currentNode = root
        for character in word.lowercased() {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.add(value: character)
                currentNode = currentNode.children[character]!
            }
        }        
        if var exisitingCities = wordCitiesMap[word.lowercased()] {
            exisitingCities.append(city)
        } else {
            wordCitiesMap[word.lowercased()] = [city]
        }
        cityCount += 1
        currentNode.isTerminating = true
    }
    
    /// Determines whether a city is in the trie.
    ///
    /// - Parameter city: the city to check for
    /// - Returns: true if the word is present, false otherwise.
    func contains(city: City) -> Bool {
        let word = city.name
        guard !word.isEmpty else {
            return false
        }
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return false
            }
            currentNode = childNode
        }
        return currentNode.isTerminating
    }

    /// Removes a city from the trie.  If the city name is not present or
    /// it is empty, just ignore it.  If the last node is a leaf,
    /// delete that node and higher nodes that are leaves until a
    /// terminating node or non-leaf is found.  If the last node of
    /// the city name has more children, the city name is part of other words.
    /// Mark the last node as non-terminating.
    ///
    /// - Parameter word: the word to be removed
    func remove(city: City) {
        let word = city.name
        guard !word.isEmpty else {
            return
        }
        guard let terminalNode = findTerminalNodeOf(word: word) else {
            return
        }
        if terminalNode.isLeaf {
            deleteNodesForWordEndingWith(terminalNode: terminalNode)
        } else {
            terminalNode.isTerminating = false
        }
        if var exisitingCities = wordCitiesMap[word.lowercased()] {
            if let existingIndex = exisitingCities.firstIndex(of: city) {
                exisitingCities.remove(at: existingIndex)
            }
        }
        cityCount -= 1
    }
   
    /// Returns an array of cities in a subtrie of the trie that start
    /// with given prefix
    ///
    /// - Parameters:
    ///   - prefix: the letters for word prefix
    /// - Returns: the corresponding cities for the words in the subtrie that start with prefix
    func findCitiesWithPrefix(prefix: String) -> [City] {
        var words = [String]()
        let prefixLowerCased = prefix.lowercased()
        if let lastNode = findLastNodeOf(word: prefixLowerCased) {
            if lastNode.isTerminating {
                words.append(prefixLowerCased)
            }
            for childNode in lastNode.children.values {
                let childWords = wordsInSubtrie(rootNode: childNode, partialWord: prefixLowerCased)
                words += childWords
            }
        }
        return words.flatMap({ wordCitiesMap[$0] ?? [] })
    }
}

// Private
extension CityTrie {
    
    /// Attempts to walk to the last node of a word.  The
    /// search will fail if the word is not present. Doesn't
    /// check if the node is terminating
    ///
    /// - Parameter word: the word in question
    /// - Returns: the node where the search ended, nil if the
    /// search failed.
    private func findLastNodeOf(word: String) -> Node? {
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return nil
            }
            currentNode = childNode
        }
        return currentNode
    }
    
    
    /// Attempts to walk to the terminating node of a word.  The
    /// search will fail if the word is not present.
    ///
    /// - Parameter word: the word in question
    /// - Returns: the node where the search ended, nil if the
    /// search failed.
    private func findTerminalNodeOf(word: String) -> Node? {
        if let lastNode = findLastNodeOf(word: word) {
            return lastNode.isTerminating ? lastNode : nil
        }
        return nil
    }
    
    /// Deletes a word from the trie by starting with the last letter
    /// and moving back, deleting nodes until either a non-leaf or a
    /// terminating node is found.
    ///
    /// - Parameter terminalNode: the node representing the last node
    /// of a word
    private func deleteNodesForWordEndingWith(terminalNode: Node) {
        var lastNode = terminalNode
        var character = lastNode.value
        while lastNode.isLeaf, let parentNode = lastNode.parentNode {
            lastNode = parentNode
            lastNode.children[character!] = nil
            character = lastNode.value
            if lastNode.isTerminating {
                break
            }
        }
    }
    
    /// Returns an array of words in a subtrie of the trie
    ///
    /// - Parameters:
    ///   - rootNode: the root node of the subtrie
    ///   - partialWord: the letters collected by traversing to this node
    /// - Returns: the words in the subtrie
    fileprivate func wordsInSubtrie(rootNode: Node, partialWord: String) -> [String] {
        var subtrieWords = [String]()
        var previousLetters = partialWord
        if let value = rootNode.value {
            previousLetters.append(value)
        }
        if rootNode.isTerminating {
            subtrieWords.append(previousLetters)
        }
        for childNode in rootNode.children.values {
            let childWords = wordsInSubtrie(rootNode: childNode, partialWord: previousLetters)
            subtrieWords += childWords
        }
        return subtrieWords
    }
    
}
