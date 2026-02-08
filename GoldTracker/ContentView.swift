//
//  ContentView.swift
//  GoldTracker
//
//  Created by zhongyafeng on 2026/2/7.
//

import SwiftUI
import Combine

struct GoldPriceItem: Identifiable {
    let id = UUID()
    let name: String
    let shortName: String
    let accent: Color
    let basePrice: Double
    var price: Double
    var change: Double
}

final class GoldPriceViewModel: ObservableObject {
    @Published var items: [GoldPriceItem] = []

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init() {
        items = [
            GoldPriceItem(name: "上海黄金交易所", shortName: "SGE", accent: Color(red: 0.96, green: 0.76, blue: 0.22), basePrice: 568.0, price: 568.0, change: 0.0),
            GoldPriceItem(name: "工商银行", shortName: "ICBC", accent: Color(red: 0.18, green: 0.45, blue: 0.80), basePrice: 566.5, price: 566.5, change: 0.0),
            GoldPriceItem(name: "中国银行", shortName: "BOC", accent: Color(red: 0.78, green: 0.18, blue: 0.18), basePrice: 567.2, price: 567.2, change: 0.0),
            GoldPriceItem(name: "招商银行", shortName: "CMB", accent: Color(red: 0.86, green: 0.27, blue: 0.27), basePrice: 565.9, price: 565.9, change: 0.0),
            GoldPriceItem(name: "周大福", shortName: "CTF", accent: Color(red: 0.52, green: 0.42, blue: 0.12), basePrice: 571.6, price: 571.6, change: 0.0),
            GoldPriceItem(name: "老凤祥", shortName: "LFX", accent: Color(red: 0.72, green: 0.15, blue: 0.33), basePrice: 570.8, price: 570.8, change: 0.0)
        ]
    }

    func refresh() {
        items = items.map { item in
            let delta = Double.random(in: -2.6...2.6)
            let newPrice = max(520, item.price + delta)
            return GoldPriceItem(
                name: item.name,
                shortName: item.shortName,
                accent: item.accent,
                basePrice: item.basePrice,
                price: newPrice,
                change: newPrice - item.price
            )
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = GoldPriceViewModel()
    @StateObject private var liveManager = GoldLiveActivityManager()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.06, blue: 0.08), Color(red: 0.16, green: 0.14, blue: 0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                header

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.items) { item in
                            GoldPriceRow(item: item)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .onReceive(viewModel.timer) { _ in
            viewModel.refresh()
            if let item = viewModel.items.first {
                Task { await liveManager.update(with: item) }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("机构黄金报价")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("每秒刷新 · Mock 数据")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.65))
                }

                Spacer()

                Image(systemName: "sparkles")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color(red: 0.98, green: 0.82, blue: 0.34))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
            }

            HStack(spacing: 12) {
                capsuleTag(text: "单位：元/克")
                capsuleTag(text: "趋势：实时波动")
            }

            HStack(spacing: 12) {
                Button {
                    guard let item = viewModel.items.first else { return }
                    Task { await liveManager.startIfNeeded(with: item) }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                        Text("启动实时活动")
                    }
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.12))
                    )
                }

                Button {
                    Task { await liveManager.end() }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark")
                        Text("结束实时活动")
                    }
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(liveManager.isActive ? 0.9 : 0.5))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                    )
                }
                .disabled(!liveManager.isActive)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private func capsuleTag(text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(.white.opacity(0.8))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.08))
            )
    }
}

struct GoldPriceRow: View {
    let item: GoldPriceItem

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(item.accent.opacity(0.2))
                    .frame(width: 50, height: 50)
                Text(item.shortName)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(item.accent)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                Text("参考价：\(formatted(item.basePrice))")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(formatted(item.price))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                HStack(spacing: 4) {
                    Image(systemName: item.change >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 12, weight: .semibold))
                    Text(changeText(item.change))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(item.change >= 0 ? Color(red: 0.52, green: 0.88, blue: 0.46) : Color(red: 0.96, green: 0.48, blue: 0.48))
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private func formatted(_ value: Double) -> String {
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
