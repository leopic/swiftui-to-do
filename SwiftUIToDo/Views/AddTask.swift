import SwiftUI

struct AddTask: View {
  @State var newTaskTitle = ""
  @Binding var isAddingNewTask: Bool
  @EnvironmentObject var store: TaskStore

  var body: some View {
    VStack {
      TextField("Name", text: $newTaskTitle, onCommit: {
        self.store.add(Task(title: self.$newTaskTitle.wrappedValue))
        self.isAddingNewTask = false
        self.newTaskTitle = ""
      })
        .padding([.top, .trailing, .leading])
        .accentColor(.primary)

      Divider()
        .padding([.leading, .trailing])
        .padding(.bottom, 8)

      HStack {
        Button(action: {
          self.isAddingNewTask = false
        })  {
          Text("Cancel")
            .foregroundColor(.gray)
        }

        Button(action: {
          self.store.add(Task(title: self.$newTaskTitle.wrappedValue))
          self.isAddingNewTask = false
          self.newTaskTitle = ""
        }) {
          Text("Save")
            .fontWeight(.semibold)
        }
        .padding()
        .disabled(newTaskTitle.isEmpty)
      }

      Spacer()
    }
    .navigationBarTitle("New task", displayMode: .inline)
  }
}

struct AddTask_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        AddTask(isAddingNewTask: Binding.constant(true))
      }
    }
  }
}
