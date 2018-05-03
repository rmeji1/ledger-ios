//
//  Transaction.swift
//  ledge
//
//  Created by robert on 3/20/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

/* Java class
     private Long id;
     private Transaction_Type type ;
     private BigDecimal amount ;
     private Long table_id ;
     private Long casino_id ;
     private Long manager_id ;
     @JsonIgnore
     private Long employee_id ;
 */

import Foundation
import Alamofire
//class Transaction: Encodable{
//    
//    enum Transaction_Type : String {
//        case ADDITION
//        case SUBTRACTION
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case type = "type"
//        case amount = "amount"
//        case tableId = "table_id"
//        case casinoId = "casino_id"
//        case managerInitials = "manager_initials"
//        case employeeInitials = "emp_initials"
//        case managerId = "manager_id"
//        case employeeId = "employee_id"
//        case ledgerId = "ledger_id"
//    }
//    
//    var type : String // transaction_type.rawValue
//    var amount : Decimal
//    var tableId : Int64
//    var casinoId : Int64
//    var managerId : Int64
//    var employeeId : Int64
//    var ledgerId : Int64     // For now this isn't encoded or sent to server. 
//    var managerInitials : String
//    var employeeInitials : String
//    
//    init(){
//        type = ""
//        amount = Decimal(0)
//        tableId = 0
//        casinoId = 0
//        managerId = 0
//        ledgerId = 0
//        employeeId = 0
//        managerInitials = ""
//        employeeInitials = ""
//    }
//    
//}
//
//extension Transaction{
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(type, forKey: .type)
//        try container.encode(amount, forKey: .amount)
//        try container.encode(tableId, forKey: .tableId)
//        try container.encode(casinoId, forKey: .casinoId)
//        try container.encode(managerId, forKey: .managerId)
//        try container.encode(employeeId, forKey: .employeeId)
//        try container.encode(managerInitials, forKey: .managerInitials)
//        try container.encode(employeeInitials, forKey: .employeeInitials)
//    }
//    
//    func encodeToParameters() -> Parameters{
//        let parameters : Parameters = [
//            CodingKeys.type.stringValue             : type,
//            CodingKeys.amount.stringValue           : amount,
//            CodingKeys.tableId.stringValue          : tableId,
//            CodingKeys.casinoId.stringValue         : casinoId,
//            //CodingKeys.ledgerId.stringValue       : ledgerId,
//            //FIXME: - insert managerId
//            CodingKeys.employeeId.stringValue       : 0,
//            CodingKeys.managerId.stringValue        : 0,
//            CodingKeys.managerInitials.stringValue  : managerInitials,
//            CodingKeys.employeeInitials.stringValue : employeeInitials,
//            "casino" : [
//                "id" : 1
//            ]
//        ]
//        debugPrint(parameters)
//        return parameters
//    }
//}











