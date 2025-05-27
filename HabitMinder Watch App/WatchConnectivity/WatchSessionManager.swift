//
//  WatchSessionManager.swift
//  HabitMinder Watch App
//
//  Created by Mahyar on 12/04/2025.
//

import WatchConnectivity

final class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    var viewModel: HomeViewModel?
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func configure(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let habits = applicationContext["habits"] as? [[String: Any]] else {
            AppLogger.watch.warning("No habits found in received context.")
            return
        }
        let parsedHabits: [HabitData] = habits.compactMap { dict in
            guard let title = dict["title"] as? String,
                  let daysLeft = dict["daysLeft"] as? Int else {
                return nil
            }
            return HabitData(title: title, daysLeft: daysLeft)
        }
        DispatchQueue.main.async {
            self.viewModel?.updateHabits(parsedHabits)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            AppLogger.watch.error("Session activation error: \(error.localizedDescription)")
        }
    }
}
