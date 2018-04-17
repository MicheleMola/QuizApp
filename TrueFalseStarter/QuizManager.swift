//
//  QuizManager.swift
//  TrueFalseStarter
//
//  Created by Michele Mola on 14/04/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation
import GameKit

class QuizManager {
  
  // Object of the Quiz class
  let quiz: Quiz
  
  // Array of random indices to avoid repetitions of the same question in a single round
  var arrayOfRandomIndexes = [Int]()
  
  // Number of questions for round
  let questionsPerRound = 4
  
  // Counter of the submitted questions per round
  var questionsAsked = 0
  
  // Counter of the right answers per round
  var correctQuestions = 0
  
  // Random generated index
  var indexRandom = 0
  
  // Array of question to show during the quiz
  var questions = [
    Question(text: "This was the only US President to serve more than two consecutive terms.",
             answers: [Answer(text: "George Washington", isCorrect: false),
                       Answer(text: "Franklin D. Roosevelt", isCorrect: true),
                       Answer(text: "Woodrow Wilson", isCorrect: false)]
    ),
    Question(text: "Which of the following countries has the most residents?",
             answers: [Answer(text: "Nigeria", isCorrect: true),
                       Answer(text: "Russia", isCorrect: false),
                       Answer(text: "Iran", isCorrect: false),
                       Answer(text: "Vietnam", isCorrect: false)]
    ),
    Question(text: "In what year was the United Nations founded?",
             answers: [Answer(text: "1928", isCorrect: false),
                       Answer(text: "1919", isCorrect: false),
                       Answer(text: "1945", isCorrect: true),
                       Answer(text: "1954", isCorrect: false)]
    ),
    Question(text: "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
             answers: [Answer(text: "Paris", isCorrect: false),
                       Answer(text: "Washington D.C.", isCorrect: false),
                       Answer(text: "New York City", isCorrect: true),
                       Answer(text: "Boston", isCorrect: false)]
    ),
    Question(text: "Which nation produces the most oil?",
             answers: [Answer(text: "Iran", isCorrect: false),
                       Answer(text: "Iraq", isCorrect: false),
                       Answer(text: "Brazil", isCorrect: false),
                       Answer(text: "Canada", isCorrect: true)]
    ),
    Question(text: "Which country has most recently won consecutive World Cups in Soccer?",
             answers: [Answer(text: "Italy", isCorrect: false),
                       Answer(text: "Brazil", isCorrect: true),
                       Answer(text: "Argetina", isCorrect: false),
                       Answer(text: "Spain", isCorrect: false)]
    ),
    Question(text: "Which of the following rivers is longest?",
             answers: [Answer(text: "Yangtze", isCorrect: false),
                       Answer(text: "Mississippi", isCorrect: true),
                       Answer(text: "Congo", isCorrect: false)]
    ),
    Question(text: "Which city is the oldest?",
             answers: [Answer(text: "Mexico City", isCorrect: true),
                       Answer(text: "Cape Town", isCorrect: false),
                       Answer(text: "San Juan", isCorrect: false),
                       Answer(text: "Sydney", isCorrect: false)]
    ),
    Question(text: "Which country was the first to allow women to vote in national elections?",
             answers: [Answer(text: "Poland", isCorrect: true),
                       Answer(text: "United States", isCorrect: false),
                       Answer(text: "Sweden", isCorrect: false),
                       Answer(text: "Senegal", isCorrect: false)]
    ),
    Question(text: "Which of these countries won the most medals in the 2012 Summer Games?",
             answers: [Answer(text: "France", isCorrect: false),
                       Answer(text: "Japan", isCorrect: false),
                       Answer(text: "Great Britian", isCorrect: true)]
    )
  ]
  
  // Create two object of the SoundManager class (One to manage the sound on correct answer and the other to manage the sound on wrong answer)
  let correctSound = SoundManager(fileName: "CorrectAnswer", fileType: "mp3", idSound: 0)
  let wrongSound = SoundManager(fileName: "WrongAnswer", fileType: "mp3", idSound: 1)
  
  init() {
    
    // Create Quiz object use the init with two parameters of the Quiz class
    self.quiz = Quiz(name: "My Quiz", questions: self.questions)
    
    // Load sound
    loadSound()
  }
  
  func loadSound() {
    correctSound.load()
    wrongSound.load()
  }
  
  // Method to return a random question without repetition
  func getRandomQuestion() -> Question {
    
    // Generate random number between 0 and questions.count -1
    indexRandom = GKRandomSource.sharedRandom().nextInt(upperBound: self.quiz.questions.count)
    
    // Loop until the generated random index is not present in arrayOfRandomIndexes
    while self.arrayOfRandomIndexes.contains(indexRandom) {
      
      // Generate a new random index
      indexRandom = GKRandomSource.sharedRandom().nextInt(upperBound: self.quiz.questions.count)
    }
    
    // Add new random index to array
    self.arrayOfRandomIndexes.append(indexRandom)
    
    // Return random question
    let question = self.quiz.questions[indexRandom]
    return question
  }
  
  // Check if the clicked answer is correct
  func isCorrect(answerWithIndex index: Int) -> Bool {
    
    // Increment the counter of the submitted questions per round
    self.questionsAsked += 1
    
    if self.quiz.questions[indexRandom].answers[index].isCorrect {
      
      // Increment the counter of the correct questions
      self.correctQuestions += 1
      
      // Play sound per correct answer
      correctSound.play()
      
      return true
    }
    
    // Else play sound per wrong answer
    wrongSound.play()
    
    return false
  }
  
  func isGameOver() -> Bool {
    
    // Check if the round is over
    return self.questionsAsked == self.questionsPerRound ? true : false
  }
  
  func resetGame() {
    // Reset the counters for the new round
    self.questionsAsked = 0
    self.correctQuestions = 0
    
    // Remove the random indices from array for the new round
    self.arrayOfRandomIndexes = []
  }
  
  func feedbackRound() -> String {
    
    // Return round's feedback
    return "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
  }
  
  func timeOut() {
    
    // Increment the counter of the submitted questions per round
    self.questionsAsked += 1
    
    // Play sound per wrong answer
    wrongSound.play()
  }
  
}
