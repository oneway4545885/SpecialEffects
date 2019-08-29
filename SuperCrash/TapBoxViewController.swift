//
//  TapBoxViewController.swift
//  SuperCrash
//
//  Created by 王偉 on 2017/1/6.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit

class TapBoxViewController: UIViewController {

    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    var timeOutView:UIView!
    var reciprocalNum:Int = 4
    var gameTimer:Timer?
    var btnArry:NSMutableArray!
    var btnWidth:CGFloat! = 150.0
    var gameScore:Int = 0
    var completeMission:Bool! = true
    var color:UIColor!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelCount.textColor = color;
        self.labelScore.textColor = color;
        
        self.labelScore.isHidden = true
        
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reciprocalCount(timer:)), userInfo: nil, repeats: true)
        
        timer.fire()
    }


    @objc func reciprocalCount(timer:Timer){
        
        reciprocalNum -= 1
        
        if reciprocalNum >= 0 {
            if reciprocalNum == 0{
                self.labelCount.text = "START"
            }else{
                self.labelCount.text = String(format:"%d",reciprocalNum)
            }
           
        }else{
            timer.invalidate()
            self.labelCount.isHidden = true
            self.labelScore.isHidden = false
            self.startGame()
        }
    }
    
    func startGame(){
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createBtn), userInfo: nil, repeats: true)
        
        gameTimer?.fire()
    }
    
    @objc func createBtn(){
        
        
        

        if completeMission == true {
            
                self.btnArry = NSMutableArray()
                let height:CGFloat = 5.0
                timeOutView = UIView(frame:CGRect(x: -self.view.bounds.width,
                                                  y: self.view.bounds.height - height,
                                              width:self.view.bounds.width,
                                             height: height))
                timeOutView.backgroundColor = .white
            
                self.view.addSubview(timeOutView)
            
            for _ in 0...self.gameLevel(){
                
                let side = btnWidth - CGFloat(self.gameLevel() * 20)
                let arcX = CGFloat(arc4random() % UInt32(self.view.bounds.width - side))
                let arcY = CGFloat(arc4random() % UInt32(self.view.bounds.height - side))
                let btn = UIButton(frame:CGRect(x:arcX, y:arcY, width:side, height:side))
                btn.backgroundColor = color
                btn.addTarget(self, action:#selector(closeBtn(btn:)), for: .touchUpInside)
                btn.layer.borderWidth = 1.0
                btn.layer.borderColor = UIColor.black.cgColor
                self.view.addSubview(btn)
                self.btnArry.add(btn)
            }
            
            UIView.animate(withDuration:1, delay:0, options: ([.curveLinear]), animations: {() -> Void in
                
                self.timeOutView.center = CGPoint(x:self.view.center.x, y:self.timeOutView.center.y)
                
            }, completion:
                
                { _ in
                    
                    
            })
            
            
        }else{
            
            let alert = UIAlertController(title:"廢物掰掰", message:"", preferredStyle: .alert)
            let gg = UIAlertAction(title:"滾", style: .default, handler: { action in
                self.dismiss(animated:true, completion:nil)
            })
            alert.addAction(gg)
            self.present(alert, animated: false, completion: nil)
        }
        
        completeMission = false
    }
    
    @objc func closeBtn(btn:UIButton?){
        
        var button = btn
        btnArry.remove(button!)
        button?.removeFromSuperview()
        button = nil
        
        if btnArry.count == 0 {
        
            completeMission = true
            self.gameScore += 1
            self.labelScore.text = String(format:"%d",self.gameScore)
            self.gameTimer?.invalidate()
            self.gameTimer = nil
            
            self.timeOutView.removeFromSuperview()
            self.timeOutView = nil
            
            self.startGame()
            
        }
    }
// MARK: game Setting
    func gameLevel() -> Int {
        let i = self.gameScore/10
        return i
    }
    
    

}
