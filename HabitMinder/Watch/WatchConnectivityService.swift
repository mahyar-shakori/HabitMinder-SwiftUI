//
//  WatchConnectivityService.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/04/2025.
//

import WatchConnectivity

final class WatchConnectivityService: WatchConnectivityProviding {
    private var session: WatchConnectivitySession
    private let delegate: WCSessionDelegate
    
    init(session: WatchConnectivitySession = WCSession.default,
         delegate: WCSessionDelegate = WatchConnectivityDelegate()) {
        self.session = session
        self.delegate = delegate
        self.session.delegate = delegate
        self.session.activate()
    }
    
    func sendHabits(_ habits: [HabitData]) {
        let payload = habits.map { $0.toDictionary }
        
        if session.activationState == .activated {
            do {
                try session.updateApplicationContext([WatchConnectivityKeys.habits: payload])
            } catch {
#if DEBUG
                AppLogger.watch.error("Failed to send habits: \(error.localizedDescription)")
#endif
            }
        } else {
            (delegate as? WatchConnectivityDelegate)?.queueHabits(payload)
        }
    }
}
