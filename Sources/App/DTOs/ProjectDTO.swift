
import Fluent
import Vapor

struct ProjectDTO: Content {
    var id: UUID?
    var name: String?
    var isClosed: Bool?
    var bugs: [BugReportDTO]?
    
    func toModel() -> Project {
        let project = Project()
        project.id = self.id
        
        if let projectName = self.name {
            project.projectName = projectName
        }
        
        if let isClosed = self.isClosed {
            project.isClosed = isClosed
        }
        
        return project
    }
}
