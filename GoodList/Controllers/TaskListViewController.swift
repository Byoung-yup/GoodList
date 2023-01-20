//
//  TaskListViewController.swift
//  GoodList
//
//  Created by 김병엽 on 2023/01/20.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var prioritySgControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let addTaskVC = navC.viewControllers.first as? AddTaskViewController else {
                  return
              }
        
        addTaskVC.taskSubjectObservable
            .subscribe { [unowned self] task in
                
                let priority = Priority(rawValue: self.prioritySgControl.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                
                self.tasks.accept(existingTasks)
                
                self.filterTasks(by: priority)
                
            }.disposed(by: disposeBag)
    }
    
    @IBAction func priorityValueChanged(sgControl: UISegmentedControl) {
        
        let priority = Priority(rawValue: sgControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
        
    }
    
    private func updateTalbieView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?) {
        
        if priority == nil {
            filteredTasks = tasks.value
        }
        else {
            tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe { [weak self] tasks in
                self?.filteredTasks = tasks
            }.disposed(by: disposeBag)
        }
        updateTalbieView()
    }
    
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = filteredTasks[indexPath.row].title
        
        return cell
    }
}
