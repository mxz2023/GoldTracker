//
//  GoldActivities.swift
//  GoldActivities
//
//  Created by zhongyafeng on 2026/2/7.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: ConfigurationAppIntent(),
            institution: "上海黄金交易所",
            symbol: "Au",
            price: 568.40,
            change: 1.25
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: configuration,
            institution: "上海黄金交易所",
            symbol: "Au",
            price: 568.40,
            change: 1.25
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let basePrice = 566.0 + Double(hourOffset) * 0.4
            let delta = Double.random(in: -1.6...1.8)
            let price = basePrice + delta
            let entry = SimpleEntry(
                date: entryDate,
                configuration: configuration,
                institution: "上海黄金交易所",
                symbol: "Au",
                price: price,
                change: delta
            )
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let institution: String
    let symbol: String
    let price: Double
    let change: Double
}

struct GoldActivitiesEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var family
    private var backgroundColor: Color {
        Color.black
    }

    var body: some View {
        VStack(alignment: .leading, spacing: family == .systemSmall ? 8 : 12) {
            HStack(alignment: .top, spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.97, green: 0.79, blue: 0.25).opacity(0.18))
                        .frame(width: family == .systemSmall ? 30 : 38, height: family == .systemSmall ? 30 : 38)
                    Text(entry.symbol)
                        .font(.system(size: family == .systemSmall ? 12 : 14, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.97, green: 0.79, blue: 0.25))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.institution)
                        .font(.system(size: family == .systemSmall ? 12 : 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text("黄金报价 元/克")
                        .font(.system(size: family == .systemSmall ? 10 : 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Spacer()

                if family != .systemSmall {
                    Text(entry.date, style: .time)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }

            if family == .systemSmall {
                VStack(alignment: .leading, spacing: 8) {
                    Text(priceText(entry.price))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                    Text(changeText(entry.change))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(entry.change >= 0 ? Color(red: 0.52, green: 0.88, blue: 0.46) : Color(red: 0.96, green: 0.48, blue: 0.48))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.6))
                    Text(entry.date, style: .time)
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            else {
                HStack(alignment: .firstTextBaseline, spacing: 16) {
                    Text(priceText(entry.price))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                    Text(changeText(entry.change))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(entry.change >= 0 ? Color(red: 0.52, green: 0.88, blue: 0.46) : Color(red: 0.96, green: 0.48, blue: 0.48))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .containerBackground(Color.black, for: .widget)
    }

    private func priceText(_ value: Double) -> String {
        "¥\(String(format: "%.2f", value))"
    }

    private func changeText(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", value))"
    }
}

struct GoldActivities: Widget {
    let kind: String = "GoldActivities"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            GoldActivitiesEntryView(entry: entry)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    GoldActivities()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, institution: "上海黄金交易所", symbol: "Au", price: 568.40, change: 1.25)
    SimpleEntry(date: .now, configuration: .starEyes, institution: "工商银行", symbol: "Au", price: 566.80, change: -0.85)
}
