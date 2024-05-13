import SwiftUI

struct RecentTextView: View {

    var model: RecentModel
    @Binding var actions: [RootViewAction]
    
    var body: some View {
        HStack {
            Text(model.name)
                .onTapGesture {
                    actions = [.recommandedTextDidTap(model.name),
                               .changeSearchState(true)
                    ]
                }
            Spacer()
            Button(action: {
               
                actions = [.deleteButtonDidTap(model)]
                
            }, label: {
                Image(systemName: "xmark")
            })
        }
        .padding(EdgeInsets(top: .zero, leading: 20, bottom: .zero, trailing: 20))

       
    }
}

#Preview {
    RecentTextView(model: RecentModel(name: "Hello"), actions: .constant([]))
}
