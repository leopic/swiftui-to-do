import Combine

let pub1 = [1, 2, 3].publisher

var subscriptions = Set<AnyCancellable>()

pub1
  .flatMap { [$0, $0*2, $0*3].publisher }
  .sink { print("flatMap: \($0)") }
  .store(in: &subscriptions)

pub1
  .map { [$0, $0*2, $0*3] }
  .sink { print("flatMap: \($0)") }
  .store(in: &subscriptions)
