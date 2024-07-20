import Foundation
import WatchConnectivity

final class WatchViewModel: NSObject, ObservableObject {
    @Published var drinkWater = 0
    @Published var remainingWater = 0
    @Published var waterPercentage = "0.0"
    @Published var waterProgress = 0.0

    private let session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }

    func updateText(_ waterML: String, _ image: String) {
        session.sendMessage(["method": "updateTextFromWatch", "data": ["waterML": waterML, "image": image]], replyHandler: nil, errorHandler: nil)
    }
}

extension WatchViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("did receive message ------")
        guard let method = message["method"] as? String, let data = message["data"] as? [String: Any] else { return }

        guard method == "updateTextFromFlutter", let drinkWater = data["drinkWater"] as? Int, let remainingWater = data["remainingWater"] as? Int, let waterPercentage = data["waterPercentage"] as? String, let waterProgress = data["waterProgress"] as? Double else { return }

        Task { @MainActor in
            self.drinkWater = drinkWater
            self.remainingWater = remainingWater
            self.waterPercentage = waterPercentage
            self.waterProgress = waterProgress
        }
    }
}

// import Foundation
// import WatchConnectivity
//
// class WatchViewModel: NSObject, ObservableObject {
//    var session: WCSession
//    @Published var drinkWater = 0
//    @Published var remainingWater = 0
//    @Published var waterPercentage = "0.0"
//    @Published var waterProgress = 0.0
//
//    // Add more cases if you have more receive method
//    enum WatchReceiveMethod: String {
//        case sendCounterToNative
//    }
//
//    // Add more cases if you have more sending method
//    enum WatchSendMethod: String {
//        case sendCounterToFlutter
//    }
//
//    init(session: WCSession = .default) {
//        self.session = session
//        super.init()
//        self.session.delegate = self
//        session.activate()
//    }
//
//    func sendDataMessage(for method: WatchSendMethod, data: [String: Any] = [:]) {
//        sendMessage(for: method.rawValue, data: data)
//    }
//
// }
//
// extension WatchViewModel: WCSessionDelegate {
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//
//    }
//
//    // Receive message From AppDelegate.swift that send from iOS devices
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        print("watch didReceiveMessage -----")
//        DispatchQueue.main.async {
//            print("watch DispatchQueue -----")
//            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMethod(rawValue: method) else {
//                return
//            }
//            switch enumMethod {
//            case .sendCounterToNative:
//
//              if let data = message["data"] as? [String: Any] {
//                self.drinkWater = data["drinkWater"] as? Int ?? 0
//                    self.remainingWater = data["remainingWater"] as? Int ?? 0
//                    self.waterPercentage = data["waterPercentage"] as? String ?? "0.0"
//                   self.waterProgress = data["waterProgress"] as? Double ?? 0.0
//
//                   print("received data -> drinkWater: \(self.drinkWater), remainingWater: \(self.remainingWater), waterPercentage: \(self.waterPercentage), waterProgress: \(self.waterProgress)")
//                }
//                self.drinkWater = (message["data"] as? Int) ?? 0
//                print("receive drinkWater ------> \(self.drinkWater)")
//            }
//        }
//    }
//
//    func sendMessage(for method: String, data: [String: Any] = [:]) {
//        print("send message ----  \(method) ----  \(data)")
//        guard session.isReachable else {
//            return
//        }
//        let messageData: [String: Any] = ["method": method, "data": data]
//        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
//    }
// }
