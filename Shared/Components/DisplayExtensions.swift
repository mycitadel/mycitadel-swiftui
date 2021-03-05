//
//  DisplayExtensions.swift
//  My Citadel
//
//  Created by Maxim Orlovsky on 2/23/21.
//

import SwiftUI
import MyCitadelKit

extension BitcoinNetwork {
    var localizedDescription: String {
        switch self {
        case .mainnet: return "Bitcoin mainnet"
        case .testnet: return "Bitcoin testnet"
        case .signet: return "Bitcoin signet"
        }
    }
    
    var localizedSats: String {
        switch self {
        case .mainnet: return "Sats."
        default: return "tSats."
        }
    }

    var localizedSatoshis: String {
        switch self {
        case .mainnet: return "Satoshis"
        default: return "Testnet satoshis"
        }
    }
}

extension AssetCategory {
    var localizedDescription: String {
        switch self {
        case .currency:
            return "Ditial currency"
        case .stablecoin:
            return "Stable coin"
        case .token:
            return "Fungible asset"
        case .nft:
            return "Non-fungible token"
        }
    }

    func primaryColor() -> Color {
        switch self {
        case .currency: return Color.orange
        case .stablecoin: return Color.green
        case .token: return Color.red
        case .nft: return Color.blue
        }
    }
    
    func secondaryColor() -> Color {
        switch self {
        case .currency: return Color.yellow
        case .stablecoin: return Color(.sRGB, red: 0.333, green: 1, blue: 0.333, opacity: 1)
        case .token: return Color.purple
        case .nft: return Color(.sRGB, red: 0.333, green: 0.333, blue: 1, opacity: 1)
        }
    }
}

extension Asset {
    public var gradient: Gradient {
        Gradient(colors: [self.category.primaryColor(), self.category.secondaryColor()])
    }

    public var symbol: String {
        switch category {
        case .currency: return "bitcoinsign.circle.fill"
        case .stablecoin: return "dollarsign.circle.fill"
        case .token: return "arrowtriangle.down.circle.fill"
        case .nft: return "arrowtriangle.down"
        }
    }
    
    public var formattedBalance: String {
        "\(balance.total) \(ticker)"
    }
    
    public func formattedSupply(metric: SupplyMetric) -> String {
        "\(supply(metric: metric) ?? 0) \(ticker)"
    }

    public var localizedIssuer: String {
        isNative ? "Decentralized consensus on \(network.localizedDescription) blockchain" : "Trusted centralized party"
    }
}

extension AssetAuthenticity {
    public var symbol: String {
        status.verifiedSymbol
    }
    
    public var color: Color {
        status.verifiedColor
    }
}

extension VerificationStatus {
    public var localizedString: String {
        switch self {
        case .publicTruth: return "Public fact"
        case .verified: return "Verified"
        case .unverified: return "Unverified"
        }
    }
    
    public var verifiedSymbol: String {
        self.isVerified() ? "checkmark.seal.fill" : "xmark.seal"
    }
    
    public var verifiedColor: Color {
        switch self {
        case .publicTruth: return .blue
        case .verified: return .green
        case .unverified: return .orange
        }
    }
}

public struct Transaction: Identifiable {
    public var id: String
    public var asset: Asset
}

extension WalletContract {
    var transactions: [Transaction] {
        []
    }
    
    public var imageName: String {
        self.policy.contractType.imageName
    }
    
    public var contractType: ContractType {
        self.policy.contractType
    }
}

extension Policy {
    public var contractType: ContractType {
        switch self {
        case .current(_): return .current
        }
    }
}

extension Balance {
    public var fiatBalance: Double {
        0
    }
    public var btcBalance: Double {
        0
    }
}

public enum ContractType: Int, Identifiable {
    case current = 1
    case saving = 2
    case instant = 3
    case storm = 4
    case prometheus = 5
    case trading = 6
    case staking = 7
    case liquidity = 8

    public var id: ContractType {
        self
    }

    public var imageName: String {
        switch self {
        case .current: return "banknote"
        case .saving: return "building.columns.fill"
        case .instant: return "bolt.fill"
        case .storm: return "cloud.bolt.rain.fill"
        case .prometheus: return "cpu"
        case .trading: return "arrow.left.arrow.right.circle.fill"
        case .staking: return "square.stack.3d.up.fill"
        case .liquidity: return "drop.fill"
        }
    }
    
    public var localizedName: String {
        switch self {
        case .current: return "Current account"
        case .saving: return "Saving account"
        case .instant: return "Instant payments (Lightning)"
        case .storm: return "Data storage"
        case .prometheus: return "Computing"
        case .trading: return "Trading"
        case .staking: return "Staking"
        case .liquidity: return "Liquidity provider / DEX"
        }
    }

    public var localizedDescription: String {
        switch self {
        case .current: return "This is a “normal” bitcoin or digital assets wallet account, suitable for on-chain payments. Accounts of this type may be a single-signature (personal) or multi-signatures (for corporate/family use). Also, power users or enterprise customers will be able to write custom lock times and other conditions with miniscript. However, if you are looking for HODLing we advise you to look at the next type of accounts: saving account; since current accounts are mostly used for paying activities and their private keys are usually kept in the hot state."
        case .saving: return "This is for true HODlers! Saving accounts always keep private keys cold + in the future will support conventants, once CLV will happen!"
        case .instant: return "Fast & cheap micropayments with lightning channels of different sorts: unilaterally funded channels, bilateraly funded channels, channel factories, RGB-asset enabled channels – we have all of them"
        case .storm: return "Data storage"
        case .prometheus: return "Computing"
        case .trading: return "Use decentralized exchange functionality of the lightning network to do cheap & efficient trading operations"
        case .staking: return "Put your bitcoins & digital assets into a liquidity pool at the lightning node and earn your part of the fees from the node operating as a part of the decentralized exchange"
        case .liquidity: return "Operate your lightning node as a part of the decentralized exchange by providing your node liquidity to the network – and maintain a liquidity pool to earn more fees"
        }
    }
    
    public var enabled: Bool {
        switch self {
        case .current: return true
        default: return false
        }
    }
    
    public var primaryColor: Color {
        switch self {
        case .current: return Color.orange
        case .saving: return Color.green
        case .instant: return Color.red
        default: return Color.blue
        }
    }
    
    public var secondaryColor: Color {
        switch self {
        case .current: return Color.yellow
        case .saving: return Color(.sRGB, red: 0.333, green: 1, blue: 0.333, opacity: 1)
        case .instant: return Color.purple
        default: return Color(.sRGB, red: 0.333, green: 0.333, blue: 1, opacity: 1)
        }
    }
    
    public var gradient: Gradient {
        Gradient(colors: [self.primaryColor, self.secondaryColor])
    }
}