import Foundation

enum TaskFiter: Int, CaseIterable, Identifiable {
  case all = 0
  case pending = 1
  case done = 2

  var id: Int {
    rawValue
  }

  var name: String {
    switch self {
    case .pending:
      return "Pending"
    case .all:
      return "All"
    case .done:
      return "Completed"
    }
  }
}
