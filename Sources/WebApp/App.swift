import ElementaryUI

@main
struct App {
  static func main() {
    let app = Application(RootView())
    app.mount(in: "#app")
  }
}

@View
struct RootView {
  var body: some View {
    div {
      Routes.RouteView(storage: .list)
    }
  }
}

@View
struct ListPage {
  var condition: Bool? = true

  var body: some View {
    if condition != nil {
      ListView()
    } else {
      p {
        "aaaa"
      }
    }
  }
}

@View
struct ListView {
  var items: [String]? = ["one", "two"]

  var body: some View {
    div {
      if let items {
        ForEach(items, key: { $0 }) { item in
          p {
            item
          }
        }
      }
    }
  }
}
