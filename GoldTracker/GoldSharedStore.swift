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
    private static let lastWriteKey = "gold_quotes_last_write"
    private static let countKey = "gold_quotes_count"

    static func loadQuotes() -> [GoldQuote] {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return [] }
        guard let data = defaults.data(forKey: quotesKey) else { return [] }
        return (try? JSONDecoder().decode([GoldQuote].self, from: data)) ?? []
    }

    static func saveQuotes(_ quotes: [GoldQuote]) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        let data = (try? JSONEncoder().encode(quotes)) ?? Data()
        defaults.set(data, forKey: quotesKey)
        defaults.set(Date(), forKey: lastWriteKey)
        defaults.set(quotes.count, forKey: countKey)
    }

    static func lastWriteDate() -> Date? {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return nil }
        return defaults.object(forKey: lastWriteKey) as? Date
    }

    static func lastWriteCount() -> Int {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return 0 }
        return defaults.integer(forKey: countKey)
    }
}
