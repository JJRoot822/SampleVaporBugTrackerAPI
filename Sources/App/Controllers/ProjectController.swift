
import Fluent
import Vapor

struct ProjectController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let projects = routes.grouped("api", "projects")

        projects.get(use: self.getAll)
        projects.post("create", use: self.create)
        projects.get(":projectId", use: self.getProject)
        projects.delete("delete", ":projectId", use: self.delete)
        projects.patch("update-status", ":projectId", use: self.updateProjectStatus)
        projects.put("update", ":projectId", use: self.update)
    }

    @Sendable
    func getAll(req: Request) async throws -> [ProjectDTO] {
        let projects = try await Project.query(on: req.db).with(\.$bugReports).all().map { $0.toDTO() }
        
        return projects
    }

    @Sendable
    func getProject(req: Request) async throws -> ProjectDTO {
        guard let project = try await Project.find(req.parameters.get("projectId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return project.toDTO()
    }
    
    @Sendable
    func create(req: Request) async throws -> HTTPStatus {
        let project = try req.content.decode(ProjectDTO.self).toModel()
        
        try await project.save(on: req.db)
        
        return .created
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let project = try await Project.find(req.parameters.get("projectId"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await project.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func updateProjectStatus(req: Request) async throws -> HTTPStatus {
        guard let project = try await Project.find(req.parameters.get("projectId"), on: req.db) else {
            print("Project not found with the id of \(req.parameters.get("projectId")!)")
            throw Abort(.notFound)
        }

        let patchData: PatchProjectDTO? = try? req.content.decode(PatchProjectDTO.self)

        if let isClosed = patchData?.isClosed {
            project.isClosed = isClosed
        }

        try await project.save(on: req.db)

        return .noContent
    }
    
    @Sendable
    func update(req: Request) async throws -> ProjectDTO {
        guard let project = try await Project.find(req.parameters.get("projectId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedProjectData = try req.content.decode(ProjectDTO.self)
        
        project.projectName = updatedProjectData.name ?? project.projectName
        project.isClosed = updatedProjectData.isClosed ?? project.isClosed
        
        try await project.save(on: req.db)

        return project.toDTO()
    }
}
