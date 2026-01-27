import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // App Group ID must match Dart code
    let groupId = "group.com.example.boilEggs"

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), status: "Idle", doneness: "--", endTimestamp: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = loadData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = loadData()
        // Reload every minute or when app requests
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func loadData() -> SimpleEntry {
        let userDefaults = UserDefaults(suiteName: groupId)
        let status = userDefaults?.string(forKey: "status") ?? "Idle"
        let doneness = userDefaults?.string(forKey: "doneness") ?? "--"
        let endTimestamp = userDefaults?.integer(forKey: "end_timestamp") ?? 0
        
        return SimpleEntry(
            date: Date(),
            status: status,
            doneness: doneness,
            endTimestamp: Double(endTimestamp)
        )
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let status: String
    let doneness: String
    let endTimestamp: Double
}

struct BoilEggsWidgetEntryView : View {
    var entry: Provider.Entry
    // Colors
    let softEggColor = Color(red: 255/255, green: 243/255, blue: 205/255)
    let textColor = Color(red: 51/255, green: 51/255, blue: 51/255)

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color.white)
            
            VStack {
                Text("Boil Eggs")
                    .font(.headline)
                    .foregroundColor(textColor)
                
                if entry.status == "boiling" && entry.endTimestamp > 0 {
                    Spacer()
                    Text("Boiling: \(entry.doneness)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Native Countdown
                    let targetDate = Date(timeIntervalSince1970: entry.endTimestamp / 1000)
                    Text(targetDate, style: .timer)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    Spacer()
                    Text("Idle")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("--:--")
                         .font(.system(size: 24, weight: .bold))
                         .foregroundColor(.gray)
                    Spacer()
                }
            }
            .padding()
        }
    }
}

@main
struct BoilEggsWidget: Widget {
    let kind: String = "BoilEggsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BoilEggsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Egg Timer")
        .description("Check your egg boiling status.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
