//
//  AddTaskViewController.swift
//  GoodList
//
//  Created by 김병엽 on 2023/01/20.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySgControl: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func save() {
        
        guard let priority = Priority(rawValue: prioritySgControl.selectedSegmentIndex),
              let title = taskTitleTextField.text else {
            return
        }
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        
        dismiss(animated: true)
    }
}
