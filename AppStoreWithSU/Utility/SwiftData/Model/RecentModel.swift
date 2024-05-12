import Foundation
import SwiftData


/*
 *스키마(Schema): Database의 구조와 제약조건에 관해 전반적인 명세를 기술한 것. 
 즉 어떤 속성(Attribute)들로 이루어진 개체(Entity)들과,
 그 개체들끼리의 관계(Relation)에 대한 정의 및 제약조건들을 기술한 것 입니다.
 */

/*
 
 String, Int 및 Float와 같은 기본 값 유형이 포함됩니다.

 🌱 Complex value types

 Struct
 Enum
 Codable
 Collections of value types
 
 */

/* @Transient :

 Transient 매크로 또한 Model 객체 내부에서 사용됩니다. Transient로 지정한 값은 SwiftData에서 모델을 구성할 때 제외 됩니다.
 즉 SwiftData의 DB에 저장하기 위한 값이 아닌 UI나 비즈니스 로직에서 사용할 값을 임시로 저장하기 위해 사용되요
 
*/
 
@Model // Swift 코드에서 모델의 스키마를 정의하는 데 사용됩니다.
final class RecentModel {
    
    @Attribute(.unique) var name: String
    
    var date = Date()
    
    init(name: String) {
        self.name = name
    }
}

struct MockData {
    static let previewData: [RecentModel] = [
        
        RecentModel(name: "예1"),
        RecentModel(name: "예2"),
        RecentModel(name: "예4"),
        RecentModel(name: "예3")
        
    ]
}

@MainActor

let previewRecentModelContainer: ModelContainer  =  {
    do {
        let container = try ModelContainer(for:RecentModel.self)
        
        for data in MockData.previewData {
            container.mainContext.insert(data)
        }
        
        return container
        
    } catch {
        fatalError("fail to create container")
    }
}()
