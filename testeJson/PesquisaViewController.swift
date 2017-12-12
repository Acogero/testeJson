//
//  PesquisaViewController.swift
//  testeJson
//
//  Created by Abilio Azevedo on 12/11/17.
//  Copyright © 2017 Marcos Moreira. All rights reserved.
//

import UIKit
import Foundation

protocol PesquisaViewControllerProtocol {
    func seleciona(tipo: EnumTipoOpcoes, cliente: Clientes?)
}

class PesquisaViewController: UITableViewController {

    var searchBar: UISearchBar?
    var delegateOpcoes: PesquisaViewControllerProtocol!
    var tipoOpcoes: EnumTipoOpcoes!
    var opcoes: [AnyObject] = [AnyObject]()
    var opcoesPesquisadas: [AnyObject] = [AnyObject]()
    var pesquisando: Bool = false
    var tintColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigation()
        
        if tipoOpcoes == .cliente {
            configuraSearchBar()
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** - Função para ocultar status bar do telefone */
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func navigation(){
        if let _navigationController = self.navigationController {
            _navigationController.navigationBar.isTranslucent = false
            _navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
            _navigationController.navigationBar.tintColor = UIColor.blue
        }
    }
    
    /** - Função chamada para criação da barra de pesquisa. */
    func configuraSearchBar() {
        searchBar = UISearchBar()
        
        if let _searchBar = searchBar {
            _searchBar.delegate = self as? UISearchBarDelegate
            _searchBar.placeholder = "Pesquise por código ou texto"
            _searchBar.tintColor = UIColor.blue
            _searchBar.sizeToFit()
            _searchBar.isTranslucent = true
            tableView.reloadData()
        }
    }
}

extension PesquisaViewController: UISearchBarDelegate {
    
    /** - Função criando botão de cancelar na barra de pesquisa. */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        pesquisando = false
        tableView.reloadData()
    }
    
    /** - Função para verificar se o usuário está digitando no campo de pesquisa. */
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        pesquisando = true
        opcoesPesquisadas = opcoes
        tableView.reloadData()
        return true
    }
    
    /** - Função para exibir o que foi digitado pelo usuário. */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            pesquisando = false
        } else {
            pesquisando = true
            opcoesPesquisadas = opcoes.filter({
                
                if let opcao = $0 as? Clientes {
                    if let searchId = Int(searchText) {
                        return opcao.id == searchId
                    }
                    
                    if let _nome: String = opcao.nome {
                        return _nome.range(of: searchText, options: [NSString.CompareOptions.caseInsensitive, NSString.CompareOptions.diacriticInsensitive]) != nil
                    }
                    
                }
                
                return false
            })
        }
        
        tableView.reloadData()
    }
}

extension PesquisaViewController {
    
    /** - Função que retorna a quantidade de seções. */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /** - Função para retornar a altura do cabeçalho na seção. */
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let searchBar = self.searchBar {
            return searchBar.frame.height
        }
        
        return 0.0
    }
    
    /** - Função que exibe uma quantidade de valores da seção. */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let searchBar = self.searchBar {
            return searchBar
        }
        
        return nil
    }
    
    /** - Função que retorna a quantidade de elementos para inserir na lista. */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !pesquisando ? opcoes.count : opcoesPesquisadas.count
    }
    
    /** - Função para verificar em qual celula da tabela será inserido o conteúdo. */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NovaCelula")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "NovaCelula")
        }
        
        var descricaoOpcao: String?
        if let opcao = opcoesParaIndexPath(indexPath: indexPath as NSIndexPath) as? String {
            descricaoOpcao = opcao
        } else if let opcao = opcoesParaIndexPath(indexPath: indexPath as NSIndexPath) as? Clientes {
            descricaoOpcao = opcao.nome
        }
        
        if let label = cell!.textLabel {
            label.font = UIFont(name: "Corbert-Regular", size: 14.0)
            label.textColor = UIColor.blue
            label.text = descricaoOpcao
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
            
            delegateOpcoes.seleciona(tipo: tipoOpcoes, cliente: opcao)
            
        }
        
        if let _navigationController = self.navigationController {
            _navigationController.popViewController(animated: true)
        }
    }
}
