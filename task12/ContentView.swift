//
//  ContentView.swift
//  task12
//
//  Created by Hiroshi.Nakai on 2021/02/22.
//

import SwiftUI

class TaxInfo: ObservableObject{

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
}

struct ContentView: View {

    @ObservedObject var taxInfo = TaxInfo()

    var body: some View {
        VStack {

            HStack {
                Spacer().frame(width: 10)
                Text("税抜金額")
                TextField("", text: $taxInfo.textPrice)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                Text("円")
                Spacer().frame(width: 10)
            }

            HStack {
                Spacer().frame(width: 10)
                Text("消費税率")
                TextField("", text: $taxInfo.textTaxRate)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 100)
                Text("％")
                Spacer().frame(width: 10)
            }

            HStack {
                Spacer().frame(width: 70)
                Button("計算") {
                    guard let price = Int(taxInfo.textPrice) else {
                        return
                    }

                    guard let taxRate = Float(taxInfo.textTaxRate) else {
                        return
                    }

                    taxInfo.taxIncludePrice = Int(Float(price) * (1.0 + taxRate / 100.0))
                }
                Spacer().frame(width: 30)
            }
            Divider()

            HStack {
                Spacer().frame(width: 70)
                Text("税込金額 \(String(taxInfo.taxIncludePrice ?? 0)) 円")
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
