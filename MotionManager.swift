//
// MotionHistory.swift
//
// Created by Speedyfriend67 on 18.06.24
//
import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var yaw: Double = 0.0
    @Published var pitchHistory: [Double] = []
    @Published var rollHistory: [Double] = []
    @Published var yawHistory: [Double] = []
    private var timer: Timer?
    private let pitchThreshold = 45.0
    private let rollThreshold = 45.0
    private let yawThreshold = 45.0
    
    init() {
        loadHistory()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // Handle authorization
        }
    }
    
    func startUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                guard let data = data else { return }
                
                let attitude = data.attitude
                self?.pitch = attitude.pitch * 180 / .pi
                self?.roll = attitude.roll * 180 / .pi
                self?.yaw = attitude.yaw * 180 / .pi
                
                self?.pitchHistory.append(self?.pitch ?? 0.0)
                self?.rollHistory.append(self?.roll ?? 0.0)
                self?.yawHistory.append(self?.yaw ?? 0.0)
                
                self?.saveHistory()
                self?.checkThresholds()
                
                if self?.pitchHistory.count ?? 0 > 100 {
                    self?.pitchHistory.removeFirst()
                    self?.rollHistory.removeFirst()
                    self?.yawHistory.removeFirst()
                }
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.objectWillChange.send()
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
        timer?.invalidate()
    }
    
    private func saveHistory() {
        UserDefaults.standard.set(pitchHistory, forKey: "pitchHistory")
        UserDefaults.standard.set(rollHistory, forKey: "rollHistory")
        UserDefaults.standard.set(yawHistory, forKey: "yawHistory")
    }
    
    private func loadHistory() {
        pitchHistory = UserDefaults.standard.object(forKey: "pitchHistory") as? [Double] ?? []
        rollHistory = UserDefaults.standard.object(forKey: "rollHistory") as? [Double] ?? []
        yawHistory = UserDefaults.standard.object(forKey: "yawHistory") as? [Double] ?? []
    }
    
    private func checkThresholds() {
        if abs(pitch) > pitchThreshold || abs(roll) > rollThreshold || abs(yaw) > yawThreshold {
            sendNotification()
        }
    }
    
    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Tilt Alert"
        content.body = "Device tilt exceeded threshold!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}