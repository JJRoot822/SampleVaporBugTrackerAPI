import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: ProjectController())
    try app.register(collection: BugReportController())
}
