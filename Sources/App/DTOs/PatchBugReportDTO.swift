//
//  PatchBugReportDTO.swift
//  SampleBugTrackerAPI
//
//  Created by Joshua Root on 10/25/24.
//

import Vapor
import Fluent

struct PatchBugReportDTO: Content {
    var reportType: Int?
}
