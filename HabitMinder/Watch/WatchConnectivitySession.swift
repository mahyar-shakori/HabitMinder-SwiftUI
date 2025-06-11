//
//  WatchConnectivitySession.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 08/06/2025.
//

import WatchConnectivity

protocol WatchConnectivitySession {
    var activationState: WCSessionActivationState { get }
    func updateApplicationContext(_ applicationContext: [String: Any]) throws
    func activate()
    var delegate: WCSessionDelegate? { get set }
}

extension WCSession: WatchConnectivitySession {}
