//
//  TodoDetailViewController.swift
//  TodoList_App
//
//  Created by Muker on 2021/11/08.
//

import UIKit
import CoreData

protocol TodoDetailViewControllerDelegate: AnyObject {
    func didFinishSaveData()
}



class TodoDetailViewController: UIViewController {

    weak var delegate: TodoDetailViewControllerDelegate?
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedTodoList: TodoList?
    
    var priority: PriorityLevel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let hasData = selectedTodoList {
            titleTextField.text = hasData.title
            
            priority = PriorityLevel(rawValue: hasData.priorityLevel)
            makePriorityButtonDesign()
            deleteButton.isHidden = false
        }else {
            deleteButton.isHidden = true
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lowButton.layer.cornerRadius = lowButton.bounds.height / 2
        normalButton.layer.cornerRadius = normalButton.bounds.height / 2
        highButton.layer.cornerRadius = highButton.bounds.height / 2
        priorityView.layer.cornerRadius = priorityView.bounds.height / 10
        titleView.layer.cornerRadius = titleView.bounds.height / 10
        titleTextField.layer.cornerRadius = titleTextField.bounds.height / 8
        saveButton.layer.cornerRadius = saveButton.bounds.height / 7
        deleteButton.layer.cornerRadius = deleteButton.bounds.height / 7
    }
    
    
    @IBAction func setPriority(_ sender: UIButton) {
        switch sender.tag {
        
        case 1:
            priority = .level1
        case 2:
            priority = .level2
        case 3:
            priority = .level3
        default:
            break
        }
        
        makePriorityButtonDesign()
        
        
    }
  
    func makePriorityButtonDesign() {
        lowButton.backgroundColor = .clear
        normalButton.backgroundColor = .clear
        highButton.backgroundColor = .clear
        
        switch self.priority {
        
        case .level1:
            lowButton.backgroundColor = priority?.color
        case .level2:
            normalButton.backgroundColor = priority?.color
        case .level3:
            highButton.backgroundColor = priority?.color
        default:
            break
        }
        
        
    }
    
    @IBAction func saveTodo(_ sender: Any) {
        if selectedTodoList != nil {
            updateTodo()
        } else {
            saveTodo()
        }
        
        delegate?.didFinishSaveData()
        self.dismiss(animated: true, completion: nil)

    }
    
    
    func saveTodo() {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoList", in: context) else { return }
        
        guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? TodoList else { return }
        
        object.title = titleTextField.text
        object.date = Date()
        object.uuid = UUID()
        
        object.priorityLevel = priority?.rawValue ?? PriorityLevel.level1.rawValue
        
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        appDelegate.saveContext()
    }
    
    
    
    func updateTodo() {
        guard let hasData = selectedTodoList else {
            return
        }
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        guard let hasUUID = hasData.uuid else {
            return
        }
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
        
        do {
            let loadedData = try context.fetch(fetchRequest)

            loadedData.first?.title = titleTextField.text
            loadedData.first?.date = Date()
            loadedData.first?.priorityLevel = self.priority?.rawValue ?? PriorityLevel.level1.rawValue
            
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                
                appDelegate.saveContext()
                
               
            
        } catch {
            printContent(error)
        }
    }
    
    @IBAction func deleteTodo(_ sender: UIButton) {
        guard let hasData = selectedTodoList else {
            return
        }
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        guard let hasUUID = hasData.uuid else {
            return
        }
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
        
        do {
            let loadedData = try context.fetch(fetchRequest)
            
            if let loadFirstData = loadedData.first {
                context.delete(loadFirstData)
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    
                    appDelegate.saveContext()
                    
            }
            
        } catch {
            print(error)
        }
        delegate?.didFinishSaveData()
        self.dismiss(animated: true, completion: nil)
    }
    
}

