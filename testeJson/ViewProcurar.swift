//
//  ViewProcurar.swift
//  testeJson
//
//  Created by Abilio Azevedo on 12/5/17.
//  Copyright © 2017 Marcos Moreira. All rights reserved.
//

import Foundation
import UIKit

protocol ViewProcurarProtocolo {
    func selecionar(tipo: EnumTipoOpcoes, cliente: Clientes?)
}

class ViewProcurar: UITableViewController {
    
    var searchBar: UISearchBar?
    var tipoOpcoes: EnumTipoOpcoes!
    var pesquisando: Bool = false
    var opcoesPesquisadas: [AnyObject] = [AnyObject]()
    var opcoes: [AnyObject] = [AnyObject]()
    var delegateOpcoes: ViewProcurarProtocolo!
    
    let urlString: String = "http://careers.picpay.com/tests/mobdev/users"
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tipoOpcoes == .cliente {
            configuraSearchBar()
        }
    }
    
    func configuraSearchBar() {
        searchBar = UISearchBar()
        
        if let _searchBar = searchBar {
            _searchBar.delegate = self as UISearchBarDelegate
            _searchBar.placeholder = "Pesquise por código ou texto"
            _searchBar.tintColor = UIColor.darkGray
            _searchBar.sizeToFit()
            _searchBar.isTranslucent = true
            tableView.reloadData()
        }
    }
    
    private func getJson(){
        let url: URL = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil {
                print("ERROR: ")
                print(error!)
            } else {
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [NSDictionary]
                    
                    for dict in json {
                        self.opcoes.append(Clientes.clienteJson(dict: dict))
                    }
                    self.tableView.reloadData()
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
    }

}

extension ViewProcurar: UISearchBarDelegate {
    
    //Função criando botão de cancelar na barra de pesquisa.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        pesquisando = false
        tableView.reloadData()
    }
    
    //Função para verificar se o usuário está digitando no campo de pesquisa
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        pesquisando = true
        opcoesPesquisadas = opcoes
        tableView.reloadData()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText == "" {
            pesquisando = false
        } else {
            pesquisando = true
            
            opcoesPesquisadas = opcoes.filter({
                if let opcao = $0 as? Clientes {
                    if let searchId = Int(searchText) {
                        return opcao.id == searchId
                    }
                    
                        return opcao.nome.range(of: searchText, options: [NSString.CompareOptions.caseInsensitive, NSString.CompareOptions.diacriticInsensitive]) != nil
                    
                }
                return false
            })
        }
        tableView.reloadData()
    }
}

extension ViewProcurar {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let searchBar = self.searchBar {
            return searchBar.frame.height
        }
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let searchBar = self.searchBar {
            return searchBar
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !pesquisando ? opcoes.count : opcoesPesquisadas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NovaCelula")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "NovaCelula")
        }
        
        var descricao: String?
        if let opcao = opcoesParaIndexPath(indexPath: indexPath as NSIndexPath) as? String {
            descricao = opcao
        }
        
        if let label = cell!.textLabel {
            label.font = UIFont(name: "Arial", size: 14.0)
            label.textColor = UIColor.black
            label.text = descricao
        }
        return cell!
    }
    
    /** - Função para retornar a quantidade de registro. */
    func opcoesParaIndexPath(indexPath: NSIndexPath) -> AnyObject {
        if !pesquisando {
            return self.opcoes[indexPath.row]
        }
        return self.opcoesPesquisadas[indexPath.row]
    }
    
    /** - Função envia o item específico selecionado. */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let opcao = opcoesParaIndexPath(indexPath: indexPath as NSIndexPath) as? Clientes {
            
            delegateOpcoes.selecionar(tipo: tipoOpcoes, cliente: opcao)
            appDelegate.num = 0
            appDelegate.nome = opcao.nome
            
            print("appDelegate: \(appDelegate.nome)")
            
        }
        if let _navigationController = self.navigationController {
            _navigationController.popViewController(animated: true)
        }
    }
}
