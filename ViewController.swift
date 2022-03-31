//
//  ViewController.swift
//  Cocktails
//
//  Created by MacPro on 29.03.2022.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {
        
    var Tags = [GradientButton]()
    
    var filtredTags = [GradientButton]()
    
    let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var textField: UITextField = {
        let textField = LeftPaddedTextField()
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.placeholder = "Cocktail name"
        textField.addTarget(self, action: #selector(searchTags(_ :)), for: .primaryActionTriggered)
        textField.addTarget(self, action: #selector(removeAllFilterTags(_ :)), for: .editingChanged)
        textField.dropShadow()
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        
        ApiManager.shared.alamofireRequest { [weak self] (Cocktails) in
            
            self?.createTags(cocktails: Cocktails)
            
            self?.activityIndicator.stopAnimating()
            
            self?.layoutTags()
        }
        
        setConstrainst()
    }
    
    //MARK: - Create Tags
    
    func createTags(cocktails: [Cocktail]) {
        
        cocktails.forEach { (cocktail) in
            let tag: GradientButton = {
                let tag = GradientButton()
                tag.setTitle(cocktail.strDrink, for: .normal)
                tag.titleLabel?.font = .boldSystemFont(ofSize: 17)
                tag.layer.cornerRadius = 10
                tag.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                tag.sizeToFit()
                tag.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                tag.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
                return tag
            }()
            Tags.append(tag)
        }
    }
    
    //MARK: - TextField tags search
    
    @objc func removeAllFilterTags(_ textField: UITextField) {
        if textField.text == "" {
            filtredTags = filtredTags.filter { (tag) -> Bool in
                tag.backgroundGradient = false
                return tag.backgroundGradient
            }
        }
    }
    
    @objc func searchTags(_ textField: UITextField) {
        if textField.text != "" {
            filtredTags = Tags.filter { (tag) -> Bool in
                tag.backgroundGradient = false
                return (tag.titleLabel!.text!.lowercased().contains(textField.text!.lowercased().trimmingCharacters(in: .whitespaces)))
            }
            
            filtredTags.forEach { (tag) in
                tag.backgroundGradient = true
            }
        }
    }
    
    //MARK: - Button target
    
    @objc func tap(_ sender: GradientButton) {
        if sender.isSelected == true {
            sender.backgroundGradient = false
            sender.isSelected = false
        } else {
            sender.backgroundGradient = true
            sender.isSelected = true
        }
    }
    
    //MARK: - TextField animation
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
                        
            textField.snp.updateConstraints { (make) in
                make.right.equalToSuperview().offset(0)
                make.left.equalToSuperview().offset(0)
                make.bottom.equalTo(-keyboardHeight)
                make.height.equalTo(40)
            }
            
            textField.layer.cornerRadius = 0
            scrollView.contentSize.height += keyboardHeight
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            textField.snp.updateConstraints(textFieldDefaultConstraints(_:))
            
            textField.layer.cornerRadius = 10
            scrollView.contentSize.height -= keyboardHeight
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

//MARK: - Hide keyboard on tap

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Layouts

extension ViewController {
    
    func textFieldDefaultConstraints(_ make: ConstraintMaker) -> Void {
        make.right.equalToSuperview().offset(-20)
        make.left.equalToSuperview().offset(20)
        make.bottom.equalTo(-40)
        make.height.equalTo(50)
    }
        
    func layoutTags() {
        let constant:CGFloat = 8
        var maxX:CGFloat = 0
        var maxY:CGFloat = 0
        
        for tag in Tags {
            scrollView.addSubview(tag)
            if (UIScreen.main.bounds.width - (maxX + 16 + tag.frame.width)) >= 8 {
                tag.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(constant + maxY)
                    make.left.equalToSuperview().offset(constant + maxX)
                }
                
            } else {
                maxY = maxY + tag.frame.height + 12
                maxX = 0
                tag.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(constant + maxY)
                    make.left.equalToSuperview().offset(constant)
                }
            }
            maxX = maxX + tag.frame.width + constant * 3
        }
        self.scrollView.contentSize.height = maxY + 150
    }
    
    func setConstrainst() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints(textFieldDefaultConstraints(_:))
    }
}

