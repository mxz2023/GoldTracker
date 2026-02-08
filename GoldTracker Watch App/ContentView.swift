//
//  ContentView.swift
//  GoldTrackerWatch Watch App
//
//  Created by zhongyafeng on 2026/2/8.
//

import SwiftUI
import Combine

final class WatchGoldViewModel: ObservableObject {
    @Published var quotes: [GoldQuote] = []
    @Published var isUsingSharedData = false
    @Published var lastWrite: Date? = nil
    @Published var lastCount: Int = 0

    func refresh() {
        let loaded = GoldSharedStore.loadQuotes()
        if loaded.isEmpty {
            quotes = GoldSharedStore.mockQuotes()
            isUsingSharedData = false
        } else {
            quotes = loaded
            isUsingSharedData = true
        }
        lastWrite = GoldSharedStore.lastWriteDate()
        lastCount = GoldSharedStore.lastWriteCount()
    }
}

struct ContentView: View {
    @StateObject private var viewModel = WatchGoldViewModel()
    @Environment(\.scenePhase) private var scenePhase
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(viewModel.isUsingSharedData ? Color.green : Color.orange)
                        .frame(width: 6, height: 6)
                    Text(viewModel.isUsingSharedData ? "Shared Data" : "Mock Data")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 2)

                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.55))
                    Text(lastWriteText())
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.55))
                    if viewModel.lastCount > 0 {
                        Text("(\(viewModel.lastCount))")
                            .font(.system(size: 9, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.55))
                    }
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 6)

                ForEach(viewModel.quotes, id: \.self) { quote in
                    QuoteRow(quote: quote)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .background(Color.black)
        .onAppear { viewModel.refresh() }
        .onReceive(timer) { _ in
            if scenePhase == .active {
                viewModel.refresh()
            }
        }
    }

    private func lastWriteText() -> String {
        guard let date = viewModel.lastWrite else { return "No Shared Writes" }
        return date.formatted(date: .omitted, time: .shortened)
    }
}

struct QuoteRow: View {
    let quote: GoldQuote

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.97, green: 0.79, blue: 0.25).opacity(0.18))
                        .frame(width: 26, height: 26)
                    Text(quote.symbol)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.97, green: 0.79, blue: 0.25))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(quote.name)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text("元/克")
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()

                Text(quote.updatedAt, style: .time)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(priceText(quote.price))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(changeText(quote.change))
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(quote.change >= 0 ? Color(red: 0.52, green: 0.88, blue: 0.46) : Color(red: 0.96, green: 0.48, blue: 0.48))
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
    }

    private func priceText(_ value: Double) -> String {
        "¥\(String(format: "%.2f", value))"
    }

    private func changeText(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", value))"
    }
}

#Preview {
    ContentView()
}
