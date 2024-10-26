
import Fluent
import Vapor

struct ProjectDTO: Content {
    var id: UUID?
    var name: String?
    var isClosed: Bool?
    var bugs: [BugReport]?
    
    func toModel() -> Project {
        let project = Project()
        project.id = self.id
        project.bugReports = self.bugs ?? []
        if let name = self.name {
            project.projectName = name
        }
        
        return project
    }
}
