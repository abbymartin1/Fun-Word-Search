//
//  WordSearchCollectionViewDataSource.swift
//  Word Search
//
//  Created by Abby Martin on 2020-05-11.
//  Copyright © 2020 Abby Martin. All rights reserved.
//

import UIKit

let wordSearchCollectionViewCellIdentifier = "wordSearchCell"
let cellsPerRow = 10

class WordSearchCollectionViewDataSource : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

// MARK - Outlets
@IBOutlet weak var collectionView: UICollectionView!
@IBOutlet weak var submitButton: UIButton!
@IBOutlet weak var wordBankLabel: UILabel!
@IBOutlet weak var wordsFoundLabel: UILabel!
@IBOutlet weak var selectedWordLabel: UILabel!
@IBOutlet weak var wordBankTitle: UILabel!

// MARK - Variables
var wordBankWords = ["swift", "kotlin","objectivec","variable","java","mobile"]
let items = ["v", "a", "v", "x", "c", "k", "s", "q", "r", "k", "a", "p", "o", "s", "j", "e", "r", "z", "u", "o", "r", "p", "s", "w", "i", "f", "t", "q", "a", "t", "i", "s", "d", "f", "a", "j", "e", "r", "p", "l", "a", "m", "o", "b", "i", "l", "e", "a", "s", "i", "b", "t", "e", "q", "w","j","a","v","a","n","l","d","e","l","c","m","b","v","c","s","e","x","g","h","o","w","m","o","z","p","o","b","j","e","c","t","i","v","e","c","f","v","b","n","t","y","i","l","k","a"]
var selectedWord = ""
var selectedWordIndexes = [Int]()

// MARK - Overrides
override func viewWillAppear(_ animated: Bool) {
self.submitButton.backgroundColor = UIColor.green
self.submitButton.titleLabel?.textColor = UIColor.black
self.submitButton.layer.cornerRadius = 20
self.collectionView.allowsMultipleSelection = true
self.wordBankLabel.text = self.getWordBankText()
}

// MARK - Methods
private func getWordBankText() -> String {
var wordBankText = ""
for word in self.wordBankWords {
wordBankText.append("\(word), ")
}
if wordBankText == "" {
wordBankText = "Congrats you found all the words!!"
self.updateUIWhenWordSearchIsComplete();
}
return wordBankText
}

private func updateUIWhenWordSearchIsComplete() {
// disable button
self.submitButton.backgroundColor = UIColor.gray;
self.submitButton.isEnabled = false;
//hide unneeded lables
self.selectedWordLabel.isHidden = true;
self.wordBankTitle.isHidden = true;
//show popup congratulating user on completing word search
let alert = UIAlertController(title: "Congrats!!", message: "Congrats on Successfully Completing the Word Search", preferredStyle: .alert)
alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
self.present(alert, animated: true, completion: nil)
}

// will "cross" out the word on the board once a valid word is entered
private func crossOutWord() {
for letterIndex in self.selectedWordIndexes {
let place = IndexPath(item: letterIndex, section: 0)
((self.collectionView.cellForItem(at: place)) as! WordSearchCollectionViewCell).setCellToCrossedOff()
}
}

// will "deselect" word when user selects an incorrect word
private func deselectWord() {
for letterIndex in self.selectedWordIndexes {
let place = IndexPath(item: letterIndex, section: 0)
((self.collectionView.cellForItem(at: place)) as! WordSearchCollectionViewCell).setCellToUnselected()
}
}

private func handleIncorrectlySelectedWord() {
self.submitButton.backgroundColor = UIColor.red
self.submitButton.setTitle("Incorrect Word", for: .normal)
self.deselectWord()
// show timer for 2 seconds so user is able to see the error message on button then return to normal
Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { timer in
self.submitButton.backgroundColor = UIColor.green
self.submitButton.setTitle("Submit Word", for: .normal)
})
}

// calculates the number of letters in crossword
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
return self.items.count
}

// calculate the size of cells to fit 10 across the screen width as required
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
let totalWidthContainer = Int(collectionView.frame.size.width)
let size = totalWidthContainer/cellsPerRow
return CGSize(width: size, height: size)
}

// gets cell for index
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
let cell = collectionView.dequeueReusableCell(withReuseIdentifier: wordSearchCollectionViewCellIdentifier, for: indexPath as IndexPath) as! WordSearchCollectionViewCell
cell.letterLabel.text = self.items[indexPath.item]
cell.backgroundColor = UIColor.gray
return cell
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
// check if cell was already selected and if so then do not re-add it since cells can only be selected once in a crossword
if self.selectedWordIndexes.contains(indexPath.item) {
return;
}
self.selectedWord += self.items[indexPath.item]
self.selectedWordIndexes.append(Int(indexPath.item))
self.selectedWordLabel.text = "Selected Word: \(self.selectedWord)"
((self.collectionView.cellForItem(at: indexPath)) as! WordSearchCollectionViewCell).setCellToSelected();
}

// MARK - Actions:
@IBAction func onSubmitButtonPressed(_ sender: Any) {
if self.wordBankWords.contains(self.selectedWord) {
// If the user selected a value word, we want to remove that word from the word bank
// and "cross out" that word on the board.
if let indexOfCrossedOffWord = self.wordBankWords.firstIndex(of: self.selectedWord) {
self.wordBankWords.remove(at: indexOfCrossedOffWord)
self.wordBankLabel.text = self.getWordBankText()
let numberOfFoundWords = 6 - self.wordBankWords.count
self.wordsFoundLabel.text = "Found \(numberOfFoundWords)/6"
self.crossOutWord()
} else {
// default to error state although this ~should~ never happen
self.handleIncorrectlySelectedWord();
}
} else {
// the user selected an incorrect word
self.handleIncorrectlySelectedWord();
}
// reset word
self.selectedWord = ""
self.selectedWordIndexes = []
self.selectedWordLabel.text = "Selected Word: "
}
}
