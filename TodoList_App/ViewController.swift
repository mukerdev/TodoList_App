//
//  ViewController.swift
//  TodoList_App
//
//  Created by Muker on 2021/11/07.
//

import UIKit
import CoreData

enum PriorityLevel: Int64 {
    case level1
    case level2
    case level3
}

extension PriorityLevel {
    var color: UIColor {
        switch self {
        case .level1:
            return .systemGreen
        case .level2:
            return .systemPurple
        case .level3:
            return .systemRed
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!
    
    let appddelegate = UIApplication.shared.delegate as! AppDelegate//타입 캐스팅
    
    var todoList = [TodoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To Do List"
        self.makeNavigationBar()
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        fetchData()
        todoTableView.reloadData()
        
    }
    
    func fetchData() {
        let fetchReqeust: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        let context = appddelegate.persistentContainer.viewContext
        
        do {
            self.todoList = try context.fetch(fetchReqeust)
        } catch {
            print(error)
        }
    }
    
    
    func makeNavigationBar() {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
         item.tintColor = .white
        navigationItem.rightBarButtonItem = item
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .orange.withAlphaComponent(0.9)
        
        self.navigationController?.navigationBar.standardAppearance = barAppearance
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }
    
    @objc func addNewTodo() {
        let detailVC = TodoDetailViewController.init(nibName: "TodoDetailViewController", bundle: nil)
        detailVC.delegate = self
        self.present(detailVC, animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        
        cell.topTitleLabel.text = todoList[indexPath.row].title
        
        if let hasDate = todoList[indexPath.row].date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd hh:mm:ss"
            let dateString = formatter.string(from: hasDate)
            
            cell.dateLabel.text = dateString
        } else {
            cell.dateLabel.text = ""
        }
        
        
        let priority = todoList[indexPath.row].priorityLevel
        
        let priorityColor =  PriorityLevel(rawValue: priority)?.color
        
        cell.priorityView.backgroundColor = priorityColor
        cell.priorityView.layer.cornerRadius = cell.priorityView.bounds.height / 2
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = TodoDetailViewController.init(nibName: "TodoDetailViewController", bundle: nil)
        detailVC.delegate = self
        detailVC.selectedTodoList = todoList[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
    }
    
}

extension ViewController: TodoDetailViewControllerDelegate {
    func didFinishSaveData() {
        self.fetchData()
        self.todoTableView.reloadData()
    }
    
    
}
