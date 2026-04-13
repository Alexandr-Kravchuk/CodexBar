import CodexBarCore
import Foundation
import Testing
@testable import CodexBar

struct MenuBarMetricWindowResolverTests {
    @Test
    func `automatic metric uses zai 5-hour token lane when it is most constrained`() {
        let snapshot = UsageSnapshot(
            primary: RateWindow(usedPercent: 12, windowMinutes: 10080, resetsAt: nil, resetDescription: nil),
            secondary: RateWindow(usedPercent: 10, windowMinutes: nil, resetsAt: nil, resetDescription: nil),
            tertiary: RateWindow(usedPercent: 92, windowMinutes: 300, resetsAt: nil, resetDescription: nil),
            updatedAt: Date())

        let window = MenuBarMetricWindowResolver.rateWindow(
            preference: .automatic,
            provider: .zai,
            snapshot: snapshot,
            supportsAverage: false)

        #expect(window?.usedPercent == 92)
    }

    @Test
    func `automatic metric uses claude weekly lane when session is full but weekly is exhausted`() {
        let snapshot = UsageSnapshot(
            primary: RateWindow(usedPercent: 0, windowMinutes: 300, resetsAt: nil, resetDescription: nil),
            secondary: RateWindow(usedPercent: 100, windowMinutes: 10080, resetsAt: nil, resetDescription: nil),
            updatedAt: Date())

        let window = MenuBarMetricWindowResolver.rateWindow(
            preference: .automatic,
            provider: .claude,
            snapshot: snapshot,
            supportsAverage: false)

        #expect(window?.remainingPercent == 0)
        #expect(window?.windowMinutes == 10080)
    }

    @Test
    func `automatic metric uses most constrained timed lane for non-special providers`() {
        let snapshot = UsageSnapshot(
            primary: RateWindow(usedPercent: 5, windowMinutes: 300, resetsAt: nil, resetDescription: nil),
            secondary: RateWindow(usedPercent: 100, windowMinutes: 10080, resetsAt: nil, resetDescription: nil),
            tertiary: RateWindow(usedPercent: 40, windowMinutes: 43200, resetsAt: nil, resetDescription: nil),
            updatedAt: Date())

        let window = MenuBarMetricWindowResolver.rateWindow(
            preference: .automatic,
            provider: .opencodego,
            snapshot: snapshot,
            supportsAverage: false)

        #expect(window?.remainingPercent == 0)
        #expect(window?.windowMinutes == 10080)
    }

    @Test
    func `automatic metric keeps primary when equal-length lanes represent parallel quotas`() {
        let snapshot = UsageSnapshot(
            primary: RateWindow(usedPercent: 20, windowMinutes: 1440, resetsAt: nil, resetDescription: nil),
            secondary: RateWindow(usedPercent: 40, windowMinutes: 1440, resetsAt: nil, resetDescription: nil),
            tertiary: RateWindow(usedPercent: 95, windowMinutes: 1440, resetsAt: nil, resetDescription: nil),
            updatedAt: Date())

        let window = MenuBarMetricWindowResolver.rateWindow(
            preference: .automatic,
            provider: .gemini,
            snapshot: snapshot,
            supportsAverage: false)

        #expect(window?.usedPercent == 20)
        #expect(window?.windowMinutes == 1440)
    }
}
