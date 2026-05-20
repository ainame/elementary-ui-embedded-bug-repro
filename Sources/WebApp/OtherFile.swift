import ElementaryUI

@View
struct THIS_IS_NOT_EVEN_USED {
  let condition = true

  var body: some View {
    if condition {
      ListPage()
    }
  }
}
