import Foundation

class Task: Codable {
  var id = UUID()
  var title: String
  var isDone: Bool

  required init(title: String, isDone: Bool = false) {
    self.title = title
    self.isDone = isDone
  }

  func toggle() {
    self.isDone.toggle()
  }
}

extension Task: Identifiable {}

extension Task: ObservableObject {}
