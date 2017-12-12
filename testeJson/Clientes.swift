//
//  Clientes.swift
//  testeJson
//
//  Created by Abilio Azevedo on 12/5/17.
//  Copyright © 2017 Marcos Moreira. All rights reserved.
//

import Foundation
import UIKit

class Clientes {
    
    var id: Int = 0
    var nome: String = ""
    var imagem: UIImage?
    var userName: String = ""
    
    init(id: Int?, nome: String?, imagem: UIImage?, userName: String) {
        self.id = id!
        self.nome = nome!
        self.imagem = imagem
        self.userName = userName
    }
    
    /** - returns: Descrição cliente */
    func idCliente() -> Int? {
        if let _id = self.id {
            return _id
        }
        return -1
    }
    
    func nomeCliente() -> String? {
        if let nome = self.nome {
            return String(format: nome)
        }
        
        return nil
    }
    
    
    class func clienteJson(dict: NSDictionary) -> Clientes {
        
        var idCliente: Int?
        if let id = dict["id"] as? Int {
            idCliente = id
        }
        
        var nomeCliente: String?
        if let nome = dict["name"] as? String {
            nomeCliente = nome
        }
        
        var imagemCliente: UIImage?
        if let image = dict["imagem"] as? UIImage {
            imagemCliente = image
        }
        
        var userNameCliente: String?
        if let userCliente = dict["username"] as? String {
            userNameCliente = userCliente
        }
        
        
        return Clientes(id: idCliente, nome: nomeCliente, imagem: imagemCliente, userName: userNameCliente!)
    }
}
