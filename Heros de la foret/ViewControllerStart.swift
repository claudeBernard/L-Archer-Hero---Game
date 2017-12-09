import UIKit
//===
class ViewControllerStart: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //---
    @IBOutlet weak var inputUser: UITextField!
    @IBOutlet weak var tableRecords: UITableView!
    var usersMemory = UserDefaultsManager()
    var tableUsers = [String: Int]()
    var inputLabelUser: String!
    //---
    override func viewDidLoad() {
        super.viewDidLoad()
        tableRecords.backgroundColor = UIColor.clear
        inputUser.layer.cornerRadius = 25
        memorieVerification()
        self.inputUser.delegate = self
    }
    //---
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondView = segue.destination as! ViewController
        secondView.receivedString = inputUser.text!
    }
    //---
    func memorieVerification() {
        if usersMemory.doesKeyExist(theKey: "heros") {
            tableUsers = usersMemory.getValue(theKey: "heros") as! [String: Int]
        }
    }
    //---
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableUsers.count
    }
    //---
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor(red: 75/255, green: 108/255, blue: 144/255, alpha: 1)
        cell.textLabel?.font = UIFont(name: "American Typewriter", size: 20)
        if [String](tableUsers.keys)[indexPath.row] != "" {
        cell.textLabel?.text = "\([String](tableUsers.keys)[indexPath.row]) = \([Int](tableUsers.values)[indexPath.row])"
        }
        return cell
    }
    //---
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //---
    @IBAction func IdentUser(_ sender: UIButton) {
        var existUserInMemory = false
        inputLabelUser = inputUser.text!
        
        if inputLabelUser != "" {
            
            if usersMemory.doesKeyExist(theKey: "heros") {
                tableUsers = usersMemory.getValue(theKey: "heros") as! [String: Int]
                for index in 0..<tableUsers.count {
                    if  [String](tableUsers.keys)[index] == inputLabelUser {
                        existUserInMemory = true
                    }
                }
                if existUserInMemory == false {
                    tableUsers[inputLabelUser] = 0
                    usersMemory.setKey(theValue: tableUsers as AnyObject, key: "heros")
                }
                
            } else {
                tableUsers = [inputLabelUser: 0]
                usersMemory.setKey(theValue: tableUsers as AnyObject, key: "heros")
            }
            
        } else {
            tableUsers[inputLabelUser] = 0
            usersMemory.setKey(theValue: tableUsers as AnyObject, key: "heros")
        }
    }
    //---
}
