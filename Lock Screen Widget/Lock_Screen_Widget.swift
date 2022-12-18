//
//  Lock_Screen_Widget.swift
//  Lock Screen Widget
//
//  Created by Devin Fernando on 2022-12-17.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []//dd

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct Lock_Screen_WidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily{
        case.accessoryCircular:
            Gauge(value: 0.7){
                Text(entry.date,format:.dateTime.weekday())
                
            }
            
            .gaugeStyle(.accessoryCircular)
            
            
            
//        case.accessoryCircular:
//            Gauge(value: 0.7){
//                Text(entry.date,format:.dateTime.timeZone())
//
//            }
//            .gaugeStyle(.accessoryCircular)
            
            
        case.accessoryRectangular:
            Gauge(value: 0.7){
                Text(entry.date, format:.dateTime.second())
            }
            
        case.accessoryInline:
            
                Text(entry.date, format:.dateTime.year())
            
            
        default:
            Text(entry.date,format: .dateTime.week())
        }
    }
}

@main
struct Lock_Screen_Widget: Widget {
    let kind: String = "Lock_Screen_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Lock_Screen_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryInline,.accessoryCircular,.accessoryRectangular])
    }
}


//creating new views
struct Lock_Screen_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Lock_Screen_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")
        
        
        Lock_Screen_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
        
        Lock_Screen_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
    }
}
