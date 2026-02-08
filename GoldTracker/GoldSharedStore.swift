//
//  GoldSharedStore.swift
//  GoldTracker
//
//  Shared storage for iOS <-> watchOS via App Groups.
//

import Foundation

struct GoldQuote: Codable, Hashable {
    let name: String
    let symbol: String
    let price: Double
    let change: Double
    let updatedAt: Date
}

enum GoldSharedStore {
    private static let suiteName = "group.com.jdjr.GoldTracker"
    private static let quotesKey = "gold_quotes"

    static func loadQuotes() -> [GoldQuote] {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return [] }
        guard let data = defaults.data(forKey: quotesKey) else { return [] }
        return (try? JSONDecoder().decode([GoldQuote].self, from: data)) ?? []
    }

    static func saveQuotes(_ quotes: [GoldQuote]) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        let data = (try? JSONEncoder().encode(quotes)) ?? Data()
        defaults.set(data, forKey: quotesKey)
    }
}
