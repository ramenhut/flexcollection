
import SwiftUI

struct ChipButton: View {
    var name : String
    var editable: Bool = true
    var action: (() -> Void)?
    var body: some View {
        HStack (spacing: 0.0) {
            if (editable) {
                Image(systemName: "xmark.circle")
                    .padding(.leading, 5.0)
            }
            Text(name)
                .font(.footnote)
                .padding(6.0)
                .padding(.trailing, 4.0)
                .padding(.leading, editable ? 0 : 4.0)
        }
        .foregroundColor(.white)
        .background(Color.black)
        .cornerRadius(20.0)
        .onTapGesture {
            if (editable && action != nil) {
                action!()
            }
        }
    }
}
