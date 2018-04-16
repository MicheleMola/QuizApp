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
  
  // Init QuizManager object to manage the game
  let quizManager = QuizManager()
  
  // Question object
  var question: Question!
  
  // Label that represents the text of the question
  @IBOutlet weak var questionField: UILabel!
  
  // Buttons representing the answers
  @IBOutlet weak var option1: UIButton!
  @IBOutlet weak var option2: UIButton!
  @IBOutlet weak var option3: UIButton!
  @IBOutlet weak var option4: UIButton!
  
  // Reusable button ("Normal Mode" and "Next Question")
  @IBOutlet weak var normalButton: UIButton!
  
  // Reusable button ("Lightning Mode" and "Play Again")
  @IBOutlet weak var lightningButton: UIButton!
  
  // Label for feedback text
  @IBOutlet weak var feedbackLabel: UILabel!
  
  // Progress View for graphic countdown
  @IBOutlet weak var progressView: UIProgressView!
  
  // Label with numerical countdown
  @IBOutlet weak var labelCountdown: UILabel!
  
  // Set of variables for the timer
  var timerIsOn = false
  var timer = Timer()
  var timeRemaining = 15
  let totalTime = 15
  
  // Collection of answer buttons
  var answerButtons: [UIButton] = []

  // Answer button color
  let colorButtons = UIColor(red: 12/255, green: 121/255, blue: 150/255, alpha: 1)
  
  // Tuples that contain text and color of feedback
  let positiveFeedback: (text: String, color: UIColor) = ("Correct!", UIColor(red: 12/255, green: 121/255, blue: 150/255, alpha: 1))
  let negativeFeedback: (text: String, color: UIColor) = ("Sorry, wrong answer!!", UIColor.red)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Round buttons
    roundedButtons()
    
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
  
  func roundedButtons() {
    option1.layer.cornerRadius = 10
    option2.layer.cornerRadius = 10
    option3.layer.cornerRadius = 10
    option4.layer.cornerRadius = 10
    
    normalButton.layer.cornerRadius = 10
    lightningButton.layer.cornerRadius = 10


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
    
    // Check if the Progress view is shown
    if !progressView.isHidden {
      
      // Check if the timer isn't On
      if !timerIsOn {
        
        // Reset time remaining for the new question
        timeRemaining = 15
        
        // Schedule the timerRunning function one time per second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        
        // Set timerIsOn to true
        timerIsOn = true
      }
    }
  }
  
  func stopTimer() {
    
    // Check if the Progress view is shown
    if !progressView.isHidden {
      
      // Check if the timer is On
      if timerIsOn {
        
        // Stops the timer
        timer.invalidate()
        
        // Set timerIsOn to false
        timerIsOn = false
      }
    }
  }
  
  func answersWithFeedback() {
    
    // Loop on the number of answers for question and I change background color to the buttons
    for index in 0..<question.answers.count {
      let button = answerButtons[index]
      button.backgroundColor = question.answers[index].isCorrect ? positiveFeedback.color : negativeFeedback.color
    }
  }
  
  func disableAndEnableClickOnAnswers() {
    
    // Enable all the answers if they are disabled and vice versa
    for answer in answerButtons {
      answer.isEnabled = !answer.isEnabled
    }
  }
  
  func nextRound() {
    
    // Check if the round is over
    if self.quizManager.isGameOver() {
      // Game is over and show the score
      displayScore()
    } else {
      // Continue game
      
      // Enable the clicks on the answers
      disableAndEnableClickOnAnswers()
      
      // Show a new question
      displayQuestionAndAnswers()
    }
  }
  
  @IBAction func normalAndNextQuestion(_ sender: UIButton) {
    
    // Check if the button title is "Normal Mode"
    if sender.title(for: .normal) == "Normal Mode" {
      
      // Show the first question
      displayQuestionAndAnswers()
      
      // Hide Progress view and countdown for Normal Mode
      progressView.isHidden = true
      labelCountdown.isHidden = true
      
      // Change button title to reuse it.
      normalButton.setTitle("Next Question", for: .normal)
    } else {
      
      // Call nextRound function
      nextRound()
    }
  }
  
  @IBAction func lightningAndPlayAgainButton(_ sender: UIButton) {
    
    // Change button title from "Normal Mode" to "Next Question" to reuse it.
    normalButton.setTitle("Next Question", for: .normal)
    
    // Check if the button title is "Lightning Mode"
    if sender.title(for: .normal) == "Lightning Mode" {
      
      // Change button title to reuse it.
      lightningButton.setTitle("Play Again", for: .normal)
      
      // Show Progress view and countdown for Lightning Mode
      progressView.isHidden = false
      labelCountdown.isHidden = false
      
      // Show the first question
      displayQuestionAndAnswers()
    } else {
      // Play again
      
      // Change button title from "Play Again" to "Lightning Mode" to reuse it
      lightningButton.setTitle("Lightning Mode", for: .normal)
      
      // Enable the clicks on the answers
      disableAndEnableClickOnAnswers()
      
      // Back to the menu to start new round
      initHome()
    }
  }
  
  func timeOut() {
    
    // Stops the timer
    timer.invalidate()
    
    // Set timerIsOn to false
    timerIsOn = false
    
    // Disable the clicks on the answers
    disableAndEnableClickOnAnswers()
    
    // Show the "Next Question" button
    normalButton.isHidden = false
    
    // Time expired on the question
    self.quizManager.timeOut()
    
    // Change background color to the buttons
    answersWithFeedback()
  }
  
  
  // MARK: Helper Methods
  
  func timerRunning() {
    
    // Check if the remaining time is greater or equal to zero
    if timeRemaining >= 0 {
    
      // Update Progress view
      progressView.setProgress(Float(timeRemaining)/Float(totalTime), animated: false)
      
      // Update countdown
      labelCountdown.text = "\(timeRemaining)"
      
    } else {
      
      // Time out
      timeOut()
    }
    
    // Decrease the remaining time
    timeRemaining -= 1
  }
}

