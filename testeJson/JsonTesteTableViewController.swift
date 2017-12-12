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
import SVProgressHUD

class JsonTesteTableViewController: UIViewController {

    @IBOutlet weak var txtViewVoce: ErrorTextField!
    
    let urlString: String = "http://careers.picpay.com/tests/mobdev/users"
    
    var itemList: [String] = [String]()
    
    var clientes: [Clientes] = [Clientes]()
    var validarCliente: String = ""
    var validarID: Int = -1
    var validarUser: String = ""
    var validarImagem: UIImage?
    
    
    //parte 2
    
    @IBOutlet weak var seuId: UILabel!
    @IBOutlet weak var seuNome: UILabel!
    @IBOutlet weak var suaFoto: UIImageView!
    @IBOutlet weak var seuUsuario: UILabel!
    
    
    
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
        SVProgressHUD.show()
        self.clientes.removeAll()
         novoJson()
        
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
    
    private func novoJson(){
        let url: URL = URL(string: urlString)!
        print("novoJson")
        
        URLSession.shared.dataTask(with: url, completionHandler: {
            
            data, response, error in
        print("dataTask")
            guard error == nil else {
                print("ERROR")
                return
            }
            
            guard let data = data else {
                print("DATA")
                return
            }
            
            do {
                print("DO")
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [NSDictionary]
                
                for dict in json {
                    self.itemList.append(Clientes.clienteJson(dict: dict).nome)
                }
                SVProgressHUD.dismiss()
            } catch let error {
                print(error.localizedDescription)
            }
        }).resume()
        
        
        self.txtViewVoce.isErrorRevealed = false
        self.visualizaOpcoes(tipoOpcao: .cliente, titulo: "Quem é você? ", opcoes: self.itemList as [AnyObject])
    }
    
    
    private func getJson(){
        let url: URL = URL(string: urlString)!
        print("getJson")
        URLSession.shared.dataTask(with: url ){ (data, response, error) in
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
                    self.visualizaOpcoes(tipoOpcao: .cliente, titulo: "Quem é você? ", opcoes: self.itemList as [AnyObject])
                } catch let error as NSError {
                    print(error)
                }
            }
            }//.resume()
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
            if let existeNome = clienteSelecionado.nome {
                if let existeId: Int = clienteSelecionado.id {
                    if let existeImagem: UIImage = clienteSelecionado.imagem {
                        if let existeUser: String = clienteSelecionado.userName {
                            self.validarID = existeId
                            self.validarCliente = existeNome
                            self.validarImagem = existeImagem
                            self.validarUser = existeUser
                            
                            self.seuId.text = clienteSelecionado.nomeCliente()
                        }
                    }
                }
            }
        }
    }
}
