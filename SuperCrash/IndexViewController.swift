//
//  IndexViewController.swift
//  SuperCrash
//
//  Created by 王偉 on 2017/1/5.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        guard let path = Bundle.main.path(forResource: file as String, ofType: "sks") else {
            return nil
        }
        
        do {
            let sceneData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        }
        catch {
            print("Can't unarchive the scene.")
            return nil
        }
    }
}


class IndexViewController: UIViewController {
    
    let mode = arc4random()%2
    var flakeLayer:CAEmitterLayer!
    var unitColor:UIColor!
    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var viewTitle: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = OpenClass.shared
        data.screenWidth = self.view.bounds.width
        data.screenHeight = self.view.bounds.height
        
        
        self.view.backgroundColor = .black
        
        
        switch mode {
            // Thunder
        case 0:
            self.lightningEffect()
            self.labelVersion.text = "THUNDER"
            unitColor = .yellow
            self.changeStyle(color: .yellow)
            break
            // Snow
        case 1:
            self.setFlakeLayer(view:self.view)
            self.labelVersion.text = "ICE"
            unitColor = UIColor.init(red:(210/255.0), green: (210/255.0), blue: (210/255.0), alpha: 1)
            self.changeStyle(color:UIColor.init(red:(210/255.0), green: (210/255.0), blue: (210/255.0), alpha: 1))
            break
        case 2:
            
            break
        default:
            
            break
        }
        
        
        
    }

// MARK: 打雷模式
    func lightningEffect(){
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            
            let skView = SKView(frame: self.view.bounds)
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)

            self.view.addSubview(skView)
            self.view.bringSubviewToFront(self.btnStart)
            self.view.bringSubviewToFront(self.viewTitle)
            self.view.bringSubviewToFront(self.labelVersion)
        }

    }
 
    
// MARK: 下雪模式
    
    func setFlakeLayer(view:UIView){
        
       flakeLayer = CAEmitterLayer()
       let bounds = UIScreen.main.bounds
       // 發射位置
       flakeLayer.emitterPosition = CGPoint(x:bounds.width/2, y: -10)
       // 發射源尺寸大小
       flakeLayer.emitterSize = CGSize(width:bounds.width * 2.0,height:0.0)
       // 發射模式
        flakeLayer.emitterShape = CAEmitterLayerEmitterShape.line
        flakeLayer.emitterMode = CAEmitterLayerEmitterMode.outline
        
       flakeLayer.emitterCells = NSArray.init(object:self.flakeCell()) as? [CAEmitterCell]
        
        view.layer.insertSublayer(flakeLayer, at: 0)
    }
    
    func flakeCell() -> CAEmitterCell {
        
        let flakeCell = CAEmitterCell()
        // 粒子圖片
        flakeCell.contents = UIImage(named:"flake")?.cgImage
        // 粒子生成速率
        flakeCell.birthRate = 10
        // 粒子生命週期
        flakeCell.lifetime = 120.0
        flakeCell.lifetimeRange = 0.5
        // 速度設置
        flakeCell.velocity = -5
        flakeCell.velocityRange = 10
        flakeCell.yAcceleration = 10
        flakeCell.emissionLongitude = -CGFloat.pi/2.0
        flakeCell.emissionRange = CGFloat.pi/4
        flakeCell.spinRange = 0.25 * CGFloat.pi
        flakeCell.scale = 0.5
        flakeCell.scaleSpeed = 0.1
        flakeCell.scaleRange = 1.0
        // 顏色設定
//        flakeCell.color = UIColor(colorLiteralRed:1, green:1, blue:1, alpha:1).cgColor
//        flakeCell.redRange = 1.0
//        flakeCell.redSpeed = 0.1
//        flakeCell.blueRange = 1.0
//        flakeCell.blueSpeed = 0.1
//        flakeCell.greenRange = 1.0
//        flakeCell.greenSpeed = 0.1
        flakeCell.alphaSpeed = -0.08

        
       return flakeCell
    }
//
    @IBAction func btn_Start(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tapBoxVC") as! TapBoxViewController
        vc.color = unitColor
        self.present(vc, animated: false, completion: nil)
    }
// MARK: change style
    func changeStyle(color:UIColor){
        
        self.labelVersion.textColor = color
        self.labelTitle.textColor = color
        self.labelSubTitle.textColor = color
        self.btnStart.setTitleColor(color, for:.normal)
        self.shineBtn(color:.white)
    }
    func shineBtn(color:UIColor){
        
        UIView.animate(withDuration:1, delay: 0, options:.repeat, animations:{
        
            self.btnStart.titleLabel?.layer.shadowColor = color.cgColor
            self.btnStart.titleLabel?.layer.shadowRadius = 2.0;
            self.btnStart.titleLabel?.layer.shadowOpacity = 0.9;
            self.btnStart.titleLabel?.layer.shadowOffset = CGSize.zero;
            self.btnStart.titleLabel?.layer.masksToBounds = false;
            self.shineText(label:self.labelTitle, color: color)
            self.shineText(label:self.labelSubTitle, color: color)
            self.shineText(label:self.labelVersion, color: color)
        }, completion:{ bool in
        
        })
    }
    
    func shineText(label:UILabel,color:UIColor){
        label.layer.shadowColor = color.cgColor
        label.layer.shadowRadius = 2.0;
        label.layer.shadowOpacity = 0.9;
        label.layer.shadowOffset = CGSize.zero;
        label.layer.masksToBounds = false;
    }
}
