//
//  AutoSyncManager.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 22/07/25.
//

import Foundation
import Network

/// Singleton that manages periodic auto-sync based on network availability and a scheduled timer.
class AutoSyncManager {

    static let shared = AutoSyncManager()

    private var networkMonitor: NWPathMonitor?
    private var syncTimer: Timer?
    private var isConnected: Bool = false
    private var syncCallback: (() -> Void)?

    private init() {}

    /// Starts the auto-sync mechanism.
    /// - Parameter syncAction: The closure to execute when sync is triggered (network or timer).
    func startAutoSync(syncAction: @escaping () -> Void) {
        self.syncCallback = syncAction
        startNetworkMonitoring()
        startSyncTimer()
    }

    /// Stops both network monitoring and timer-based sync.
    func stopAutoSync() {
        networkMonitor?.cancel()
        syncTimer?.invalidate()
        networkMonitor = nil
        syncTimer = nil
        isConnected = false
        syncCallback = nil
    }

    // MARK: - Internal Logic

    private func startNetworkMonitoring() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "com.airfi.autosync.network")

        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
                if self?.isConnected == true {
                    print("[AutoSync] ✅ Network available – Triggering sync")
                    self?.syncCallback?()
                } else {
                    print("[AutoSync] ⚠️ Network unavailable – Pausing sync")
                }
            }
        }

        monitor.start(queue: queue)
        networkMonitor = monitor
    }

    private func startSyncTimer() {
        syncTimer = Timer.scheduledTimer(withTimeInterval: 15 * 60, repeats: true) { [weak self] _ in
            guard let self = self, self.isConnected else {
                print("[AutoSync] ⏳ Timer fired – No network, skipping sync")
                return
            }

            print("[AutoSync] ⏱ Timer fired – Triggering sync")
            self.syncCallback?()
        }

        RunLoop.main.add(syncTimer!, forMode: .common)
    }
}
