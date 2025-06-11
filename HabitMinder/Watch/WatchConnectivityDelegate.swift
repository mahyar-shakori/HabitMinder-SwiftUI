//
//  WatchConnectivityDelegate.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/04/2025.
//

import WatchConnectivity

final class WatchConnectivityDelegate: NSObject, WCSessionDelegate {
    private var queued: [[String: Any]]?
    
    func queueHabits(_ habits: [[String: Any]]) {
        self.queued = habits
    }
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error {
#if DEBUG
            AppLogger.watch.error("Activation error: \(error.localizedDescription)")
#endif
        }
        
        if activationState == .activated, let habits = queued {
            do {
                try session.updateApplicationContext([WatchConnectivityKeys.habits: habits])
                queued = nil
            } catch {
#if DEBUG
                AppLogger.watch.error("Failed to send queued habits: \(error.localizedDescription)")
#endif
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
#if DEBUG
        AppLogger.watch.info("Session inactive.")
#endif
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
#if DEBUG
        AppLogger.watch.warning("Session deactivated.")
#endif
        session.activate()
    }
}
