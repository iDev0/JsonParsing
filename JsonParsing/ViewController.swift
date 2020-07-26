//
//  ViewController.swift
//  JsonParsing
//
//  Created by iDev0 on 2020/07/26.
//  Copyright © 2020 Ju Young Jung. All rights reserved.
//

import UIKit
import ProgressHUD

class ViewController: UIViewController {

    let apiUrl = "https://api.kivaws.org/v1/loans/newest.json"
    
    @IBOutlet weak var newestTableView: UITableView!
    
    var loans: [Loan] = [Loan]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getLatestLoans()
        
        
        
        
    }
    
    // 네트워킹 함수
    func getLatestLoans() {
        let url = URL(string: apiUrl)
        
        let request = URLRequest(url: url!)
        
        ProgressHUD.show()
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                ProgressHUD.dismiss()
                return
            }
            
            self.loans = self.parseJsonData(data: data!)
            
            OperationQueue.main.addOperation {
                self.newestTableView.reloadData()
                ProgressHUD.dismiss()
            }
            
            
            // print(self.loans)
            
            // print(data)
            
        }.resume()
        
    }
    
    // 파싱 함수
    func parseJsonData(data: Data) -> [Loan] {
        var loans = [Loan]()
        
        do {
                
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
            
            // print(jsonResult)
            
            let jsonLoans = jsonResult!["loans"] as! [AnyObject]
            
            for obj in jsonLoans {
                var loan = Loan()
                loan.name = obj["name"] as! String
                loan.amount = obj["loan_amount"] as! Int
                loan.use = obj["use"] as! String
                
                let location = obj["location"] as! [String:AnyObject]
                loan.country = location["country"] as! String
                
                loans.append(loan)
            }
            
            print(jsonLoans)
            
            
        } catch {
            print(error)
        }
        
        return loans
    }


}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newestTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = loans[indexPath.row].name
        cell.detailTextLabel?.text = loans[indexPath.row].use
        
        return cell
    }
    
    
}


