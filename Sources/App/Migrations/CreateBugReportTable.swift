
import Fluent

struct CreateBugReportTable: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("BugReports")
            .id()
            .field("title", .string, .required)
            .field("details", .string, .required)
            .field("report_type", .int, .required)
            .field("project_id", .uuid, .required, .references("Projects", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("BugReports").delete()
    }
}
