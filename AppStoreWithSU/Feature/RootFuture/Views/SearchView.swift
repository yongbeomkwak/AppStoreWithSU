import SwiftUI

struct SearchView: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
     
                    TextField("Search", text: $text)
                        .foregroundColor(.primary)
     
                    if !text.isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }
                    } else {
                        EmptyView()
                    }
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
            }
            .padding(.horizontal)
    }
}

#Preview {
    SearchView(text: .constant(""))
}
