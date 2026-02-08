//
//  GoldLiveActivityManager.swift
//  GoldTracker
//
//  Live Activity lifecycle helper for GoldTracker.
//

import ActivityKit
import Combine
import Foundation

@available(iOS 16.1, *)
@MainActor
final class GoldLiveActivityManager: ObservableObject {
    @Published private(set) var isActive = false

    private var activity: Activity<GoldActivitiesAttributes>?

    func startIfNeeded(with item: GoldPriceItem) async {
        guard activity == nil else { return }
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let attributes = GoldActivitiesAttributes(institution: item.name)
        let state = GoldActivitiesAttributes.ContentState(
            price: item.price,
            change: item.change,
            updatedAt: Date(),
            symbol: item.shortName
        )

        do {
            let content = ActivityContent(state: state, staleDate: nil)
            activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
            isActive = true
        } catch {
            isActive = false
        }
    }

    func update(with item: GoldPriceItem) async {
        guard let activity else { return }

        let state = GoldActivitiesAttributes.ContentState(
            price: item.price,
            change: item.change,
            updatedAt: Date(),
            symbol: item.shortName
        )
        let content = ActivityContent(state: state, staleDate: nil)
        await activity.update(content)
    }

    func end() async {
        guard let activity else { return }
        let content = ActivityContent(
            state: GoldActivitiesAttributes.ContentState(
                price: 0,
                change: 0,
                updatedAt: Date(),
                symbol: ""
            ),
            staleDate: nil
        )
        await activity.end(content, dismissalPolicy: .immediate)
        self.activity = nil
        isActive = false
    }
}
