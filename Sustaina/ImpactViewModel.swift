//
//  ImpactViewModel.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/22/25.
//

import SwiftUI
import Combine

// Models for impact tracking
struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let points: Int
    var isUnlocked: Bool
}

struct CommunityProgress {
    let totalParticipants: Int
    let communityRank: Int
    let carbonSaved: Double
    let wasteDiverted: Double
    let percentileRanking: Int
}

struct MonthlyImpact {
    let month: Date
    var carbonSaved: Double
    var wasteDiverted: Double
    var actionsCompleted: Int
}

struct DailyChallenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let points: Int
    let type: ChallengeType
    var isCompleted: Bool
}

enum ChallengeType {
    case waste
    case energy
    case transport
    case education
}

class ImpactViewModel: ObservableObject {
    // Published properties for UI updates
    @Published var stats: ImpactStats
    @Published var achievements: [Achievement]
    @Published var communityProgress: CommunityProgress
    @Published var monthlyImpacts: [MonthlyImpact]
    @Published var dailyChallenges: [DailyChallenge]
    @Published var streakCount: Int
    @Published var totalPoints: Int

    // Activity status
    @Published var isLoading = false
    @Published var errorMessage: String?

    // UserDefaults keys
    private let userDefaultsKeys = ImpactUserDefaultsKeys()
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Initialize with default values
        self.stats = ImpactStats(carbonSaved: 0, wasteDiverted: 0, treesPlanted: 0, communityRank: 0)
        self.achievements = []
        self.communityProgress = CommunityProgress(
            totalParticipants: 0,
            communityRank: 0,
            carbonSaved: 0,
            wasteDiverted: 0,
            percentileRanking: 0
        )
        self.monthlyImpacts = []
        self.dailyChallenges = []
        self.streakCount = 0
        self.totalPoints = 0

        // Load saved data
        loadSavedData()
        // Setup daily challenges
        setupDailyChallenges()
        // Start monitoring for achievements
        startAchievementMonitoring()
    }

    // MARK: - Data Loading

    private func loadSavedData() {
        isLoading = true

        // Simulate API call with mock data for now
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadMockData()
            self.isLoading = false
        }
    }

    private func loadMockData() {
        // Mock achievements
        self.achievements = [
            Achievement(
                title: "Waste Warrior",
                description: "Properly sorted 100 items",
                icon: "medal",
                points: 500,
                isUnlocked: false
            ),
            Achievement(
                title: "Carbon Crusher",
                description: "Reduced carbon footprint by 1 ton",
                icon: "leaf",
                points: 1000,
                isUnlocked: false
            ),
            Achievement(
                title: "Community Champion",
                description: "Participated in 5 local initiatives",
                icon: "person.3",
                points: 750,
                isUnlocked: false
            )
        ]

        // Mock monthly impacts
        let calendar = Calendar.current
        let monthsAgo = (0...5).map { monthsAgo -> Date in
            calendar.date(byAdding: .month, value: -monthsAgo, to: Date()) ?? Date()
        }

        self.monthlyImpacts = monthsAgo.map { date in
            MonthlyImpact(
                month: date,
                carbonSaved: Double.random(in: 100...500),
                wasteDiverted: Double.random(in: 10...50),
                actionsCompleted: Int.random(in: 10...30)
            )
        }

        // Mock daily challenges
        self.dailyChallenges = generateDailyChallenges()
    }

    // MARK: - Daily Challenges

    private func setupDailyChallenges() {
        // Generate daily challenges for the user
        self.dailyChallenges = generateDailyChallenges()
    }

    private func generateDailyChallenges() -> [DailyChallenge] {
        return [
            DailyChallenge(
                title: "Zero Waste Day",
                description: "Don't generate any single-use plastic waste today",
                points: 100,
                type: .waste,
                isCompleted: false
            ),
            DailyChallenge(
                title: "Green Transport",
                description: "Use public transport or walk instead of driving",
                points: 75,
                type: .transport,
                isCompleted: false
            ),
            DailyChallenge(
                title: "Energy Saver",
                description: "Reduce energy consumption by 20% today",
                points: 50,
                type: .energy,
                isCompleted: false
            )
        ]
    }

    // MARK: - Impact Tracking

    func logAction(type: ActionType, value: Double) {
        switch type {
        case .carbonReduction:
            stats.carbonSaved += value
        case .wasteReduction:
            stats.wasteDiverted += value
        case .treePlanting:
            stats.treesPlanted += Int(value)
        }

        checkAchievements()
        updateCommunityProgress()
        saveProgress()
    }

    private func updateCommunityProgress() {
        // Mock logic to update community progress
        communityProgress = CommunityProgress(
            totalParticipants: 1000,
            communityRank: stats.communityRank + 1,
            carbonSaved: stats.carbonSaved,
            wasteDiverted: stats.wasteDiverted,
            percentileRanking: Int.random(in: 0...100)
        )
    }

    func completeChallenge(_ challenge: DailyChallenge) {
        if let index = dailyChallenges.firstIndex(where: { $0.id == challenge.id }) {
            dailyChallenges[index].isCompleted = true
            totalPoints += challenge.points
            checkStreakProgress()
        }
    }

    private func checkStreakProgress() {
        // Update the streak count if all challenges for the day are completed
        if dailyChallenges.allSatisfy({ $0.isCompleted }) {
            streakCount += 1
        } else {
            streakCount = 0
        }
    }

    // MARK: - Achievement Monitoring

    private func startAchievementMonitoring() {
        // Monitor stats changes for achievements
        $stats
            .sink { [weak self] newStats in
                self?.checkAchievements(with: newStats)
            }
            .store(in: &cancellables)
    }

    private func checkAchievements(with stats: ImpactStats? = nil) {
        let currentStats = stats ?? self.stats

        // Check each achievement condition
        for (index, achievement) in achievements.enumerated() {
            if !achievement.isUnlocked {
                let shouldUnlock = checkAchievementCondition(achievement, stats: currentStats)
                if shouldUnlock {
                    unlockAchievement(at: index)
                }
            }
        }
    }

    private func checkAchievementCondition(_ achievement: Achievement, stats: ImpactStats) -> Bool {
        // Add your achievement unlock conditions here
        switch achievement.title {
        case "Waste Warrior":
            return stats.wasteDiverted >= 100
        case "Carbon Crusher":
            return stats.carbonSaved >= 1000
        case "Community Champion":
            return communityProgress.percentileRanking >= 90
        default:
            return false
        }
    }

    private func unlockAchievement(at index: Int) {
        achievements[index].isUnlocked = true
        totalPoints += achievements[index].points
        // Trigger notification or celebration animation
    }

    // MARK: - Progress Saving

    private func saveProgress() {
        // Save current progress to UserDefaults or backend
        UserDefaults.standard.set(stats.carbonSaved, forKey: userDefaultsKeys.carbonSaved)
        UserDefaults.standard.set(stats.wasteDiverted, forKey: userDefaultsKeys.wasteDiverted)
        UserDefaults.standard.set(totalPoints, forKey: userDefaultsKeys.totalPoints)
    }
}

// MARK: - Helper Types

enum ActionType {
    case carbonReduction
    case wasteReduction
    case treePlanting
}

struct ImpactUserDefaultsKeys {
    let carbonSaved = "impact.carbonSaved"
    let wasteDiverted = "impact.wasteDiverted"
    let totalPoints = "impact.totalPoints"
    let streakCount = "impact.streakCount"
    let lastCompletedDate = "impact.lastCompletedDate"
}
