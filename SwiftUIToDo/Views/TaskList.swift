import SwiftUI

struct TaskList: View {
  @EnvironmentObject var store: TaskStore
  @State var isAddingNewTask = false
  @State private var tasksFilter = TaskFiter.all.rawValue

  private var tasks: [Task] {
    switch TaskFiter(rawValue: tasksFilter) {
    case .some(.pending):
      return self.store.tasks.filter { !$0.isDone }
    case .some(.done):
      return self.store.tasks.filter { $0.isDone }
    default:
      return self.store.tasks
    }
  }

  var body: some View {
    let footer = Text("Total: \(tasks.count)").foregroundColor(.secondary)

    return NavigationView {
      List {
        Section {
          Picker(selection: $tasksFilter, label: Text("Filter tasks by")) {
            ForEach(TaskFiter.allCases) { Text($0.name) }
          }
          .pickerStyle(SegmentedPickerStyle())
        }

        Section {
          Button(action: {
            self.isAddingNewTask = true
          }) {
            Text("Add New").foregroundColor(.accentColor)
          }.sheet(isPresented: $isAddingNewTask) {
            AddTask(isAddingNewTask: self.$isAddingNewTask)
              .environmentObject(self.store)
          }
        }

        Section(footer: footer) {
          ForEach(tasks) { TaskRow(task: $0) }
          .onDelete { self.store.remove($0) }
          .onMove { self.store.move(from: $0, to: $1) }
        }
      }
      .navigationBarTitle("Tasks")
      .navigationBarItems(trailing: EditButton())
      .listStyle(GroupedListStyle())
      .buttonStyle(BorderlessButtonStyle())
    }
  }
}

struct TaskList_Previews: PreviewProvider {
  static var previews: some View {
    TaskList(isAddingNewTask: false)
      .environmentObject(TaskStore())
  }
}
