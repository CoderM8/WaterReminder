import SwiftUI

struct Item {
    let image: String
    let index: Int
    let ml: String
    let color: Color
}


struct AddWater: View {
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()

    let items: [Item] = [
        Item(image: "50ml", index: 0, ml: "50", color: Color(UIColor(hex: 0xFF55A6F2))), // C3DEF6
        Item(image: "100ml", index: 1, ml: "100", color: Color(UIColor(hex: 0xFFF25555))), // F6C3C3
        Item(image: "250ml", index: 2, ml: "250", color: Color(UIColor(hex: 0xFFBF6E2C))), // C3CEF6
        Item(image: "300ml", index: 3, ml: "300", color: Color(UIColor(hex: 0xFF30D153))), // C3E6CB
        Item(image: "350ml", index: 4, ml: "350", color: Color(UIColor(hex: 0xFFF255B3))), // F6C3E2
        Item(image: "400ml", index: 5, ml: "400", color: Color(UIColor(hex: 0xFF0CC2B6))), // C3E5E3
        Item(image: "450ml", index: 6, ml: "450", color: Color(UIColor(hex: 0xFFA3B81F))), // E4E9C3
        Item(image: "500ml", index: 7, ml: "500", color: Color(UIColor(hex: 0xFF5581F2))), // C7D4F6
        Item(image: "550ml", index: 8, ml: "550", color: Color(UIColor(hex: 0xFF7986CB))), // D7D2DE
        Item(image: "600ml", index: 9, ml: "600", color: Color(UIColor(hex: 0xFFF5734C))), // F6DAD1
        Item(image: "650ml", index: 10, ml: "650", color: Color(UIColor(hex: 0xFFDBB837))), // ECE8D9
        Item(image: "700ml", index: 11, ml: "700", color: Color(UIColor(hex: 0xFFBABABA))), // E8E8E8
        Item(image: "750ml", index: 12, ml: "750", color: Color(UIColor(hex: 0xFF34C239))), // CDF1CF
        Item(image: "800ml", index: 13, ml: "800", color: Color(UIColor(hex: 0xFFA98AFF))), // E5DFF6
        Item(image: "850ml", index: 14, ml: "850", color: Color(UIColor(hex: 0xFFF48FB1))), // F6CEEB
        Item(image: "900ml", index: 15, ml: "900", color: Color(UIColor(hex: 0xFF4992FF))), // D2E0F6
    ]

    let gridItems = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 8), count: 2)

    @State private var showIcon: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    ScrollView {
                        LazyVGrid(columns: gridItems, spacing: 8) {
                            ForEach(items, id: \.index) { item in

                                VStack {
                                    Image(item.image).resizable()
                                        .aspectRatio(contentMode: .fit).frame(width: 23, height: 23)
                                    Spacer().frame(height: 5)

                                    Text("\(item.ml)ml").font(.system(size: 11)).bold()
                                }.frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.4).background(item.color).cornerRadius(15).onTapGesture {
                                    print("Add Water -----> \(item.ml)")
                                    
                                    viewModel.updateText("\(item.ml)", "\(item.image)")
//                                    viewModel.sendDataMessage(for: .sendCounterToFlutter, data: ["drinkWater": "\(item.ml)", "image": "\(item.image)"])
                                    print("Send Water Success----->")
                                    showIcon = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showIcon = false
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Add Water").toolbarTitleDisplayMode(.inline)
                if showIcon {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    AddWater()
}
