//===
import UIKit
//===
class ViewController: UIViewController {
    //---
    @IBOutlet weak var archer: UIImageView!
    @IBOutlet weak var showChanges: UILabel!
    @IBOutlet weak var showScore: UILabel!
    @IBOutlet weak var configUser: UILabel!
    @IBOutlet weak var configScoreUser: UILabel!
    @IBOutlet weak var configScoreUserMemorie: UILabel!
    @IBOutlet weak var configContinue: UIButton!
    @IBOutlet weak var placarConfig: UIView!
    @IBOutlet weak var buttonConfig: UIButton!
    @IBOutlet weak var buttonLaunch: UIButton!
    @IBOutlet weak var slider: UISlider!
    var archerDates: Float!
    var arrow = UIImageView()
    var money = UIImageView()
    var aTimer: Timer!
    var aTimerAnimationMoney: Timer!
    var aTimerAnimationConfig: Timer!
    var cos: Double!
    var sin: Double!
    var controlPlay: Bool!
    var controlChanges: Int!
    var scoreUser: Int!
    var scoreMemory = 0
    var receivedString = ""
    var inputUser: String!
    var usersMemory = UserDefaultsManager()
    var tableUsers = [String: Int]()
    var tableUsersFinal = [String: Int]()
    var showPlacarConfig = false
    var parabola = 1.0
    //---
    override func viewDidLoad() {
        super.viewDidLoad()
        controlChanges = 5
        showChanges.text = String(controlChanges)
        scoreUser = 0
        showScore.text = String(scoreUser)
        money.frame = CGRect(x: Int((arc4random() % 200) + 300), y: Int((arc4random() % 170) + 30), width: 40, height: 60)
        createMoney()
        arrow.frame = CGRect(x: 0, y: 0, width: 40, height: 5)
        archerDates = 0
        createArrow()
        controlPlay = true
        inputUser = receivedString
        memoryVerification()
        configScoreUserMemorie.text = String(0)
    }
    //---
    func memoryVerification() {
        tableUsers = usersMemory.getValue(theKey: "heros") as! [String: Int]
        let index = tableUsers.index(forKey: inputUser)
        scoreMemory = tableUsers.values[index!]
    }
    //---
    @IBAction func movingArcher(_ sender: UISlider) {
        archerDates = sender.value
        UIView.animate(withDuration: 1.0, animations: {
            self.archer.transform = CGAffineTransform(rotationAngle: CGFloat(-(sender.value)))
            //print(CGFloat(-(sender.value)))
        })
    }
    //---
    func createArrow() {
        cos = __cospi(Double(0))
        sin = __sinpi(Double(0))
        arrow.image = UIImage(named: "arrow.png")
        arrow.layer.cornerRadius = 12.5
        arrow.center.x = archer.center.x + CGFloat(40 - Int(archerDates*25))
        arrow.center.y = archer.center.y - CGFloat(28 + Int(archerDates*25))
        self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }
    //---
    func createMoney() {
        money.image = UIImage(named: "money.png")
        money.layer.cornerRadius = 24
        money.center.x = CGFloat(Int((arc4random() % 200) + 300))
        money.center.y = CGFloat(Int((arc4random() % 170) + 30))
        self.view.addSubview(money)
    }
    //---
    func launchAnimation() {
        cos = __cospi(Double(-(archerDates/3)))
        sin = __sinpi(Double(-(archerDates/3)))
        self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(-(archerDates)))
        self.view.addSubview(arrow)
        aTimer = Timer.scheduledTimer(timeInterval: 0.002, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
    //--
    @objc func animate() {
        controlPlay = false
        if arrow.center.y < -30 || arrow.center.x > 735 || arrow.frame.intersects(money.frame){
            if arrow.frame.intersects(money.frame) {
                arrow.isHidden = true
                aTimerAnimationMoney = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(animateMoney), userInfo: nil, repeats: true)
                scoreUser = scoreUser + 10
                if scoreUser > scoreMemory {
                    let index = tableUsers.index(forKey: inputUser)
                    tableUsers.values[index!] = scoreUser
                    usersMemory.setKey(theValue: tableUsers as AnyObject, key: "heros")
                }
                showScore.text = String(scoreUser)
            } else if arrow.center.y < -30 || arrow.center.x > 735 {
                controlChanges = controlChanges - 1
                showChanges.text = String(controlChanges)
            }
            aTimer.invalidate()
            aTimer = nil
            controlPlay = true
            archer.image = UIImage(named: "hero1.png")
            if controlChanges == 0 {
                configContinue.isEnabled = false
                showConfig ()
            }
        }
        arrow.center.x += CGFloat(cos)
        
        if arrow.center.x <= 200 {
            arrow.center.y += CGFloat(sin/parabola)

        } else if arrow.center.x > 200 && arrow.center.x <= 270 {
            arrow.center.y += CGFloat(sin/(parabola*1.5))
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double(archerDates)/(parabola*1.5))))

        } else if arrow.center.x > 270 && arrow.center.x <= 305 {
            arrow.center.y += CGFloat(sin/(parabola*2.5))
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double(archerDates)/(parabola*2.5))))
            
        } else if arrow.center.x > 305 && arrow.center.x <= 340 {
            arrow.center.y += CGFloat(sin/(parabola*3))
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double(archerDates)/(parabola*3))))

        } else if arrow.center.x > 340 && arrow.center.x <= 375 {
            arrow.center.y -= CGFloat(0)
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(0))

        } else if arrow.center.x > 375 && arrow.center.x <= 410 {
            arrow.center.y -= CGFloat(sin/(parabola*3.5))
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(+(Double(archerDates)/(parabola*3.5))))

        } else if arrow.center.x > 410 && arrow.center.x <= 445 {
            arrow.center.y -= CGFloat(sin/(parabola*3))
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(+(Double(archerDates)/(parabola*3))))

        } else if arrow.center.x > 445 && arrow.center.x <= 515 {
            arrow.center.y -= CGFloat(sin/(parabola*1))
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(+(Double(archerDates)/(parabola*1))))

        } else if arrow.center.x > 515 {
            arrow.center.y -= CGFloat(sin/(parabola/2))
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(+(Double(archerDates)/(parabola/2))))
        }
        
        parabola += 0.004
    }
    //---
    @objc func animateMoney() {
        money.center.y -= CGFloat(-6)
        if money.center.y > 500 {
            aTimerAnimationMoney.invalidate()
            aTimerAnimationMoney = nil
            createMoney()
        }
    }
    //---
    @IBAction func launchArrow(_ sender: UIButton) {
        parabola = 1.0
        if controlPlay == true && controlChanges > 0{
            archer.image = UIImage(named: "hero2.png")
            arrow.isHidden = false
            createArrow()
            launchAnimation()
        } else if controlPlay == true && controlChanges == 0 {
            showConfig ()
        }
    }
    //---
    func showConfig () {
        money.isHidden = true
        configScoreUser.text = String(scoreUser)
        if inputUser != ""{
        configScoreUserMemorie.text = String(scoreMemory)
        }
        configUser.text = inputUser
        buttonConfig.isEnabled = false
        buttonLaunch.isEnabled = false
        slider.isEnabled = false
        aTimerAnimationConfig = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(animateConfig), userInfo: nil, repeats: true)
    }
    //---
    @objc func animateConfig() {
        if showPlacarConfig == false {
            placarConfig.center.y -= CGFloat(-3)
            if placarConfig.center.y > 120 {
                aTimerAnimationConfig.invalidate()
                aTimerAnimationConfig = nil
                showPlacarConfig = true
            }
        } else {
            placarConfig.center.y += CGFloat(-3)
            if placarConfig.center.y < -120 {
                aTimerAnimationConfig.invalidate()
                aTimerAnimationConfig = nil
                showPlacarConfig = false
                money.isHidden = false
                buttonConfig.isEnabled = true
                buttonLaunch.isEnabled = true
                slider.isEnabled = true
            }
        }
    }
    //---
    @IBAction func config(_ sender: UIButton) {
            showConfig ()
    }
    //---
    @IBAction func reset(_ sender: UIButton) {
        scoreUser = 0
        showScore.text = String(scoreUser)
        controlChanges = 5
        showChanges.text = String(controlChanges)
        showConfig ()
        configContinue.isEnabled = true
        memoryVerification()
    }
    //--
}

