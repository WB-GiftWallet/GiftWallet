//
//  EXT+UIViewController.swift
//  GiftWallet
//
//  Created by 서현웅 on 2023/02/21.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI
extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func showPreview() -> some View {
        Preview(viewController: self).previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
#endif
