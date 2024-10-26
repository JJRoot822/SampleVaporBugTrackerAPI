
import Fluent
import Foundation

final class BugReport: Model, @unchecked Sendable {
    static let schema: String = "BugReports"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var reportTitle: String
JJRoot822
    @Field(key: "details")
    var reportDetails: String
    
    @Field(key: "report_type")
    var reportType: Int
    
    @Parent(key: "project_id")
    var project: Project
    
    init() {}
    
    init(id: UUID? = nil, reportTitle: String, reportDetails: String, reportType: Int, projectId: Project.IDValue) {
        self.id = id
        self.reportTitle = reportTitle
        self.reportDetails = reportDetails
        self.reportType = reportType
        self.$project.id = projectId
    }
    
    func toDTO() -> BugReportDTO {
        return BugReportDTO(id: $id.value, reportTitle: $reportTitle.value, reportDetails: $reportDetails.value, reportType: $reportType.value, projectId: $project.id)
    }
}
