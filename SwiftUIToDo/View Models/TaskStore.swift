import Foundation
import Combine

final class TaskStore: ObservableObject {
  @Published var tasks = [Task]()

  private var subscriptions = Set<AnyCancellable>()

  init() {
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

  func remove(_ at: IndexSet) -> Void {
    tasks.remove(atOffsets: at)
  }

  func move(from source: IndexSet, to destination: Int) {
    tasks.move(fromOffsets: source, toOffset: destination)
  }

  private func load() {
    guard let data = UserDefaults.standard.value(forKey: "tasks") as? Data,
      let tasks = try? PropertyListDecoder().decode([Task].self, from: data) else { return }

    self.tasks = tasks
  }

  private func store(tasks: [Task]) {
    do {
      let codedArray = try PropertyListEncoder().encode(tasks)
      UserDefaults.standard.set(codedArray, forKey: "tasks")
    } catch {
      print("Error saving tasks", error)
    }
  }
}
