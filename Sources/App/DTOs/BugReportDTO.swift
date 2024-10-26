
import Fluent
import Vapor

struct BugReportDTO: Content {
    var id: UUID?
    var reportTitle: String?
    var reportDetails: String?
    var reportType: Int?
    var projectId: UUID?
}
