import Testing
@testable import CodexBar

struct UsageProgressBarTests {
    @Test
    func `highlighted zero percent bar hides track without pace marker`() {
        #expect(UsageProgressBar.shouldShowTrack(highlighted: true, percent: 0, pacePercent: nil) == false)
    }

    @Test
    func `highlighted non zero percent bar keeps track`() {
        #expect(UsageProgressBar.shouldShowTrack(highlighted: true, percent: 24, pacePercent: nil) == true)
    }

    @Test
    func `highlighted zero percent bar keeps track when pace marker exists`() {
        #expect(UsageProgressBar.shouldShowTrack(highlighted: true, percent: 0, pacePercent: 35) == true)
    }
}
