//
//  ViewController.swift
//  testeJson
//
//  Created by Abilio Azevedo on 12/4/17.
//  Copyright © 2017 Marcos Moreira. All rights reserved.
//

import UIKit
import Foundation
import Material

class ViewController: UIViewController {

    
    var clientes:[Clientes] = [Clientes]()
    
    @IBOutlet weak var idCliente: UILabel!
    @IBOutlet weak var nomeCliente: UILabel!
    @IBOutlet weak var userCliente: UILabel!
    @IBOutlet weak var imgCliente: UIImageView!
    
    @IBOutlet weak var voce: ErrorTextField!
    @IBOutlet weak var destinatario: ErrorTextField!
    
    var validarNome: String = ""
    var validarCodigo: Int = -1
    var opcao: Int = -1
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    @IBAction func btnVoce(_ sender: Any) {
        
    }
    
    func pararEdicao() {
        voce.endEditing(true)
        destinatario.endEditing(true)
    }
    /** - Exibe as opções retornada pelo servidor.*/
    func visualizaOpcoes(tipoOpcao: EnumTipoOpcoes, titulo: String, opcoes: [AnyObject]) {
        let controllerOpcoes = ViewProcurar()
        controllerOpcoes.title = titulo
        controllerOpcoes.delegateOpcoes = self
        controllerOpcoes.tipoOpcoes = tipoOpcao
        controllerOpcoes.opcoes = opcoes
        self.navigationController!.pushViewController(controllerOpcoes, animated: true)
    }
    
}

extension ViewController: ViewProcurarProtocolo {
    func selecionar(tipo: EnumTipoOpcoes, cliente: Clientes?) {
        if let nomeSelecionado = cliente {
                    
            self.validarNome = nomeSelecionado.nome
            self.validarCodigo = nomeSelecionado.id
        }
    }
}

