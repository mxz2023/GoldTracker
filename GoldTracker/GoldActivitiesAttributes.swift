//
//  GoldActivitiesAttributes.swift
//  GoldTracker
//
//  Shared attributes for Live Activities.
//

import ActivityKit
import Foundation

struct GoldActivitiesAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var price: Double
        var change: Double
        var updatedAt: Date
        var symbol: String
    }

    var institution: String
}
