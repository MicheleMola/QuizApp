//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
  
  let quizManager = QuizManager()
  var question: Question!
  
  @IBOutlet weak var questionField: UILabel!
  @IBOutlet weak var option1: UIButton!
  @IBOutlet weak var option2: UIButton!
  @IBOutlet weak var option3: UIButton!
  @IBOutlet weak var option4: UIButton!
  
  @IBOutlet weak var normalButton: UIButton!
  @IBOutlet weak var lightningButton: UIButton!
  
  @IBOutlet weak var feedbackLabel: UILabel!
  
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var labelCountdown: UILabel!
  
  var timerIsOn = false
  var timer = Timer()
  var timeRemaining = 15
  var totalTime = 15
  
  var answerButtons: [UIButton] = []

  let colorButtons = UIColor(red: 12/255, green: 121/255, blue: 150/255, alpha: 1)
  
  // Tuples that contain text and color of feedback
  let positiveFeedback: (text: String, color: UIColor) = ("Correct!", UIColor(red: 12/255, green: 121/255, blue: 150/255, alpha: 1))
  let negativeFeedback: (text: String, color: UIColor) = ("Sorry, wrong answer!!", UIColor.red)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create a collection of answer buttons
    answerButtons = [option1, option2, option3, option4]

    // Setup game menu
    initHome()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func initHome() {
    
    // Hide all answers
    hideAnswers()
    
    // Hide question label and feedback label that I don't need
    questionField.isHidden = true
    feedbackLabel.isHidden = true
    
    // Hide Progress view and countdown that I don't need
    progressView.isHidden = true
    labelCountdown.isHidden = true
    
    // Show button for Normal Mode and change set title
    normalButton.isHidden = false
    normalButton.setTitle("Normal Mode", for: .normal)
    
    // Show button for Lightning Mode and change set title
    lightningButton.isHidden = false
    lightningButton.setTitle("Lightning Mode", for: .normal)
  }
  
  
  func displayQuestionAndAnswers() {
    
    // Hide all answers
    hideAnswers()

    // Start timer if the mode is lighting
    startTimer()
    
    // Get random question from quizManager object
    self.question = quizManager.getRandomQuestion()
    
    // Show question label that contains the text of the question
    questionField.isHidden = false
    
    // Set text of the question
    questionField.text = self.question.text
    
    // Hide buttons that I don't need
    normalButton.isHidden = true
    lightningButton.isHidden = true
    
    // Hide feedback label
    feedbackLabel.isHidden = true
    
    // Setup answers for the current question
    for index in 0..<self.question.answers.count {
      let button = answerButtons[index]
      button.setTitle(self.question.answers[index].text, for: .normal)
      button.backgroundColor = colorButtons
      button.isHidden = false
    }
  }
  
  func hideAnswers() {
    
    // Hide all answers
    for answer in answerButtons {
      answer.isHidden = true
    }
  }
  
  func displayScore() {
    
    // Hide all answers
    hideAnswers()
    
    // Hide Normal Mode / Next Question Button
    normalButton.isHidden = true

    // Show Play Again button
    lightningButton.isHidden = false
    
    // Change title to Lightning button from Lightning Mode to Play Again
    lightningButton.setTitle("Play Again", for: .normal)

    // Hide feedback label
    feedbackLabel.isHidden = true
    
    // Hide Progress View and Countdown
    progressView.isHidden = true
    labelCountdown.isHidden = true
    
    // Set feedback round in question label
    questionField.text = self.quizManager.feedbackRound()
    
    // Reset round
    self.quizManager.resetGame()
  }
  
  @IBAction func checkAnswer(_ sender: UIButton) {
    
    // Disable click on answers
    disableAndEnableClickOnAnswers()
    
    // Stop timer
    stopTimer()
    
    // Change color to the answers
    answersWithFeedback()
    
    // Get feedback on the clicked answer
    let isCorrect = self.quizManager.isCorrect(answerWithIndex: sender.tag)
    
    // Check if the clicked answer is correct
    if isCorrect {
      
      // Set positive feedback in feedback label and change text color
      feedbackLabel.text = positiveFeedback.text
      feedbackLabel.textColor = positiveFeedback.color
    } else {
      
      // Set negative feedback in feedback label and change text color
      feedbackLabel.text = negativeFeedback.text
      feedbackLabel.textColor = negativeFeedback.color
    }
    
    // Show feedback label
    feedbackLabel.isHidden = false
    
    // Show Next Question Button
    normalButton.isHidden = false
    
  }
  
  func startTimer() {
    if !progressView.isHidden {
      if !timerIsOn {
        timeRemaining = 15
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        timerIsOn = true
      }
    }
  }
  
  func stopTimer() {
    if !progressView.isHidden {
      if timerIsOn {
        timer.invalidate()
        timerIsOn = false
      }
    }
  }
  
  func answersWithFeedback() {
    for index in 0..<question.answers.count {
      let button = answerButtons[index]
      button.backgroundColor = question.answers[index].isCorrect ? positiveFeedback.color : negativeFeedback.color
    }
  }
  
  func disableAndEnableClickOnAnswers() {
    for answer in answerButtons {
      answer.isEnabled = !answer.isEnabled
    }
  }
  
  func nextRound() {
    if self.quizManager.isGameOver() {
      // Game is over
      displayScore()
    } else {
      // Continue game
      disableAndEnableClickOnAnswers()
      displayQuestionAndAnswers()
    }
  }
  
  @IBAction func normalAndNextQuestion(_ sender: UIButton) {
    
    if sender.title(for: .normal) == "Normal Mode" {
      displayQuestionAndAnswers()
      progressView.isHidden = true
      labelCountdown.isHidden = true
      normalButton.setTitle("Next Question", for: .normal)
    } else {
      nextRound()
    }
  }
  
  @IBAction func lightningAndPlayAgainButton(_ sender: UIButton) {
    
    normalButton.setTitle("Next Question", for: .normal)
    
    if sender.title(for: .normal) == "Lightning Mode" {
      lightningButton.setTitle("Play Again", for: .normal)
      progressView.isHidden = false
      labelCountdown.isHidden = false
      displayQuestionAndAnswers()
    } else {
      lightningButton.setTitle("Lightning Mode", for: .normal)
      disableAndEnableClickOnAnswers()
      initHome()
    }
  }
  
  func timeOut() {
    
    timer.invalidate()
    timerIsOn = false
    disableAndEnableClickOnAnswers()
    normalButton.isHidden = false
    
    self.quizManager.timeOut()
    
    answersWithFeedback()
  }
  
  
  // MARK: Helper Methods
  
  func timerRunning() {
    
    if timeRemaining >= 0 {
    
      progressView.setProgress(Float(timeRemaining)/Float(totalTime), animated: false)
      labelCountdown.text = "\(timeRemaining)"
      
    } else {
      timeOut()
    }
    
    timeRemaining -= 1
  }
}

