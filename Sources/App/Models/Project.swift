
import Fluent
import Foundation

final class Project: Model, @unchecked Sendable {
    static let schema = "Projects"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var projectName: String
    
    @Field(key: "maintained")
    var isBeingMaintained: Bool

    @Children(for: \..$project)
    var bugReports: [BugReport]
    
    init() {}
    
    init(id: UUID? = nil, projectName: String, isBeingMaintained: Bool) {
        self.id = id
        self.projectName = projectName
        self.isBeingMaintained = isBeingMaintained
    }
    
    func toDTO() -> ProjectDTO {
        return ProjectDTO(id: self.$id.value, name: self.$projectName.value, isClosed: self.$isBeingMaintained.value, bugs: self.$bugReports.value)
    }
}
