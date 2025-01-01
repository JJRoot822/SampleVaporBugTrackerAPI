
import Fluent
import Foundation

final class Project: Model, @unchecked Sendable {
    static let schema = "Projects"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var projectName: String
    
    @Field(key: "closed")
    var isClosed: Bool

    @Children(for: \..$project)
    var bugReports: [BugReport]
    
    init() {}
    
    init(id: UUID? = nil, projectName: String, isClosed: Bool) {
        self.id = id
        self.projectName = projectName
        self.isClosed = isClosed
    }
    
    func toDTO() -> ProjectDTO {
        let bugReports: [BugReportDTO]? = self.$bugReports.value?.map { report in
            return report.toDTO()
        }
        
        return ProjectDTO(id: self.$id.value, name: self.$projectName.value, isClosed: self.$isClosed.value, bugs: bugReports)
    }
}
