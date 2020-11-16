//
//  WalletView.swift
//  My Citadel
//
//  Created by Maxim Orlovsky on 11/16/20.
//

import SwiftUI

struct WalletView: View {
    @Binding var wallet: WalletDisplayInfo
    
    func filter() {
        
    }
    
    var body: some View {
        VStack {
            BalancePager(withWallet: $wallet)
                .frame(height: 200.0)
            TransactionView(wallet: wallet)
        }
        .navigationTitle(wallet.name)
        .toolbar(content: {
            Button(action: filter) {
                Image(systemName: "calendar")
            }
        })
    }
}

struct WalletView_Previews: PreviewProvider {
    @State static var dumb_data = DumbData().wallet

    static var previews: some View {
        WalletView(wallet: $dumb_data)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 12 Pro")
    }
}