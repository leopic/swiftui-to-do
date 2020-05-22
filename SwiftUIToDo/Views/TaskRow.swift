import SwiftUI

struct TaskRow: View {
  @ObservedObject var task: Task
  @EnvironmentObject var store: TaskStore

  var body: some View {
    return HStack {
      Button(action: {
        self.store.toggle(self.task)
      }) {
        Image(systemName: task.isDone ?  "checkmark.circle.fill" : "circle")
          .animation(.easeInOut)
          .padding([.top, .bottom])
      }
      .accessibility(identifier: "Task Status")
      .accessibility(label: Text("\(task.isDone ? "Set as pending" : "Set as complete")"))
      .foregroundColor(.blue)

      TextField("Task Title", text: $task.title, onCommit: {
        self.store.edit(self.task)
      })
        .accentColor(.primary)
        .lineLimit(2)
        .animation(.easeInOut)

      Spacer()
    }
    .padding(0)
  }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        TaskRow(task:
          Task(title: "Buy the milk", isDone: false)
        )
        TaskRow(task:
          Task(title: "Bought the milk", isDone: true)
        )
      }
    }
}
