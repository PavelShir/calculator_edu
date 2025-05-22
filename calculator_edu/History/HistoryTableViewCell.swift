//
//  HistoryTableViewCell.swift
//  calculator_edu
//
//  Created by Павел Широкий on 22.05.2025.
//

import Foundation
import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet private weak var expressionLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    
    func configure(with expression: String, result: String) {
        expressionLabel.text = expression
        resultLabel.text = result
    }
}
