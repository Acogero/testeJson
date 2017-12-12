//
//  TesteJsonViewController.swift
//  testeJson
//
//  Created by Abilio Azevedo on 12/7/17.
//  Copyright © 2017 Marcos Moreira. All rights reserved.
//

import UIKit

class TesteJsonViewController: UIViewController {
    
    @IBOutlet weak var txtEscolha: UITextField!
    
    var appDelegate: AppDelegate!
    var opcao: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        opcao = appDelegate.num
        lerDados()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func lerDados(){
        if opcao != nil {
        }
    }
    @IBAction func textNome(_ sender: Any) {
        self.performSegue(withIdentifier: "segueVai", sender: self)
    }
}
