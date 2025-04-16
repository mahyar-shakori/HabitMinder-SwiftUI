//
//  WatchConnectivityDelegate.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/04/2025.
//

import WatchConnectivity
import OSLog

final class WatchConnectivityDelegate: NSObject, WCSessionDelegate {
    private var queued: [[String: Any]]?

    func queueHabits(_ habits: [[String: Any]]) {
        self.queued = habits
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            Logger.watch.error("Activation error: \(error.localizedDescription)")
        }

        if activationState == .activated, let habits = queued {
            do {
                try session.updateApplicationContext(["habits": habits])
                queued = nil
            } catch {
                Logger.watch.error("Failed to send queued habits: \(error.localizedDescription)")
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        Logger.watch.info("Session inactive.")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        Logger.watch.warning("Session deactivated.")
        WCSession.default.activate()
    }
}
