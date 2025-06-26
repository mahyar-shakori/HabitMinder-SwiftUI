/*
 // FIXME: My Taks!
*/


// MARK: - Tasks
// Swift testing, UITest, IntegrationTest
// CustomView

// DataLayer, DIContainer
// Watch, Test
// CustomView, Watch
// Features
// khate dropdowntable view


// MARK: - Questions
// Should I conform to ObservableObject in my class directly, or is it enough to declare it in the protocol?
// Should I write protocol for viewModels?
// HabitMinderApp


//struct CustomButton: View {
//    let title: String
//    let action: () -> Void
//    let font: Font
//    let foregroundColor: Color
//    let backgroundColor: Color?
//    let padding: EdgeInsets
//    let shape: AnyShape
//
//    init(
//        title: String,
//        font: Font = .body,
//        foregroundColor: Color = .white,
//        backgroundColor: Color? = nil,
//        padding: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
//        shape: some Shape = Capsule(),
//        action: @escaping () -> Void
//    ) {
//        self.title = title
//        self.font = font
//        self.foregroundColor = foregroundColor
//        self.backgroundColor = backgroundColor
//        self.padding = padding
//        self.shape = AnyShape(shape)
//        self.action = action
//    }
//
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .font(font)
//                .foregroundColor(foregroundColor)
//                .padding(padding)
//                .background {
//                    if let bgColor = backgroundColor {
//                        shape.fill(bgColor)
//                    }
//                }
//        }
//    }
//}
