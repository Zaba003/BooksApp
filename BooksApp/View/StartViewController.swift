//
//  StartViewController.swift
//  BooksApp
//
//  Created by Кирилл Заборский on 04.10.2021.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var booksKeeperImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    var circularView = CircularProgressView()
    var duration: TimeInterval!
    var booksKeeperContainerView: UIView!
    var logoContainerView: UIView!
    var startButtonContainerView: UIView!
    var firstStart = UserDefaults.standard.bool(forKey: "isFirstStart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCircularProgressBarView()
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isFirstStart")
        transition()
    }
    
    func setUpCircularProgressBarView() {
        
        duration = TimeInterval(Int.random(in: 2..<5))
        circularView.center = view.center
        circularView.progressAnimation(duration: duration)
        
        booksKeeperContainerView = UIView(frame: view.bounds)
        booksKeeperContainerView.frame = view.bounds
        logoContainerView = UIView(frame: view.bounds)
        logoContainerView.frame = view.bounds
        startButtonContainerView = UIView(frame: view.bounds)
        startButtonContainerView.frame = view.bounds
        
        view.addSubview(circularView)
        view.addSubview(booksKeeperContainerView)
        view.addSubview(logoContainerView)
        view.addSubview(startButtonContainerView)
        
        logoImageView.isHidden = true
        startButton.isHidden = true
        
        if firstStart == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.transition()
            }
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.circularView.isHidden = true
                self.containerView.isHidden = true
                
                UIView.transition(with: self.booksKeeperContainerView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: { self.booksKeeperContainerView.addSubview(self.booksKeeperImageView) },
                                  completion:
                                    { finished in
                    
                    self.logoImageView.isHidden = false
                    UIView.transition(with: self.logoContainerView,
                                      duration: 0.75,
                                      options: .transitionCrossDissolve,
                                      animations: { self.logoContainerView.addSubview(self.logoImageView) },
                                      completion: { finished in
                        
                        self.startButton.isHidden = false
                        UIView.transition(with: self.startButtonContainerView,
                                          duration: 0.75,
                                          options: .transitionCrossDissolve,
                                          animations: { self.startButtonContainerView.addSubview(self.startButton) },
                                          completion: nil
                        )}
                    )}
                )}
        }
    }
    
    private func transition() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateViewController(withIdentifier: "NavigationContoller") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
