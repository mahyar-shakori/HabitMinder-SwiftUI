//
//  WatchConnectivityService.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/04/2025.
//

import WatchConnectivity

final class WatchConnectivityService: WatchConnectivityProviding {
    static let shared = WatchConnectivityService()

    private let session: WCSession
    private let delegate: WatchConnectivityDelegate

    private init() {
        self.session = WCSession.default
        self.delegate = WatchConnectivityDelegate()
        session.delegate = delegate
        session.activate()
    }
    
    func sendHabits(_ habits: [HabitData]) {
        let payload = habits.map { $0.toDictionary }

        if session.activationState == .activated {
            do {
                try session.updateApplicationContext(["habits": payload])
            } catch {
                AppLogger.watch.error("Failed to send habits: \(error.localizedDescription)")
            }
        } else {
            delegate.queueHabits(payload)
        }
    }
}
