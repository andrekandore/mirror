//
//  ViewClassPickerViewController.swift
//  Mirror
//
//  Created by アンドレ on 3/2/31 H.
//  Copyright © 31 Heisei Andrekandre. All rights reserved.
//

import UIKit
import WebKit

class ViewClassPickerViewController: UITableViewController {
    var additionalCustomUIViewClasses: [ViewType] = []
    var didPickViewClassCallback: ((ViewType) -> Void)?
}

extension ViewClassPickerViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.className, for: indexPath)
        cell.textLabel?.text = displayableViewClasses.any(at: indexPath.row)?.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayableViewClasses.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewClass = self.displayableViewClasses.any(at: indexPath.row)?.type else {
            return
        }
        
        self.didPickViewClassCallback?(viewClass)
    }
}

extension ViewClassPickerViewController {
    
    typealias ViewClassInfo = (type: ViewType, name: String)
    typealias ViewType = EncodableView.Type
    
    private var allViewClasses: [ViewType] {
        return builtinViewClasses + additionalCustomUIViewClasses
    }
    
    private var builtinViewClasses: [ViewType] {
        return [
            UIActivityIndicatorView.self,
//            UIAlertController.self,
            UIButton.self,
            UIDatePicker.self,
            UIImageView.self,
            UIPageControl.self,
            UIPickerView.self,
            UIProgressView.self,
            UISearchBar.self,
            UISegmentedControl.self,
            UISlider.self,
            UIStackView.self,
            UIStepper.self,
            UISwitch.self,
            UITextField.self,
            UITextView.self,
            UIToolbar.self,
            WKWebView.self
        ]
    }
    
    var displayableViewClasses: [ViewClassInfo] {
        return allViewClasses.map { type in
            return (type, type.className)
        }.sorted { tupple1, tupple2 in
            return tupple1.name < tupple2.name
        }
    }
}
