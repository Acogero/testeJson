//
//  JsonTesteTableViewController.swift
//  testeJson
//
//  Created by Abilio Azevedo on 12/11/17.
//  Copyright © 2017 Marcos Moreira. All rights reserved.
//

import UIKit
import Material
import Foundation

class JsonTesteTableViewController: UIViewController {

    @IBOutlet weak var txtViewVoce: ErrorTextField!
    
    let urlString: String = "http://careers.picpay.com/tests/mobdev/users"
    
    var itemList: [String] = [String]()
    
    var clientes: [Clientes] = [Clientes]()
    var validarCliente: String = ""
    var codigoCliente: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtViewVoce.delegate = self as? UITextFieldDelegate
        print("viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnVoce(_ sender: Any) {
        print("btnVoce")
         getJson()
    }
    
    private func validarCampo() -> Bool {
        var clienteNome: String = ""
        
        if txtViewVoce.text != "" {
            if let nomeCliente = txtViewVoce.text {
                if self.validarCliente == txtViewVoce.text {
                    clienteNome = nomeCliente
                    txtViewVoce.isErrorRevealed = false
                } else {
                    txtViewVoce.detailLabel.text = "Insira um nome"
                    txtViewVoce.isErrorRevealed = true
                }
            }
        }
        
        return (!clienteNome.isEmpty)
    }
    
    private func getJson(){
        let url: URL = URL(string: urlString)!
        print("getJson")
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil {
                print("ERROR: ")
                print(error!)
            } else {
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [NSDictionary]
                    
                    for dict in json {
                        self.itemList.append(Clientes.clienteJson(dict: dict).nome)
                    }
                    
                    self.txtViewVoce.isErrorRevealed = false
                    self.visualizaOpcoes(tipoOpcao: .cliente, titulo: "Quem é você? ", opcoes: self.clientes as [AnyObject])
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
    }
    
    /** - Exibe as opções retornada pelo servidor.*/
    func visualizaOpcoes(tipoOpcao: EnumTipoOpcoes, titulo: String, opcoes: [AnyObject]) {
        let controllerOpcoes = PesquisaViewController()
        controllerOpcoes.title = titulo
        controllerOpcoes.delegateOpcoes = self
        controllerOpcoes.tipoOpcoes = tipoOpcao
        controllerOpcoes.opcoes = opcoes
        self.navigationController!.pushViewController(controllerOpcoes, animated: true)
    }
    
}

extension JsonTesteTableViewController: PesquisaViewControllerProtocol {
    
    func seleciona(tipo: EnumTipoOpcoes, cliente: Clientes?) {
        print("JsonTesteTableViewController")
        if let clienteSelecionado = cliente {
            if let _nomeCliente: String = clienteSelecionado.nome {
                self.validarCliente = _nomeCliente
            }
        }
    }
}
