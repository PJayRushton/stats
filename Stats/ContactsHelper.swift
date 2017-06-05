//
//  ContactsHelper.swift
//  Stats
//
//  Created by Parker Rushton on 6/3/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import ContactsUI
import Contacts

class ContactsHelper: NSObject {
    
    // MARK: - Types
    
    enum ContactsError: Error {
        case formatting
    }
    
    
    // MARK: - Init
    
    fileprivate let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    fileprivate let store = CNContactStore()

    
    // MARK: - Public 
    
    var contactSelected: ((Result<(String, String)>) -> Void) = { _ in }
    
    func addressButtonPressed() {
        presentContactPicker()
    }
    
    func presentErrorAlert() {
        let alert = UIAlertController(title: "This is awkward. . . 😅", message: "Something went wrong when selecting your contact", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Its OK 😞", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
            self.presentContactPicker()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - Private

extension ContactsHelper {
    
    fileprivate var contactKeys: [String] {
        return [CNContactPhoneNumbersKey]
    }
    
    fileprivate func presentContactPicker() {
        requestAccess { [unowned self] accessGranted in
            DispatchQueue.main.async {
                if accessGranted {
                    self.presentContactPickerViewController()
                } else {
                    self.presentPermissionErrorAlert()
                }
            }
        }
    }
    
    fileprivate func requestAccess(completion: ((Bool) -> Void)? = nil) {
        store.requestAccess(for: CNEntityType.contacts) { (granted, error) in
            completion?(granted)
        }
    }
    
    fileprivate func presentContactPickerViewController() {
        let contactPickerVC = CNContactPickerViewController()
        contactPickerVC.delegate = self
        contactPickerVC.title = "Select a phone number"
        contactPickerVC.navigationController?.navigationBar.tintColor = .flatSkyBlue
        Appearance.setUp(navTextColor: .flatSkyBlue)
        
        contactPickerVC.displayedPropertyKeys = self.contactKeys
        contactPickerVC.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPickerVC.predicateForSelectionOfContact = NSPredicate(format: "phoneNumbers.@count == 1")
        contactPickerVC.predicateForSelectionOfProperty = NSPredicate(format: "key == phoneNumber")
        
        viewController.present(contactPickerVC, animated: true, completion: nil)
    }
    
    fileprivate func presentPermissionErrorAlert() {
        let alert = UIAlertController(title: "Access Denied", message: "St@ needs access to your contacts enable this feature", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Too bad 🤐 ", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Sesame! 🚪", style: .default, handler: { _ in
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func process(contact: CNContact, contactProperty: CNContactProperty? = nil) {
        Appearance.setUp(navTextColor: .white)
        
        let name = contact.firstLastInitial
        
        if let phone = contactProperty?.value as? CNPhoneNumber {
            let selectedContact = (name, phone.stringValue)
            contactSelected(Result.success(selectedContact))
        } else if let phone = contact.phoneNumbers.first?.value {
            let selectedContact = (name, phone.stringValue)
            contactSelected(Result.success(selectedContact))
        } else {
            contactSelected(Result.failure(ContactsError.formatting))
        }
    }
    
}

extension ContactsHelper: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        process(contact: contactProperty.contact, contactProperty: contactProperty)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        process(contact: contact)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        Appearance.setUp(navTextColor: .white)
    }
    
}

extension CNContact {
    
    var firstLastInitial: String {
        return "\(givenName) \(familyName.firstLetter)"
    }
    
}
