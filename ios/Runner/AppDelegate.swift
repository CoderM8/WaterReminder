import Flutter
import flutter_local_notifications
import UIKit
import WatchConnectivity


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var session: WCSession?
    private var channel: FlutterMethodChannel?
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
         FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
             GeneratedPluginRegistrant.register(with: registry)
         }
         if #available(iOS 10.0, *) {
             UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
         }
        
         initWatchConnectivity()
         initFlutterChannel()
         GeneratedPluginRegistrant.register(with: self)
         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func initWatchConnectivity() {
        guard WCSession.isSupported() else { return }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }

    private func initFlutterChannel() {
        DispatchQueue.main.async {
            guard let controller = self.window?.rootViewController as? FlutterViewController else { return }

            let channel = FlutterMethodChannel(name: "com.vocsywaterreminder", binaryMessenger: controller.binaryMessenger)
            channel.setMethodCallHandler { [weak self] call, result in
                let method = call.method
                let args = call.arguments
                
                print("method ---- \(method)")

                guard method == "phoneToWatch" else { return }
                guard let watchSession = self?.session, watchSession.isPaired, let messageData = args as? [String: Any] else {
                    print("watch not paired")
                    return
                }

                guard watchSession.isReachable else {
                    print("watch not reachable")
                    return
                }

                watchSession.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
            }
            self.channel = channel
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("receive method ----")
        guard let methodName = message["method"] as? String else { return }
        let data: [String: Any]? = message["data"] as? [String: Any]
        channel?.invokeMethod(methodName, arguments: data)
    }
}

//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//    var session: WCSession?
//    override func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        // This is required to make any communication available in the action isolate.
//        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
//            GeneratedPluginRegistrant.register(with: registry)
//        }
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
//        }
//        GeneratedPluginRegistrant.register(with: self)
//        print("start -----")
//
//        initFlutterChannel()
//
//        if WCSession.isSupported() {
//            print("-------> Watch Session Supported <-------")
//            session = WCSession.default
//            session?.delegate = self
//            session?.activate()
//        }
//
//        print("end -----")
//
//        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//    }
//
//    private func initFlutterChannel() {
//        print("flutterToWatch ---- 111")
//
//        if let controller = window?.rootViewController as? FlutterViewController {
//            print("flutterToWatch ---- 222")
//
//            let channel = FlutterMethodChannel(
//                name: "iphoneTowatch",
//                binaryMessenger: controller.binaryMessenger)
//
//            print("flutterToWatch 333 ---- \(channel)")
//
//            channel.setMethodCallHandler({ [weak self] (
//                call: FlutterMethodCall,
//                result: @escaping FlutterResult) in
//                switch call.method {
//                case "flutterToWatch":
//                    guard let watchSession = self?.session, watchSession.isPaired, watchSession.isReachable, let methodData = call.arguments as? [String: Any], let method = methodData["method"], let data = methodData["data"] else {
//                        result(false)
//                        return
//                    }
//
//                    let watchData: [String: Any] = ["method": method, "data": data]
//                    print("flutter watchData ---- \(watchData)")
//
//                    watchSession.sendMessage(watchData) { replaydata in
//                        print("\(replaydata)")
//                    } errorHandler: { err in
//                        print("\(err)")
//                    }
//                    result(true)
//
//                default:
//                    print("default ----")
//
//                    result(FlutterMethodNotImplemented)
//                }
//            })
//        }
//    }
//}
//
//extension AppDelegate: WCSessionDelegate {
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        if let error = error {
//            print("session -----> activationDidCompleteWith error")
//        } else {
//            print("session -----> activationState")
//        }
//    }
//
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        print("session -----> sessionDidBecomeInactive")
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//        print("session -----> sessionDidDeactivate")
//    }
//
//    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
//        print("session -----> didReceiveMessage")
//        DispatchQueue.main.async {
//            if let method = message["method"] as? String, let controller = self.window?.rootViewController as? FlutterViewController {
//                let channel = FlutterMethodChannel(
//                    name: "iphoneTowatch",
//                    binaryMessenger: controller.binaryMessenger)
//                channel.invokeMethod(method, arguments: message)
//            }
//        }
//    }
//}
