
import Fluent

struct CreateProjectTable: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("Projects")
            .id()
            .field("name", .string, .required)
            .field("closed",.bool, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("Projects").delete()
    }
}
