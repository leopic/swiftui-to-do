import Foundation
import Combine
import SwiftUI

final class TaskStore: ObservableObject {
  @Published var tasks = [Task]()

  private var subscriptions = Set<AnyCancellable>()
  private var userDefaults: UserDefaults
  private let key = "Tasks"

  init(userDefaults: UserDefaults = UserDefaults.standard) {
    self.userDefaults = userDefaults

    load()

    $tasks
      .handleEvents(receiveOutput: { self.store(tasks: $0) })
      .sink { _ in }
      .store(in: &subscriptions)
  }

  func add(_ task: Task) -> Void {
    tasks.append(task)
  }

  func toggle(_ task: Task) -> Void {
    guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
      return
    }

    task.toggle()
    tasks[index] = task
  }

  func edit(_ task: Task) -> Void {
    guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
      return
    }

    tasks[index] = task
  }

  func remove(at: IndexSet) -> Void {
    tasks.remove(atOffsets: at)
  }

  func remove(_ task: Task) -> Void {
    guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
      return
    }

    remove(at: IndexSet(arrayLiteral: index))
  }

  func move(from source: IndexSet, to destination: Int) -> Void {
    print("before source: \(source) to destination: \(destination), tasks:", tasks.map { $0.title })
    tasks.move(fromOffsets: source, toOffset: destination)
    print("after source: \(source) to destination: \(destination), tasks:", tasks.map { $0.title })
  }

  private func load() {
    guard let data = userDefaults.value(forKey: key) as? Data,
      let tasks = try? PropertyListDecoder().decode([Task].self, from: data) else { return }

    self.tasks = tasks
  }

  private func store(tasks: [Task]) {
    do {
      let codedArray = try PropertyListEncoder().encode(tasks)
      userDefaults.set(codedArray, forKey: key)
    } catch {
      print("Error saving tasks", error)
    }
  }
}
