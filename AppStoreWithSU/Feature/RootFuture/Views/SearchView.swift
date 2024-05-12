import SwiftUI

struct SearchView: View {
    
    @Binding var text: String
    @Binding var actions: [RootViewAction]
    
    
    var body: some View {
        HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
     
                    TextField("Search", text: $text)
                        .foregroundColor(.primary)
                        .onSubmit{
                            actions = [.searchButtonDidTap(text),.changeSearchState(true)]
                        }
                    
     
                    if !text.isEmpty {
                        Button(action: {
                            actions = [.recommandedTextDidTap(""),
                                                 .changeSearchState(false)]
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
