//
//  JsonTableViewController.swift
//  testeJson
//
//  Created by Abilio Azevedo on 12/7/17.
//  Copyright © 2017 Marcos Moreira. All rights reserved.
//

import UIKit

protocol JsonProcurarProtocolo {
    func selecionar(tipo: EnumTipoOpcoes, cliente: Clientes?)
}

class JsonTableViewController: UITableViewController {

    @IBOutlet var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var clientes: [Clientes] = [Clientes]()
    var delegateOpcoes: JsonProcurarProtocolo!
    
    let urlString: String = "http://careers.picpay.com/tests/mobdev/users"
    
    var itemList: [String] = [String]()
    var itemIDList = [Int]()
    
    var pesquisando:Bool = false
    var opcoesPesquisadas:[AnyObject] = [AnyObject]()
    var tipoOpcoes: EnumTipoOpcoes!
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tblView.reloadData()
        getJson()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        self.itemList.append(Clientes.clienteJson(dict: dict).nome)
                        //print("PRINT: \(Clientes.clienteJson(dict: dict).userName)")
                    }
                    self.tblView.reloadData()
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
    }
}

extension JsonTableViewController: UISearchBarDelegate {
    
    //Função criando botão de cancelar na barra de pesquisa.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        pesquisando = false
        tableView.reloadData()
    }
    
    //Função para verificar se o usuário está digitando no campo de pesquisa
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        pesquisando = true
        opcoesPesquisadas = itemList as [AnyObject]
        tableView.reloadData()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText == "" {
            pesquisando = false
        } else {
            pesquisando = true
            
            opcoesPesquisadas = itemList.filter({
                if let opcao = $0 as? Clientes {
                    if let searchId = Int(searchText) {
                        return opcao.id == searchId
                    }
                    
                    return opcao.nome.range(of: searchText, options: [NSString.CompareOptions.caseInsensitive, NSString.CompareOptions.diacriticInsensitive]) != nil
                    
                }
                return false
            }) as [AnyObject]
        }
        tableView.reloadData()
    }
}

extension JsonTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemList.count
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
        
        print("INDEXPATH: \(itemList[indexPath.row])")
        // cell?.textLabel?.text = itemList[indexPath.row]
        return cell!
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
    
    /** - Função para retornar a quantidade de registro. */
    func opcoesParaIndexPath(indexPath: NSIndexPath) -> AnyObject {
        if !pesquisando {
            return self.itemList[indexPath.row] as AnyObject
        }
        return self.opcoesPesquisadas[indexPath.row]
    }
}
