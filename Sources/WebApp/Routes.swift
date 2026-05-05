import ElementaryUI

struct Routes {
  @View
  struct RouteView {
    enum Storage: Equatable {
      case list
      case notFound
    }

    let storage: Storage

    var body: some View {
      switch storage {
      case .list:
        ListPage()
      case .notFound:
        p {
          "Not Found"
        }
      }
    }
  }
}
