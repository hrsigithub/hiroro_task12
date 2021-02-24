//
//  ContentView.swift
//  task12
//
//  Created by Hiroshi.Nakai on 2021/02/22.
//

import SwiftUI

/// 責務: 税率の保存・読み込み
class TaxRateRepository {
    private let keyTax = "tax"

    func load() -> Int {
        UserDefaults.standard.integer(forKey: keyTax)
    }

    func save(taxRate: Int) {
        UserDefaults.standard.set(taxRate, forKey: keyTax)
    }
}

/// 責務: 税込金額の計算
class PriceCalculator {
    func calculateTaxIncludePrice(price: Int, taxRate: Int) -> Int {
        Int(Double(price) * (1.0 + Double(taxRate) / 100.0))
    }
}

/// 責務: プレゼンテーションロジックとステート（状態）を持つ
/// ・ドメイン・エンティティをViewに表示できるように整形
/// ・ドメイン・ロジックが公開するメソッドを操作として公開
class ContentViewModel: ObservableObject {
    private let taxRateRepository = TaxRateRepository()

    @Published var textTaxRate: String {
        didSet {
            taxRateRepository.save(taxRate: Int(textTaxRate) ?? 0)
        }
    }

    init() {
        textTaxRate = String(taxRateRepository.load())
    }

    @Published var textPrice = ""
    @Published var taxIncludePrice: Int?

    func calculate() {
        taxIncludePrice = PriceCalculator().calculateTaxIncludePrice(
            price: Int(textPrice) ?? 0,
            taxRate: Int(textTaxRate) ?? 0
        )
    }
}

struct ContentView: View {

    @ObservedObject var viewModel = ContentViewModel()

    var body: some View {
        VStack {

            HStack {
                Spacer().frame(width: 10)
                Text("税抜金額")
                TextField("", text: $viewModel.textPrice)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                Text("円")
                Spacer().frame(width: 10)
            }

            HStack {
                Spacer().frame(width: 10)
                Text("消費税率")
                TextField("", text: $viewModel.textTaxRate)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                Text("％")
                Spacer().frame(width: 10)
            }

            HStack {
                Spacer().frame(width: 70)
                Button("計算") {
                    viewModel.calculate()
                }
                Spacer().frame(width: 30)
            }
            Divider()

            HStack {
                Spacer().frame(width: 70)
                Text("税込金額 \(String(viewModel.taxIncludePrice ?? 0)) 円")
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
