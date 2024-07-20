import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = WatchViewModel()
    @State private var isAddWater: Bool = false
    @State private var isTodayRecords: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image("Apple")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())

                        Text("\(viewModel.drinkWater)ml").bold().font(.system(size: 16)).foregroundColor(Color(UIColor(hex: 0xFF1998F1)))

                        Text("•").font(.system(size: 18))
                        Text("\(viewModel.waterPercentage)%").bold().font(.system(size: 20)).foregroundColor(Color(UIColor(hex: 0xFF1998F1)))
                    }
                    Spacer().frame(height: 10)

                    HStack {
                        Text("\(viewModel.remainingWater)ml").font(.system(size: 15))
                        Text("remaining").font(.system(size: 15))
                    }

                    Spacer().frame(height: 5)

                    Gauge(value: viewModel.waterProgress, in: 0 ... 1) {
                    }.gaugeStyle(.linearCapacity).colorMultiply(/*@START_MENU_TOKEN@*/ .blue/*@END_MENU_TOKEN@*/)

                    Spacer().frame(height: 20)

                    Button(action: {
                        isAddWater = true
                    }) {
                        HStack {
                            Image(systemName: "plus")

                                .foregroundColor(.blue)
                            Text("Add Water")
                        }
                    }
                    .frame(height: 40)
                    .cornerRadius(20).navigationDestination(isPresented: $isAddWater) {
                        AddWater()
                    }

                    Button(action: {
                        isTodayRecords = true
                    }) {
                        HStack {
                            Image(systemName: "drop.fill")

                                .foregroundColor(.blue)
                            Text("Today Records")
                        }
                    }
                    .frame(height: 40)
                    .cornerRadius(20).navigationDestination(isPresented: $isTodayRecords) {
                        TodayRecords()
                    }

                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }.navigationTitle("Today")
        }
    }
}

// UIColor extension to initialize with hex value
extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

#Preview {
    ContentView()
}
