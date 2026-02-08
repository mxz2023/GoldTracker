//
//  GoldActivitiesLiveActivity.swift
//  GoldActivities
//
//  Created by zhongyafeng on 2026/2/7.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GoldActivitiesAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GoldActivitiesLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GoldActivitiesAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GoldActivitiesAttributes {
    fileprivate static var preview: GoldActivitiesAttributes {
        GoldActivitiesAttributes(name: "World")
    }
}

extension GoldActivitiesAttributes.ContentState {
    fileprivate static var smiley: GoldActivitiesAttributes.ContentState {
        GoldActivitiesAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GoldActivitiesAttributes.ContentState {
         GoldActivitiesAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GoldActivitiesAttributes.preview) {
   GoldActivitiesLiveActivity()
} contentStates: {
    GoldActivitiesAttributes.ContentState.smiley
    GoldActivitiesAttributes.ContentState.starEyes
}
