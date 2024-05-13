import Foundation
import SwiftUI
import Combine
import SwiftData

protocol RecentModelStorage {
    func read(using modelContext: ModelContext) -> [RecentModel]
    func insert(model: RecentModel, using modelContext: ModelContext)
    func delete(model: RecentModel, using modelContext: ModelContext)
    func deleteAll(using modelContext: ModelContext)
}




enum RootViewAction {
    case recommandedTextDidTap(String)
    case searchButtonDidTap(String)
    case changeSearchState(Bool)
    case deleteButtonDidTap(RecentModel)
}


final class RootViewModel: BaseViewModel {
   
    
    
    var context: ModelContext
    
    var data: [RecentModel] = []
    
    @Published var searchText: String = ""
    @Published var searchResult: [RecentModel] = []
    @Published var actions: [RootViewAction] = []
    @Published var isSearch: Bool = false
    
    
     init(context: ModelContext) {
         self.context = context
         super.init()
    }
    

    override func bind() {
        data = self.read(using: context)
        super.bind()
        
    }
    
    override func bindState()  {
        
        super.bindState()
        
            $searchText
            .withUnretained(self)
            .removeDuplicates(by: { $0.1 == $1.1})
            .map { owner,text -> [RecentModel] in
            
           
                guard !text.isEmpty else {
                    return owner.data
                }
                return owner.data.filter{$0.name.hasPrefix(text)}
            }
            .eraseToAnyPublisher()
            .assign(to: &$searchResult)
        
        
        
    }
    
    override func bindAction() {
        
        super.bindAction()
        
        $actions
            .withUnretained(self)
            .sink { owner, actions  in
                for action in actions {
                    switch action {
                        
                        case let .recommandedTextDidTap(text), let .searchButtonDidTap(text):
                            owner.updateText(text)
                            

                        case let .changeSearchState(flag):
                            owner.isSearch = flag
                        
                            guard flag && !owner.searchText.isEmpty else { // 비어있거나 검색전으로 바뀌는거면 무시
                                return
                            }
                            
                            
                            if let index = owner.data.firstIndex(where: {$0.name == owner.searchText}) {
                                    // 중복값있을 때
                            
                                owner.delete(model: owner.data[index], using: owner.context)
                                
                            }
                            
                            owner.insert(model: RecentModel(name: owner.searchText), using: owner.context)
                            owner.data = owner.read(using: owner.context)
                    case let .deleteButtonDidTap(model):
                        owner.delete(model: model, using: owner.context)
                        owner.data = owner.read(using: owner.context)
                        owner.searchResult = owner.data
                    }

                }

            }
            .store(in: &subscription)
        
    }
}

extension RootViewModel {
    func updateText(_ text: String) {
        self.searchText = text
    }
}

extension RootViewModel : RecentModelStorage {
    
    func read(using modelContext: ModelContext) -> [RecentModel] {
        
        let descriptor = FetchDescriptor<RecentModel>(
            sortBy: [SortDescriptor<RecentModel>(\.date,order: .reverse)]
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError("Could not read: \(error)")
        }
    }
    
    func insert(model: RecentModel, using modelContext: ModelContext) {
        modelContext.insert(model)
    }
    
    func delete(model: RecentModel, using modelContext: ModelContext) {
        modelContext.delete(model)
    }
    
    func deleteAll(using modelContext: ModelContext) {
        modelContext.container.deleteAllData()
    }
    
    

}


