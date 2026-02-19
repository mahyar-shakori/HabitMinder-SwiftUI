//
//  AddObjectBody.swift
//  HabitMinder
//
//  Created by Mahyar on 16/10/2025.
//

struct AddObjectBody: Encodable {
    let name: String
    let data: DataField
    
    struct DataField: Encodable {
        let year: Int
        let price: Double
    }
}
