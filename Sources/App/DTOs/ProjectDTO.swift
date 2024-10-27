
import Fluent
import Vapor

struct ProjectDTO: Content {
    var id: UUID?
    var name: String?
    var isClosed: Bool?
    var bugs: [BugReport]?
    
    func toModel() -> Project {
        print(name == nil)
        let project = Project()
        project.id = self.id
        
        if let projectName = self.name {
            project.projectName = projectName
        }
        
        if let isBeingMaintained = self.isClosed {
            project.isBeingMaintained = isBeingMaintained
        }
        
        return project
    }
}
