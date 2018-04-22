//
//  Hello.swift
//  BabyTropicalMath
//
//  Created by Tema Sysoev on 26.03.2018.
//  Copyright © 2018 Tema Sysoev. All rights reserved.
//

import UIKit
import GameKit
import GameplayKit


class HelloViewController: UIViewController, GKGameCenterControllerDelegate {
    
    
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID = "com.score.babytropicalmath"
    @IBAction func addScoreAndSubmitToGC(_ sender: AnyObject) {
        
    }
    @IBAction func checkGCLeaderboard(_ sender: AnyObject) {
        
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    func saveKarma(maxKarma :Int) {
        UserDefaults.standard.set(Karma.maxKarma, forKey: "maxKarma")
        print("Stored karma is ", Karma.maxKarma)
    }
    
    func loadKarma() -> Int{
        return UserDefaults.standard.integer(forKey:"maxKarma") > 0 ? UserDefaults.standard.integer(forKey:"maxKarma"): 4
    }
    
    func increaseKarma() -> Int{
        return 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Karma.maxKarma = loadKarma()
        authenticateLocalPlayer()
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(Karma.maxKarma)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                //self.karmaLabel.text = "\(String(describing: GKLocalPlayer.localPlayer().displayName)):    \(Karma.maxKarma)"
                print(error!.localizedDescription)
            } else {
                //self.karmaLabel.text = "\(String(describing: GKLocalPlayer.localPlayer().displayName)):    \(Karma.maxKarma)"
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

}
