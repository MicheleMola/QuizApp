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
  
  let questions: [Question]
  let quiz: Quiz
  var arrayOfRandomIndexes = [Int]()
  let questionsPerRound = 4
  var questionsAsked = 0
  var correctQuestions = 0
  var indexRandom = 0

  
  init() {
    self.questions = [
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
                         Answer(text: "Congo", isCorrect: false),
                         Answer(text: "Mekong", isCorrect: false)]
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
                         Answer(text: "Germany", isCorrect: false),
                         Answer(text: "Japan", isCorrect: false),
                         Answer(text: "Great Britian", isCorrect: true)]
      )
    ]
    
    self.quiz = Quiz(name: "Fantastic", questions: questions)
  }
  
  
  func getRandomQuestion() -> Question {
    
    if self.arrayOfRandomIndexes.count == questionsPerRound {
      self.arrayOfRandomIndexes = []
    }
    
    indexRandom = GKRandomSource.sharedRandom().nextInt(upperBound: self.quiz.questions.count)
    
    while self.arrayOfRandomIndexes.contains(indexRandom) {
      indexRandom = GKRandomSource.sharedRandom().nextInt(upperBound: self.quiz.questions.count)
    }
    
    self.arrayOfRandomIndexes.append(indexRandom)
    
    let question = self.quiz.questions[indexRandom]
    return question
  }
  
  func isCorrect(answerWithIndex index: Int) -> Bool {
    self.questionsAsked += 1
    
    if self.quiz.questions[indexRandom].answers[index].isCorrect {
      self.correctQuestions += 1
      return true
    }
    
    return false
  }
  
  func isGameOver() -> Bool {
    let isGameOver = self.questionsAsked == self.questionsPerRound ? true : false
    return isGameOver
  }
  
  func resetGame() {
    self.questionsAsked = 0
    self.correctQuestions = 0
  }
  
  func feedbackRound() -> String {
    return "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
  }
  
  func timeOut() {
    self.questionsAsked += 1

  }
  
}
