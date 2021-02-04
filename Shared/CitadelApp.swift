//
//  My_CitadelApp.swift
//  Shared
//
//  Created by Maxim Orlovsky on 11/16/20.
//

import SwiftUI
import MyCitadelKit

public func generateQRCode(from string: String) -> Image {
    let data = string.data(using: String.Encoding.ascii)

    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)

        if let output = filter.outputImage?.transformed(by: transform) {
            return Image(uiImage: UIImage(ciImage: output))
        }
    }

    return Image(systemName: "xmark.square")
}

private struct CurrencyEnvironmentKey: EnvironmentKey {
    static let defaultValue: String = "USD"
}

extension EnvironmentValues {
    public var currencyUoA: String {
        get { self[CurrencyEnvironmentKey.self] }
        set { self[CurrencyEnvironmentKey.self] = newValue }
    }
}

@main
struct CitadelApp: App {
    @State private var data = DumbData().data
    @State private var showingAlert = false
    @State private var alertMessage: String?
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(data: $data).onAppear(perform: load).alert(isPresented: $showingAlert) {
                Alert(title: Text("Failed to initialize MyCitadel node"), message: Text(alertMessage!))
            }
        }
    }
    
    private func load() {
        if let err = MyCitadelClient.shared?.lastError() {
            self.showingAlert = true
            self.alertMessage = err.localizedDescription
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        try! MyCitadelClient.run()
        return true
    }
}
