import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "A1" asset catalog image resource.
    static let A_1 = ImageResource(name: "A1", bundle: resourceBundle)

    /// The "CS" asset catalog image resource.
    static let CS = ImageResource(name: "CS", bundle: resourceBundle)

    /// The "GateIN" asset catalog image resource.
    static let gateIN = ImageResource(name: "GateIN", bundle: resourceBundle)

    /// The "GateOUT" asset catalog image resource.
    static let gateOUT = ImageResource(name: "GateOUT", bundle: resourceBundle)

    /// The "Group 15" asset catalog image resource.
    static let group15 = ImageResource(name: "Group 15", bundle: resourceBundle)

    /// The "Group 17" asset catalog image resource.
    static let group17 = ImageResource(name: "Group 17", bundle: resourceBundle)

    /// The "Group 2" asset catalog image resource.
    static let group2 = ImageResource(name: "Group 2", bundle: resourceBundle)

    /// The "Late" asset catalog image resource.
    static let late = ImageResource(name: "Late", bundle: resourceBundle)

    /// The "Notification" asset catalog image resource.
    static let notification = ImageResource(name: "Notification", bundle: resourceBundle)

    /// The "TA" asset catalog image resource.
    static let TA = ImageResource(name: "TA", bundle: resourceBundle)

    /// The "Vector" asset catalog image resource.
    static let vector = ImageResource(name: "Vector", bundle: resourceBundle)

    /// The "c1" asset catalog image resource.
    static let c1 = ImageResource(name: "c1", bundle: resourceBundle)

    /// The "g1" asset catalog image resource.
    static let g1 = ImageResource(name: "g1", bundle: resourceBundle)

    /// The "gd1" asset catalog image resource.
    static let gd1 = ImageResource(name: "gd1", bundle: resourceBundle)

    /// The "gd2" asset catalog image resource.
    static let gd2 = ImageResource(name: "gd2", bundle: resourceBundle)

    /// The "gd3" asset catalog image resource.
    static let gd3 = ImageResource(name: "gd3", bundle: resourceBundle)

    /// The "logopic" asset catalog image resource.
    static let logopic = ImageResource(name: "logopic", bundle: resourceBundle)

    /// The "marker" asset catalog image resource.
    static let marker = ImageResource(name: "marker", bundle: resourceBundle)

    /// The "p1" asset catalog image resource.
    static let p1 = ImageResource(name: "p1", bundle: resourceBundle)

    /// The "power" asset catalog image resource.
    static let power = ImageResource(name: "power", bundle: resourceBundle)

    /// The "users-gear 1" asset catalog image resource.
    static let usersGear1 = ImageResource(name: "users-gear 1", bundle: resourceBundle)

    /// The "write" asset catalog image resource.
    static let write = ImageResource(name: "write", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "A1" asset catalog image.
    static var A_1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .A_1)
#else
        .init()
#endif
    }

    /// The "CS" asset catalog image.
    static var CS: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .CS)
#else
        .init()
#endif
    }

    /// The "GateIN" asset catalog image.
    static var gateIN: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gateIN)
#else
        .init()
#endif
    }

    /// The "GateOUT" asset catalog image.
    static var gateOUT: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gateOUT)
#else
        .init()
#endif
    }

    /// The "Group 15" asset catalog image.
    static var group15: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .group15)
#else
        .init()
#endif
    }

    /// The "Group 17" asset catalog image.
    static var group17: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .group17)
#else
        .init()
#endif
    }

    /// The "Group 2" asset catalog image.
    static var group2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .group2)
#else
        .init()
#endif
    }

    /// The "Late" asset catalog image.
    static var late: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .late)
#else
        .init()
#endif
    }

    /// The "Notification" asset catalog image.
    static var notification: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .notification)
#else
        .init()
#endif
    }

    /// The "TA" asset catalog image.
    static var TA: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .TA)
#else
        .init()
#endif
    }

    /// The "Vector" asset catalog image.
    static var vector: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .vector)
#else
        .init()
#endif
    }

    /// The "c1" asset catalog image.
    static var c1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c1)
#else
        .init()
#endif
    }

    /// The "g1" asset catalog image.
    static var g1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .g1)
#else
        .init()
#endif
    }

    /// The "gd1" asset catalog image.
    static var gd1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gd1)
#else
        .init()
#endif
    }

    /// The "gd2" asset catalog image.
    static var gd2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gd2)
#else
        .init()
#endif
    }

    /// The "gd3" asset catalog image.
    static var gd3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gd3)
#else
        .init()
#endif
    }

    /// The "logopic" asset catalog image.
    static var logopic: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logopic)
#else
        .init()
#endif
    }

    /// The "marker" asset catalog image.
    static var marker: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .marker)
#else
        .init()
#endif
    }

    /// The "p1" asset catalog image.
    static var p1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .p1)
#else
        .init()
#endif
    }

    /// The "power" asset catalog image.
    static var power: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .power)
#else
        .init()
#endif
    }

    /// The "users-gear 1" asset catalog image.
    static var usersGear1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .usersGear1)
#else
        .init()
#endif
    }

    /// The "write" asset catalog image.
    static var write: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .write)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "A1" asset catalog image.
    static var A_1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .A_1)
#else
        .init()
#endif
    }

    /// The "CS" asset catalog image.
    static var CS: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .CS)
#else
        .init()
#endif
    }

    /// The "GateIN" asset catalog image.
    static var gateIN: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gateIN)
#else
        .init()
#endif
    }

    /// The "GateOUT" asset catalog image.
    static var gateOUT: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gateOUT)
#else
        .init()
#endif
    }

    /// The "Group 15" asset catalog image.
    static var group15: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .group15)
#else
        .init()
#endif
    }

    /// The "Group 17" asset catalog image.
    static var group17: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .group17)
#else
        .init()
#endif
    }

    /// The "Group 2" asset catalog image.
    static var group2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .group2)
#else
        .init()
#endif
    }

    /// The "Late" asset catalog image.
    static var late: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .late)
#else
        .init()
#endif
    }

    /// The "Notification" asset catalog image.
    static var notification: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .notification)
#else
        .init()
#endif
    }

    /// The "TA" asset catalog image.
    static var TA: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .TA)
#else
        .init()
#endif
    }

    /// The "Vector" asset catalog image.
    static var vector: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .vector)
#else
        .init()
#endif
    }

    /// The "c1" asset catalog image.
    static var c1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c1)
#else
        .init()
#endif
    }

    /// The "g1" asset catalog image.
    static var g1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .g1)
#else
        .init()
#endif
    }

    /// The "gd1" asset catalog image.
    static var gd1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gd1)
#else
        .init()
#endif
    }

    /// The "gd2" asset catalog image.
    static var gd2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gd2)
#else
        .init()
#endif
    }

    /// The "gd3" asset catalog image.
    static var gd3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gd3)
#else
        .init()
#endif
    }

    /// The "logopic" asset catalog image.
    static var logopic: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logopic)
#else
        .init()
#endif
    }

    /// The "marker" asset catalog image.
    static var marker: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .marker)
#else
        .init()
#endif
    }

    /// The "p1" asset catalog image.
    static var p1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .p1)
#else
        .init()
#endif
    }

    /// The "power" asset catalog image.
    static var power: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .power)
#else
        .init()
#endif
    }

    /// The "users-gear 1" asset catalog image.
    static var usersGear1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .usersGear1)
#else
        .init()
#endif
    }

    /// The "write" asset catalog image.
    static var write: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .write)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Hashable {

    /// An asset catalog color resource name.
    fileprivate let name: String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Hashable {

    /// An asset catalog image resource name.
    fileprivate let name: String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif