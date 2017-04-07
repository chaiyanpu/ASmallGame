//
//  ViewController.swift
//  simpleGame
//
//  Created by Yang on 2017/4/6.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    private let strX = "X"
    private let strO = "O"
    private let meWin:String = "ME WIN"
    private let onterWin:String = "OTHER WIN"
    private let aiWin:String = "AI WIN"
    private let tie:String = "TIE"
    
    @IBOutlet var btnCollection: [UIButton]!

    @IBOutlet weak var meWinScore: UILabel!
    
    @IBOutlet weak var AIWinScore: UILabel!
    @IBOutlet weak var otherWin: UILabel!
    
    @IBOutlet weak var meTie: UILabel!
    
    @IBOutlet weak var AITie: UILabel!
    @IBOutlet weak var otherTie: UILabel!
    
    @IBOutlet weak var xoSwitch: UIButton!
    @IBAction func xoBtnClick(_ sender: Any) {
        let btn = sender as? UIButton
        
        //如果不是新开始的游戏，转换按钮不可点击
        if canSelectArr.count != 9 {return}
        if btn != nil{
            switch self.isX {
            case true:
                self.isX = false
                btn!.setTitle("ME:" + strO, for: UIControlState.normal)
                
            default:
                self.isX = true
                btn!.setTitle("ME:" + strX, for: UIControlState.normal)
            }
            self.nextStep = self.isX
        }
    }
    
    @IBAction func voiceBtnClick(_ sender: UIButton) {
        switch self.isVioceOn  {
        case true:
            sender.setTitle("vioce:OFF", for: UIControlState.normal)
        default:
            sender.setTitle("vioce:ON", for: UIControlState.normal)
        }
        self.isVioceOn = !self.isVioceOn
        self.voiceManager.changePlay()
    }
 
    
    @IBAction func restartGame(_ sender: Any) {
        self.restart()
    }
 
    @IBAction func singleBtnClick(_ sender: Any) {
        let btn = sender as? UIButton
        guard btn != nil else {
            return
        }
        //如果不是新开始的游戏，转换按钮不可点击
        if canSelectArr.count != 9 {return}
        switch self.isSingle {
        case true:
            btn?.setTitle("double", for: UIControlState.normal)
        default:
            btn?.setTitle("single", for: UIControlState.normal)
        }
        self.isSingle = !self.isSingle
    }
    
    @IBAction func tapAction(_ sender: UIButton) {
        let btnTag:Int = sender.tag
    
        let flagArr:[Int] = xArr + oArr
        //判断是否已经选择
        for flag in flagArr {
            if btnTag == flag{
                return
            }
        }
        switch isSingle {
        case true:
            var nextFlag:Int = 0
            if self.isX == true{
                sender.setTitle(strX, for: UIControlState.normal)
                nextFlag = addFlagAndJudgment(&self.xArr,&self.oArr,btnTag)
                for btn in self.btnCollection{
                    if btn.tag == nextFlag{
                        btn.setTitle(strO, for: UIControlState.normal)
                    }
                }
            }else{
                sender.setTitle(strO, for: UIControlState.normal)
                nextFlag = addFlagAndJudgment(&self.oArr,&self.xArr,btnTag)
                for btn in self.btnCollection{
                    if btn.tag == nextFlag{
                        btn.setTitle(strX, for: UIControlState.normal)
                    }
                }
            }
           
        case false:
            
            //这一步为X
            if self.nextStep == true{
                sender.setTitle(strX, for: UIControlState.normal)
                addDoubleFlagAndJudgment(&self.xArr,btnTag,true)
            }else{//这一步为O
                sender.setTitle(strO, for: UIControlState.normal)
                addDoubleFlagAndJudgment(&self.oArr,btnTag,false)
            }
            //下一步必须是另外的人
            self.nextStep = !nextStep
        }
        
    }
    //voice状态
    private var isVioceOn = true
    //音乐管理者
    private var voiceManager:VoiceManager = VoiceManager()
    //单人模式还是双人模式
    private var isSingle:Bool = true
    //单人模式下选的人物
    private var isX:Bool = true
    //双人模式下下一步 true代表X
    lazy var nextStep:Bool = true
    //可以赢得组合
    private let winArr:[[Int]] = [[1,2,3],[1,4,7],[1,5,9],[2,5,8],[3,5,7],[3,6,9],[4,5,6],[7,8,9]]
    //可以选择的tag
    var canSelectArr:[Int] = [1,2,3,4,5,6,7,8,9]
    //用来存放x的组合
    var xArr:[Int] = []
    //用来存放o的组合
    var oArr:[Int] = []
    //number
    private var meWinNum:Int = 0
    private var otherWinNum:Int = 0
    private var AIWinNum:Int = 0
    private var meTieNum = 0
    private var otherTieNum = 0
    private var aiTieNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化
    }
    
    //单人模式下添加并判断数据
    /*arr1:传入xArr或者是传入oArr
     *arr2:传入xArr或者是传入oArr
     *flag:用于单人模式，表示用户上一步的步
     *return:用于单人模式，返回AI所点选的步，返回0代表没有AI或者和棋
     */
    func addFlagAndJudgment(_ arr1:inout [Int],_ arr2:inout [Int],_ flag:Int) -> Int{
        arr1.append(flag)
        if judgment(arr1) == true{
            alert(title: self.meWin)
            return 0
        }
        var nextFlag:Int?
        if canSelectArr.count != 1{
            nextFlag = random(flag)
            arr2.append(nextFlag!)
            if judgment(arr2) == true{
                alert(title: self.aiWin)
            }
            return nextFlag!
        }
        if oArr.count + xArr.count == 9{
            alert(title:self.tie)
            
        }
        return nextFlag ?? 0
    }
    
    //双人模式下
    func addDoubleFlagAndJudgment(_ arr:inout [Int],_ flag:Int,_ X:Bool){
        arr.append(flag)
        
        //移除已选中的值
        for (index,value) in canSelectArr.enumerated(){
            if value == flag{
                canSelectArr.remove(at: index)
            }
        }
        
        if judgment(arr) == true{
            if (X == false){//x 输了
                if self.isX == false{
                    alert(title: self.meWin)
                }else if self.isSingle == true{
                    alert(title: self.aiWin)
                }else{
                    alert(title: self.onterWin)
                }
            }else{ //x 赢了
                if self.isX == true{
                    alert(title: self.meWin)
                }else if self.isSingle == true{
                    alert(title: self.aiWin)
                }else{
                    alert(title: self.onterWin)
                }
            }
        }
        if oArr.count + xArr.count == 9{
            alert(title: self.tie)
            
        }
    }
    
    //判断输赢
    func judgment(_ arr:[Int]) -> Bool{
        var isWin:Bool = false
        for win in winArr{
            let one = win[0]
            let two = win[1]
            let three = win[2]
            var flag = 0
            for i in arr{
                if one == i{ flag += 1 }
                if two == i{ flag += 1 }
                if three == i{ flag += 1 }
            }
            if flag == 3{
                //Win
                isWin = true
            }
            flag = 0
        }
        return isWin
    }
    
    //随机数生成器
    func random(_ flag:Int) -> Int{
        for (index,value) in canSelectArr.enumerated(){
            if value == flag{
                canSelectArr.remove(at: index)
            }
        }
        let random = arc4random() % UInt32(canSelectArr.count - 1)
        let index = Int(random + 1)
        let aiTag = canSelectArr[index]
        canSelectArr.remove(at: index)
        
        return aiTag
    }
    
    //弹框
    func alert(title:String){
        switch title {
        case self.meWin:
            self.meWinNum += 1
            self.meWinScore.text = "\(meWinNum)"
        case self.onterWin:
            self.otherWinNum += 1
            self.otherWin.text = "\(otherWinNum)"
        case self.aiWin:
            self.AIWinNum += 1
            self.AIWinScore.text = "\(AIWinNum)"
        case self.tie:
            self.meTieNum += 1
            self.meTie.text = "\(meTieNum)"
            if self.isSingle == true{
                self.aiTieNum += 1
                self.AITie.text = "\(aiTieNum)"
            }else{
                self.otherTieNum += 1
                self.otherTie.text = "\(otherTieNum)"
            }
        default:
            break
        }
        let alert = UIAlertView(title: title, message: "", delegate: self, cancelButtonTitle: "确定")
        alert.show()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func restart(){
        //初始化，重新开始
        for btn in self.btnCollection{
            btn.setTitle("", for: UIControlState.normal)
        }
        self.canSelectArr = [1,2,3,4,5,6,7,8,9]
        self.oArr = []
        self.xArr = []
        self.nextStep = self.isX
    }

}
extension ViewController:UIAlertViewDelegate{
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        self.restart()
    }
    
}
