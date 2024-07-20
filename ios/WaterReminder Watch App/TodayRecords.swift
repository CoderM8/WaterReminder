import Combine
import Foundation
import SwiftUI

struct WaterHistory: Identifiable {
    let id: String
    let userId: String
    let waterMl: String
    let createdAt: String
    let mlImage: String
    let total: String
}

struct TodayRecords: View {
    @ObservedObject var viewModel = WaterHistoryViewModel()
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.waterHistory.isEmpty {
                    Text("Today's Record not found!").font(.system(size: 14)).foregroundColor(.gray)
                } else {
                    List(viewModel.waterHistory) { item in

                        HStack {
                            Image("\(item.waterMl)ml").resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                            Spacer().frame(width: 8)
                            Text("\(item.waterMl)ml").font(.system(size: 15)).bold()
                            Spacer()
                            Text("\(formatDate(from: item.createdAt))").font(.system(size: 10))
                        }
                    }.listStyle(.elliptical)
                }
            }.onAppear {
                viewModel.fetchWaterHistory(userID: "13")
            }

            .navigationTitle("Today Records").toolbarTitleDisplayMode(.inline)
        }
    }

    func formatDate(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateString)
        formatter.dateFormat = "hh:mm a"
        return date != nil ? formatter.string(from: date!) : dateString
    }
}

class WaterHistoryViewModel: ObservableObject {
    @Published var waterHistory: [WaterHistory] = []

    var url = "https://vocsyinfotech.in/vocsy/flutter/Water_Reminder/api.php"

    func fetchWaterHistory(userID: String) {
        let url1 = URL(string: url)!
        var request = URLRequest(url: url1)
        request.httpMethod = "POST"

        let parameters: [String: Any] = [
            "method_name": "user_water_history2",
            "package_name": "com.vocsy.waterreminder",
            "user_id": "\(userID)",
        ]

        request.httpBody = parameters.percentEscaped().data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if error == nil {
                    print("localizedDescription Error -----> \(error?.localizedDescription ?? "ERROR")")
                }
                return
            }
            if let response = response as? HTTPURLResponse {
                guard (200 ... 299) ~= response.statusCode else {
                    print("Status code -----> \(response.statusCode) Response -----> \(response)")
                    return
                }
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let waterRemindArray = json["WATER_REMIND"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.waterHistory = waterRemindArray.compactMap { dict in
                            guard let id = dict["id"] as? String,
                                  let userId = dict["user_id"] as? String,
                                  let waterMl = dict["water_ml"] as? String,
                                  let createdAt = dict["created_at"] as? String,
                                  let total = dict["total_records"] as? String,
                                  let mlImage = dict["ml_image"] as? String else {
                                return nil
                            }
//                            print("WaterHistory Data -----> id : \(id) , userId : \(userId) , waterMl : \(waterMl) , createdAt : \(createdAt) , total : \(total) , mlImage : \(mlImage)")
                            return WaterHistory(id: id, userId: userId, waterMl: waterMl, createdAt: createdAt, mlImage: mlImage, total: total)
                        }
                    }
                }
            } catch let error {
                print("Catch Error -----> \(error.localizedDescription)")
            }
        }.resume()
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

#Preview {
    TodayRecords()
}
