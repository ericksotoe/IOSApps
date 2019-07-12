//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // instance variables
    let allQuestions = QuestionBank() // holds all questions
    var pickedAnswer : Bool = false
    var questionNumber : Int = 0
    var score : Int = 0
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextQuestion()
    }
    
    // runs when we click either true or false
    @IBAction func answerPressed(_ sender: AnyObject) {
        // checks to see if the user pressed true or false
        if (sender.tag == 1) {
            pickedAnswer = true
        }
        else if (sender.tag == 2) {
            pickedAnswer = false
        }
        
        // handles the checking and increment of questions
        checkAnswer()
        questionNumber += 1
        nextQuestion()
    }
    
    // this functin handles updating the score and both question trackers
    func updateUI() {
        scoreLabel.text = "score: \(score)"
        progressLabel.text = "\(questionNumber + 1) / 13"
        progressBar.frame.size.width = (view.frame.size.width / 13) * CGFloat(questionNumber + 1)
    }
    
    // this function handles going to the next question as well as reseting the questions if done
    func nextQuestion() {
        // runs normally if we haven't finished
        if (questionNumber <= 12) {
        questionLabel.text = allQuestions.list[questionNumber].questionText
            updateUI()
        }
        // if we are done this will show the msg that displays the score and allows to reset quiz
        else {
            let alert = UIAlertController(title: "Your Score was \(score)", message: "All questions have been completed, would you like to start over?", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Restart", style: .default) { (UIAlertAction) in
                self.startOver() // resets the screen so that we start at question one
            }
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
        }

    }
    
    // this function checks the answer given with the correct answer stored in questionbank
    func checkAnswer() {
        let correctAnswer = allQuestions.list[questionNumber].answer
        
        if (correctAnswer == pickedAnswer) {
            ProgressHUD.showSuccess("Correct")
            score += 1
        }
        else {
            ProgressHUD.showError("Wrong!")
        }
        updateUI()
    }
    
    // resets the score and questionNumber
    func startOver() {
        score = 0
        questionNumber = 0
        nextQuestion()
    }
    
}
