//
//  ChatViewController.swift
//  Chat
//
//  Created by Karlo Fabijanić on 29.11.2021..
//

import UIKit
import Firebase


class ChatViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(Constants.FireStore.collectionName).order(by: Constants.FireStore.dateField).addSnapshotListener{ querySnapshot, error in
            self.messages = []
            
            if let e = error {
                print("There was issue retieving data from Firestore: \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let sender = data[Constants.FireStore.senderField] as? String, let body = data[Constants.FireStore.bodyField] as? String {
                            let message = Message(sender: sender, body: body)
                            self.messages.append(message)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constants.FireStore.collectionName).addDocument(data: [
                Constants.FireStore.senderField: messageSender,
                Constants.FireStore.bodyField: messageBody,
                Constants.FireStore.dateField: Date().timeIntervalSince1970
            ]){ error in
                if let e = error {
                    print ("There was an issue saving data for Firestore, \(e)")
                } else {
                    print("Success")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
}


extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].body

        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageLabel.backgroundColor = .cyan
            cell.messageLabel.textColor = .white
            
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageLabel.backgroundColor = .white
            cell.messageLabel.textColor = .cyan
        }

        return cell
    }
    
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
