import SwiftUI
import SwiftData

@main
struct AppStoreWithSUApp: App {
    /*
     
    Model Container는 내 모델 타입들의 영구적인 백엔드 역할을 한다고 생각하면 됩니다.
     
     사용할 모델 타입의 리스트를 지정하는 것만으로 간단하게 Model Container 생성이 가능합니다.
     옵션 지정이 필요할 때는 Model Configuration 객체를 활용합니다.
     */
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RecentModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    


    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: RootViewModel(context: sharedModelContainer.mainContext))
        }
        .modelContainer(sharedModelContainer)
    }
}
