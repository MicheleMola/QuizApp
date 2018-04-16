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
  
  var indexOfSelectedQuestion: Int = 0
  
  var gameSound: SystemSoundID = 0
  
  /*let trivia: [[String : String]] = [
    ["Question": "Only female koalas can whistle", "Answer": "False"],
    ["Question": "Blue whales are technically whales", "Answer": "True"],
    ["Question": "Camels are cannibalistic", "Answer": "False"],
    ["Question": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "Answer": "True"]
  ]*/
  
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
  let positiveFeedback: (text: String, color: UIColor) = ("Correct!", UIColor(red: 12/255, green: 121/255, blue: 150/255, alpha: 1))
  let negativeFeedback: (text: String, color: UIColor) = ("Sorry, wrong answer!!", UIColor.red)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    /*loadGameStartSound()
    // Start game
    playGameStartSound()*/
    answerButtons = [option1, option2, option3, option4]

    initHome()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func initHome() {
    hideAnswers()
    
    questionField.isHidden = true
    feedbackLabel.isHidden = true
    progressView.isHidden = true
    labelCountdown.isHidden = true
    
    normalButton.isHidden = false
    normalButton.setTitle("Normal Mode", for: .normal)
    
    lightningButton.setTitle("Lightning Mode", for: .normal)
  }
  
  
  func displayQuestionAndAnswers() {
    hideAnswers()

    if !progressView.isHidden {
      if !timerIsOn {
        timeRemaining = 15
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        timerIsOn = true
      }
    }
    
    self.question = quizManager.getRandomQuestion()
    
    questionField.text = self.question.text
    
    questionField.isHidden = false
    normalButton.isHidden = true
    lightningButton.isHidden = true
    feedbackLabel.isHidden = true
    
    for index in 0..<self.question.answers.count {
      let button = answerButtons[index]
      button.setTitle(self.question.answers[index].text, for: .normal)
      button.backgroundColor = colorButtons
      button.isHidden = false
    }
  }
  
  func hideAnswers() {
    for answer in answerButtons {
      answer.isHidden = true
    }
  }
  
  func displayScore() {
    // Hide the answer buttons
    hideAnswers()
    
    // Display play again button
    normalButton.isHidden = true

    lightningButton.isHidden = false
    lightningButton.setTitle("Play Again", for: .normal)

    feedbackLabel.isHidden = true
    progressView.isHidden = true
    labelCountdown.isHidden = true
    
    questionField.text = self.quizManager.feedbackRound()
    
    self.quizManager.resetGame()
  }
  
  @IBAction func checkAnswer(_ sender: UIButton) {
    disableAndEnableClickOnAnswers()
    
    startTimer()
    
    answersWithFeedback()
    
    let isCorrect = self.quizManager.isCorrect(answerWithIndex: sender.tag)
    
    if isCorrect {
      feedbackLabel.text = positiveFeedback.text
      feedbackLabel.textColor = positiveFeedback.color
    } else {
      feedbackLabel.text = negativeFeedback.text
      feedbackLabel.textColor = negativeFeedback.color
    }
    
    feedbackLabel.isHidden = false
    normalButton.isHidden = false
    
  }
  
  func startTimer() {
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
  
  /*func loadNextRoundWithDelay(seconds: Int) {
    // Converts a delay in seconds to nanoseconds as signed 64 bit integer
    let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
    // Calculates a time value to execute the method given current time and delay
    let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
    
    // Executes the nextRound method at the dispatch time on the main queue
    DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
      self.nextRound()
    }
  }*/
  
  func loadGameStartSound() {
    let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
    let soundURL = URL(fileURLWithPath: pathToSoundFile!)
    AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
  }
  
  func playGameStartSound() {
    AudioServicesPlaySystemSound(gameSound)
  }
  
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

