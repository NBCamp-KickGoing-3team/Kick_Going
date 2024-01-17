//
//  Rideable.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/17/24.
//

import Foundation

protocol Rideable {
    var id: Int { get set }
    var title : String { get set }
    var subtitle : String { get set }
    var latitude : Double { get set }
    var longitude : Double { get set }
    
}
