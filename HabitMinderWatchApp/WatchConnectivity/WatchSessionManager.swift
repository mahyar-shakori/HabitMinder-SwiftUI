//
//  WatchSessionManager.swift
//  HabitMinder Watch App
//
//  Created by Mahyar on 12/04/2025.
//

import WatchConnectivity

final class WatchSessionManager: NSObject, WCSessionDelegate, WatchSessionManaging {
    private var homeViewModel: HomeViewModel?
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func configure(with homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        requestCurrentHabits()
    }

    func requestCurrentHabits() {
        updateHabits(from: session.receivedApplicationContext)
    }
    
    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        updateHabits(from: applicationContext)
    }

    private func updateHabits(from applicationContext: [String: Any]) {
        guard let habits = applicationContext[WatchConnectivityKeys.habits] as? [[String: Any]] else {
#if DEBUG
            AppLogger.watch.warning("No habits found in received context.")
#endif
            return
        }

        let parsedHabits: [HabitData] = habits.compactMap { dict in
            guard let title = dict[WatchConnectivityKeys.title] as? String,
                  let daysLeft = dict[WatchConnectivityKeys.daysLeft] as? Int else {
                return nil
            }
            return HabitData(title: title, daysLeft: daysLeft)
        }

        Task { @MainActor in
            homeViewModel?.updateHabits(parsedHabits)
        }
    }
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error {
#if DEBUG
            AppLogger.watch.error("Session activation error: \(error.localizedDescription)")
#endif
        }
    }
}
