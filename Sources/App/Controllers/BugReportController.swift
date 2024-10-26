
import Fluent
import Vapor

struct BugReportController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bugs = routes.grouped("api", "bugs")

        bugs.get(use: self.getAll)
        bugs.post("create", use: self.create)
        bugs.get(":bugReportId", use: self.getBugReport)
        bugs.delete("delete", ":bugReportId", use: self.delete)
        bugs.patch("update-type", ":bugReportId", use: self.updateReportStatus)
        bugs.put("update", ":bugReportId", use: self.update)
    }

    @Sendable
    func getAll(req: Request) async throws -> [BugReportDTO] {
        return try await BugReport.query(on: req.db).with(\.$project).all().map { $0.toDTO() }
    }

    @Sendable
    func getBugReport(req: Request) async throws -> BugReportDTO {
        guard let bugReport = try await BugReport.find(req.parameters.get("bugReportId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return bugReport.toDTO()
    }
    
    @Sendable
    func create(req: Request) async throws -> BugReportDTO {
        let bugReportDTO = try req.content.decode(BugReportDTO.self)
        
        guard let project = try await Project.find(bugReportDTO.projectId, on: req.db) else {
            throw Abort(.badRequest)
        }
        let bugReport = BugReport()
        
        bugReport.reportType = bugReportDTO.reportType ?? 0
        bugReport.reportTitle = bugReportDTO.reportTitle ?? "Unknown"
        bugReport.reportDetails = bugReportDTO.reportDetails ?? ""
        bugReport.project = project
        
        try await bugReport.save(on: req.db)
        return bugReportDTO
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let bugReport = try await BugReport.find(req.parameters.get("bugReportId"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await bugReport.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func updateReportStatus(req: Request) async throws -> HTTPStatus {
        guard let bugReport = try await BugReport.find(req.parameters.get("bugReportId"), on: req.db) else {
            throw Abort(.notFound)
        }

        let patchData: PatchBugReportDTO? = try? req.content.decode(PatchBugReportDTO.self)
        
        if let reportType = patchData?.reportType {
            bugReport.reportType = reportType
        }

        try await bugReport.save(on: req.db)

        return .noContent
    }
    
    @Sendable
    func update(req: Request) async throws -> HTTPStatus {
        guard let bugReport = try await BugReport.find(req.parameters.get("bugReportId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedBugReportData = try req.content.decode(BugReportDTO.self)
        
        guard let project = try await Project.find(updatedBugReportData.projectId, on: req.db) else {
            throw Abort(.badRequest, reason: "The project ID provided was invalid.")
        }
        
        if let reportTitle = updatedBugReportData.reportTitle {
            bugReport.reportTitle = reportTitle
        }
        
        if let reportType = updatedBugReportData.reportType {
            bugReport.reportType = reportType
        }
        
        if let reportDetails = updatedBugReportData.reportDetails
        {
            bugReport.reportDetails = reportDetails
        }
        
        bugReport.project = project
        
        try await project.save(on: req.db)

        return .noContent
    }
}

