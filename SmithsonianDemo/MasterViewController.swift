//
//  MasterViewController.swift
//  SmithonianDemo
//
//  Created by Jack Dempsey on 5/3/20.
//  Copyright © 2020 JackDempsey. All rights reserved.
//

import UIKit

var picHelper = pictureHelper.init()
let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

class MasterViewController: UIViewController {

    var objects = [Any]()
    
    @IBOutlet weak var searchBox: UITextField!

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        // in viewDidLoad (if using Autolayout check note below):
        // paintingCollection.contentSize = CGSize(width: 300, height: 500)
        tableView.delegate = self
        tableView.dataSource = self
        }

    override func viewWillAppear(_ animated: Bool) {
        // clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchBox.resignFirstResponder()
        let query = searchBox.text!
        print("text: " )
        picHelper.getPictureList(from: query){ (query) in
            if let listOfPics = query {
                DispatchQueue.main.async {
                    print("Get Here")
                    picHelper.updateImages(pictures: listOfPics, tableView: self.tableView)
                }
            }
        self.loading()
    }
}
    
    
    // MARK: - Segues

    func loading() {
        // call loading animations here
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // here is where we load the AR view
        print("You Tapped Row: ", indexPath.row)
        picHelper.tappedRow = indexPath.row
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextView") as! ARViewViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
}
class picProtoCell: UITableViewCell {
    @IBOutlet weak var picImage: UIImageView!
    @IBOutlet weak var piDescription: UILabel!
}

extension MasterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picHelper.paintings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

       // Use the default size for all other rows.
       return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pictureTableCell", for: indexPath) as! picProtoCell
        
        let picInfo = picHelper.paintings[indexPath.row]
        
        cell.picImage.image = picInfo.image
        // print("OK")
        cell.piDescription.text = picInfo.name
        
        return cell
    }
 
}


