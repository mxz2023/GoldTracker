//
//  GoldActivitiesBundle.swift
//  GoldActivities
//
//  Created by zhongyafeng on 2026/2/7.
//

import WidgetKit
import SwiftUI

@main
struct GoldActivitiesBundle: WidgetBundle {
    var body: some Widget {
        GoldActivities()
        GoldActivitiesControl()
        GoldActivitiesLiveActivity()
    }
}
