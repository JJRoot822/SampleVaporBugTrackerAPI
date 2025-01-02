
import Fluent
import Vapor

struct BugReportDTO: Content {
    var id: UUID?
    var reportTitle: String?
    var reportDetails: String?
    var reportType: Int?
    var projectId: UUID?
    
    func toModel() -> BugReport {
        let bugReport = BugReport()
        bugReport.id = id
        
        if let title = reportTitle {
            bugReport.reportTitle = title
        }
        
        if let details = reportDetails {
            bugReport.reportDetails = details
        }
        
        if let type = reportType {
            bugReport.reportType = type
        }
        
        return bugReport
    }
}
