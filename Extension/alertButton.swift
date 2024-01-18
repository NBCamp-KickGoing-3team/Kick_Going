//
//  alertButton.swift
//  Kick_Going
//
//  Created by Jason Yang on 1/18/24.
//

import UIKit

func alertButton(in view: UIViewController, title: String, messgae: String, cancelbutton: Bool = true, okhandler: @escaping () -> Void = {}){
    let alert = UIAlertController(title: title, message: messgae, preferredStyle: .alert)
    let ok = UIAlertAction(title: "네", style: .default) {_ in
        okhandler()
    }
    let cancel = UIAlertAction(title: "아니오", style: .destructive)
    alert.addAction(ok)
    if cancelbutton == true {
        alert.addAction(cancel)
    }
    view.present(alert, animated: true)
}
