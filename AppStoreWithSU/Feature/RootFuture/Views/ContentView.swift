import SwiftUI
import SwiftData

struct ContentView: View {
    /*
     
     Model Context는 모델의 모든 변화를 관찰하면서 여러 작업을 동시에 처리할 수 있도록 돕습니다.
     또한 업데이트에 대한 추적, 데이터 패치, 변화 저장, 실행 취소 등을 수행할 수 있습니다.
     
     */
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort:\RecentModel.date) private var items: [RecentModel]


    @StateObject var viewModel: RootViewModel
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchView(text: $viewModel.searchText,actions: $viewModel.actions)
                
                if viewModel.isSearch == false {
                    List {
                        ForEach(viewModel.searchResult, id:\.self) { data in
                            RecentTextView(model: data, actions: $viewModel.actions)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    
                } else {
                    EmptyView()
                }
                

                
            }
            .navigationTitle("검색")
            .navigationBarItems(trailing:HStack{
                                        Button(action: {}) {
                                            HStack {
                                                Text("임시")
                                                    .foregroundColor(.black)
                                                Image(systemName: "folder.fill")
                                            }
                                        }
                                    }
                                )
        }
        .onAppear {
            print(items)
        }

    }


}

#Preview {
    ContentView(viewModel: RootViewModel(context: previewRecentModelContainer.mainContext))
        .modelContainer(previewRecentModelContainer)
        
}
