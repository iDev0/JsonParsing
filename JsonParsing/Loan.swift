//
//  Loan.swift
//  JsonParsing
//
//  Created by iDev0 on 2020/07/26.
//  Copyright © 2020 Ju Young Jung. All rights reserved.
//

import Foundation


//struct Loan {
//    var name : String = ""
//    var country : String = ""
//    var use: String = ""
//    var amount: Int = 0
//}


struct Loan: Codable {
    
    var name : String = ""
    var use : String = ""
    var amount : Int = 0
    var country : String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case country = "location"
        case use
        case amount = "loan_amount"
    }
    
    enum LocationKeys: String, CodingKey {
        case country
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        use = try values.decode(String.self, forKey: .use)
        amount = try values.decode(Int.self, forKey: .amount)
        
        let location = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
        country = try location.decode(String.self, forKey: .country)
    }
    
    
    
}

struct LoanDataStore: Codable {
    var loans: [Loan]
}
