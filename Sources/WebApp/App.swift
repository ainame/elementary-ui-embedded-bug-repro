import ElementaryUI

@main
struct App {
  static func main() {}
}

@View
struct ListPage {
  var condition = true

  var body: some View {
    if condition {
      ListView()
    }
  }
}

@View
struct ListView {
  var items: [String]? = ["one", "two"]

  var body: some View {
    div {
      if let items {
        let _ = items
      }
    }
  }
}
