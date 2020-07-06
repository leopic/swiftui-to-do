import XCTest
import Combine

@testable import To_Do

class TaskStoreTests: XCTestCase {
  private var subscriptions = Set<AnyCancellable>()
  private var userDefaults: UserDefaults!
  private var store: TaskStore!
  private let newTask = Task(title: "new task")

  override func setUp() {
    userDefaults = UserDefaults(suiteName: #file)!
    userDefaults.removePersistentDomain(forName: #file)
    store = TaskStore(userDefaults: userDefaults)
  }

  func testAdd() {
    var tasks = [Task]()

    store.$tasks
      .dropFirst() // the first value emitted is always empty
      .prefix(1)
      .sink { tasks = $0 }
      .store(in: &subscriptions)

    XCTAssertEqual(0, tasks.count)

    store.add(newTask)

    XCTAssertEqual(1, tasks.count, ".add correctly increments the total task count")
    XCTAssertEqual(newTask.title, tasks.first?.title, ".add adds the correct task")
  }

  func testToggle() {
    var task: Task!

    store.$tasks
      .dropFirst()
      .prefix(2)
      .sink { task = $0.first }
      .store(in: &subscriptions)

    store.add(newTask)

    XCTAssertFalse(task.isDone)

    store.toggle(task)

    XCTAssertTrue(task.isDone)
  }

  func testEdit() {
    var task: Task!

    store.$tasks
      .dropFirst()
      .prefix(2)
      .sink { task = $0.first }
      .store(in: &subscriptions)

    store.add(newTask)

    XCTAssertEqual("new task", task.title)

    task.title = "new name"
    store.edit(task)

    XCTAssertEqual("new name", task.title)
  }

  func testRemove() {
    var tasks = [Task]()

    store.$tasks
      .dropFirst()
      .prefix(2)
      .sink { tasks = $0 }
      .store(in: &subscriptions)

    store.add(newTask)

    XCTAssertEqual(1, tasks.count)

    store.remove(newTask)

    XCTAssertEqual(0, tasks.count)
  }

  func testMove() {
    var tasks = [Task]()

    store.$tasks
      .dropFirst()
      .prefix(4)
      .sink {
        print("testMove", $0.map { $0.title })
        tasks = $0
      }
      .store(in: &subscriptions)

    let task1 = Task(title: "task 1")
    store.add(task1)

    let task2 = Task(title: "task 2")
    store.add(task2)

    let task3 = Task(title: "task 3")
    store.add(task3)

    XCTAssertEqual(tasks.first?.title, task1.title)

    store.move(from: IndexSet(arrayLiteral: 2), to: 0)

    XCTAssertEqual(tasks.first?.title, task3.title)
  }
}
