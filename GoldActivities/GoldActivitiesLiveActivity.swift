//
//  GoldActivitiesLiveActivity.swift
//  GoldActivities
//
//  Created by zhongyafeng on 2026/2/7.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GoldActivitiesLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GoldActivitiesAttributes.self) { context in
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.08, green: 0.09, blue: 0.12), Color(red: 0.20, green: 0.16, blue: 0.10)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    .padding(2)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.97, green: 0.79, blue: 0.25).opacity(0.18))
                                    .frame(width: 38, height: 38)
                                Text(context.state.symbol)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(red: 0.97, green: 0.79, blue: 0.25))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(context.attributes.institution)
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.white)
                                Text("Live Activity · CNY/g")
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                        }

                        Spacer()

                        statusPill(isUp: context.state.change >= 0)
                    }

                    HStack(alignment: .firstTextBaseline) {
                        Text(priceText(context.state.price))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text(changeText(context.state.change))
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(context.state.change >= 0 ? Color(red: 0.52, green: 0.88, blue: 0.46) : Color(red: 0.96, green: 0.48, blue: 0.48))
                            .padding(.leading, 6)
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.6))
                        Text(context.state.updatedAt, style: .time)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                .padding(18)
            }
            .activityBackgroundTint(.clear)
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.97, green: 0.79, blue: 0.25).opacity(0.2))
                            .frame(width: 44, height: 44)
                        Text(context.state.symbol)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(red: 0.97, green: 0.79, blue: 0.25))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(priceText(context.state.price))
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        Text(changeText(context.state.change))
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(context.state.change >= 0 ? Color(red: 0.52, green: 0.88, blue: 0.46) : Color(red: 0.96, green: 0.48, blue: 0.48))
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(context.attributes.institution)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                        Text(context.state.updatedAt, style: .time)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    trendBars(isUp: context.state.change >= 0)
                }
            } compactLeading: {
                Text(context.state.symbol)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.97, green: 0.79, blue: 0.25))
            } compactTrailing: {
                Text(priceCompactText(context.state.price))
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            } minimal: {
                Text(context.state.symbol)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .keylineTint(Color(red: 0.97, green: 0.79, blue: 0.25))
        }
    }

    private func statusPill(isUp: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: isUp ? "arrow.up.right" : "arrow.down.right")
                .font(.system(size: 11, weight: .semibold))
            Text(isUp ? "Rising" : "Falling")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(isUp ? Color(red: 0.52, green: 0.88, blue: 0.46) : Color(red: 0.96, green: 0.48, blue: 0.48))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.08))
        )
    }

    private func trendBars(isUp: Bool) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<12, id: \.self) { index in
                Capsule()
                    .fill(isUp ? Color(red: 0.52, green: 0.88, blue: 0.46) : Color(red: 0.96, green: 0.48, blue: 0.48))
                    .frame(width: 4, height: CGFloat(8 + (index % 5) * 6))
                    .opacity(0.25 + Double(index) * 0.05)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func priceText(_ value: Double) -> String {
        "¥\(String(format: "%.2f", value))"
    }

    private func priceCompactText(_ value: Double) -> String {
        "¥\(String(format: "%.0f", value))"
    }

    private func changeText(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", value))"
    }
}

extension GoldActivitiesAttributes {
    fileprivate static var preview: GoldActivitiesAttributes {
        GoldActivitiesAttributes(institution: "Shanghai Gold Exchange")
    }
}

extension GoldActivitiesAttributes.ContentState {
    fileprivate static var rising: GoldActivitiesAttributes.ContentState {
        GoldActivitiesAttributes.ContentState(price: 568.45, change: 1.32, updatedAt: Date(), symbol: "Au")
    }

    fileprivate static var falling: GoldActivitiesAttributes.ContentState {
        GoldActivitiesAttributes.ContentState(price: 563.80, change: -1.12, updatedAt: Date(), symbol: "Au")
    }
}

#Preview("Notification", as: .content, using: GoldActivitiesAttributes.preview) {
    GoldActivitiesLiveActivity()
} contentStates: {
    GoldActivitiesAttributes.ContentState.rising
    GoldActivitiesAttributes.ContentState.falling
}
