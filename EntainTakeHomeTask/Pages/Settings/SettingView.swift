//
//  SettingView.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/13.
//

import SwiftUI

struct NavBarAccessor: UIViewControllerRepresentable {
    var callback: (UINavigationBar) -> Void
    private let proxyController = ViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavBarAccessor>) ->
    UIViewController {
        proxyController.callback = callback
        return proxyController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavBarAccessor>) {
    }
    
    typealias UIViewControllerType = UIViewController
    
    private class ViewController: UIViewController {
        var callback: (UINavigationBar) -> Void = { _ in }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let navBar = self.navigationController {
                self.callback(navBar.navigationBar)
            }
        }
    }
}

extension UIFont {
    class func preferredFont(from font: Font) -> UIFont {
        let style: UIFont.TextStyle =
        switch font {
        case .largeTitle:   .largeTitle
        case .title:        .title1
        case .title2:       .title2
        case .title3:       .title3
        case .headline:     .headline
        case .subheadline:  .subheadline
        case .callout:      .callout
        case .caption:      .caption1
        case .caption2:     .caption2
        case .footnote:     .footnote
        default: /*.body */ .body
        }
        return  UIFont.preferredFont(forTextStyle: style)
    }
}

// MARK: Corner Radius
private struct RoundedCornersRectangle: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path (in rect: CGRect) -> Path {
        let cornerRadii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius( radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornersRectangle(radius: radius, corners: corners))
    }
}

struct SettingView: View {
    
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    func getGradientColor(title: String, titleFont: Font) -> Color {
        var gradientColor = UIColor(Theme.headerText)
        let blue = UIColor.systemBlue
        let purple = UIColor.systemPurple
        
        let titleUIFont = UIFont.preferredFont(from: titleFont)
        
        let size = title.size(withAttributes: [.font : titleUIFont])
        let gradient = CAGradientLayer()
        
        let textStyle = UIFont.TextStyle(rawValue: titleUIFont.fontDescriptor.fontAttributes[.textStyle] as? String ?? "")
        
        let bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: UIFont.preferredFont(forTextStyle: textStyle).pointSize))
        gradient.frame = bounds
        gradient.colors = [blue.cgColor, purple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        
        if let image = getImageFrom(gradientLayer: gradient) {
            gradientColor = UIColor(patternImage: image)
        }
        return Color(gradientColor)
    }
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    KeyboardTypesView()
                } label: {
                    Text("Keyboard types")
                        .font(.body)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.red, .blue, .green, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                NavigationLink {
                    GameView()
                } label: {
                    Text("Game")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Theme.headerText)
                }
                
                Button(action: {}, label: {
                    Text("Button")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Theme.lightAccentColor)
                        .cornerRadius(radius: 8, corners: UIRectCorner([.topLeft, .bottomRight]))
                        .cornerRadius(radius: 30, corners: UIRectCorner([.bottomLeft, .topRight]))
                })
            }
            .background(content: {
                NavBarAccessor { naviBar in
                    print(">> TabBar height: \(naviBar.bounds.height)")
                }
            })
            .navigationTitle("Hodgepodge")
        }
    }
}

#Preview {
    SettingView()
}
