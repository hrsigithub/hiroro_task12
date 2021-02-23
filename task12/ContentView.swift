//
//  ContentView.swift
//  task12
//
//  Created by Hiroshi.Nakai on 2021/02/22.
//

import SwiftUI

class PriceInfo: ObservableObject{

    let keyTax = "tax"

    @Published var textTaxRate: String {
        didSet {
            UserDefaults.standard.set(textTaxRate, forKey: keyTax)
        }
    }

    init() {
        textTaxRate = UserDefaults.standard.string(forKey: keyTax) ?? ""
    }

    @Published var textPrice = ""
    @Published var taxIncludePrice: Int?

    // 税込計算
    func calcTaxIncludePrice() -> Int {
        let price = Int(self.textPrice) ?? 0
        let taxRate = Float(self.textTaxRate) ?? 0

        return Int(Float(price) * (1.0 + taxRate / 100.0))
    }
}

struct ContentView: View {

    @ObservedObject var priceInfo = PriceInfo()

    var body: some View {
        VStack {

            HStack {
                Spacer().frame(width: 10)
                Text("税抜金額")
                TextField("", text: $priceInfo.textPrice)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                Text("円")
                Spacer().frame(width: 10)
            }

            HStack {
                Spacer().frame(width: 10)
                Text("消費税率")
                TextField("", text: $priceInfo.textTaxRate)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                Text("％")
                Spacer().frame(width: 10)
            }

            HStack {
                Spacer().frame(width: 70)
                Button("計算") {

                    // ここ、クラス内にまとめたいが。。計算ボタン押下しないで反映される。
                    priceInfo.taxIncludePrice = priceInfo.calcTaxIncludePrice()
                }
                Spacer().frame(width: 30)
            }
            Divider()

            HStack {
                Spacer().frame(width: 70)
                Text("税込金額 \(String(priceInfo.taxIncludePrice ?? 0)) 円")
                Spacer().frame(width: 10)
            }
            Spacer()

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
