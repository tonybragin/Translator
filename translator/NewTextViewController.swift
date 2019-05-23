//
//  FirstViewController.swift
//  translator
//
//  Created by TONY on 21/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit
//import LanguageTranslator

class NewTextViewController: UIViewController {
    
    @IBOutlet weak var langPicker: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    
    private var request = LTRequest()
    
    private var languages: [Language]! {
        didSet {
            langPicker.delegate = self
            langPicker.dataSource = self
            request.target = languages.first?.language
            request.sender = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LTCustom().listIdentifiableLanguages() { result in
            switch result {
            case .failure(let error):
                self.alert(title: "Error", message: error.error)
            case .success(let response):
                DispatchQueue.main.async {
                    self.languages = response
                }
            }
        }
    }

    @IBAction func sendAction(_ sender: UIButton) {
        guard textView.text != ""  else {
            self.alert(title: "Error", message: "No text")
            return
        }
        
        request.text = textView.text
        
        LTCustom().identify(text: textView.text) { result in
            switch result {
            case .failure(let error):
                self.alert(title: "Error", message: error.error)
            case .success(let response):
                DispatchQueue.main.async {
                    self.request.source = response
                }
            }
        }
    }
    
    fileprivate func LTTranslate(request: inout LTRequest) {
        
        LTCustom().translate(text: request.text, source: request.source, target: request.target) { result in
            switch result {
            case .failure(let error):
                self.alert(title: "Error", message: error.error)
            case .success(let response):
                DispatchQueue.main.async {
                    self.request.translatedText = response
                }
            }
        }
    }
    
    fileprivate func LTTranslated(request: inout LTRequest) {
        do {
            let item = try CoreDataHelper().add(inputedText: request.text, source: request.source, target: request.target, translatedText: request.translatedText)
            
            self.performSegue(withIdentifier: "NewTextToItem", sender: item)
        } catch CoreDataErrors.saveError {
            self.alert(title: "Error", message: "Can't save data")
        } catch {
            print("unknown error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? ItemViewController else {return}
        guard let lts = sender as? Translator else {return}
        
        controller.item = lts
    }
    
}

extension UIViewController {
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
}

extension NewTextViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        request.target = languages[row].language
    }
}

extension NewTextViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    
}

fileprivate struct LTRequest {
    var sender: NewTextViewController!
    
    var text: String!
    var target: String!
    var source: String! {
        didSet {
            sender.LTTranslate(request: &self)
        }
    }
    var translatedText: String! {
        didSet {
            sender.LTTranslated(request: &self)
        }
    }
}
