// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum Asset: String {
  case selected = "selected"
  case unselected = "unselected"
  case first = "first"
  case list = "list"
  case headlineIcon = "headline_icon"
  case scan = "scan"
  case search = "search"
  case defaultSplashNew = "default_splash_new"
  case defaultSplash = "default_splash"
  case aboutUs = "about_us"
  case addToCart = "add_to_cart"
  case addressManager = "address_manager"
  case camera = "camera"
  case defaultAvatar = "default_avatar"
  case deleteRed = "delete_red"
  case delete = "delete"
  case downArrow = "down_arrow"
  case expertAvatar = "expert_avatar"
  case expert = "expert"
  case favoritedHeadlines = "favorited_headlines"
  case favoritedProducts = "favorited_products"
  case health = "health"
  case hotlinePhone = "hotline_phone"
  case hotline = "hotline"
  case noOrders = "no_orders"
  case profile = "profile"
  case qq = "qq"
  case setting = "setting"
  case starSelected = "star_selected"
  case star = "star"
  case viewedHeadlines = "viewed_headlines"
  case viewedProducts = "viewed_products"
  case waitForComment = "wait_for_comment"
  case waitForDeliver = "wait_for_deliver"
  case waitForPay = "wait_for_pay"
  case waitForReceive = "wait_for_receive"
  case wechat = "wechat"
  case address = "address"
  case cart = "cart"
  case customService = "custom_service"
  case favorited = "favorited"
  case more = "more"
  case next = "next"
  case seperator = "seperator"
  case share = "share"
  case toTop = "to_top"
  case unfavorited = "unfavorited"
  case second = "second"
  case cartTabSelected = "cart_tab_selected"
  case cartTab = "cart_tab"
  case groupTabSelected = "group_tab_selected"
  case groupTab = "group_tab"
  case headlineTabSelected = "headline_tab_selected"
  case headlineTab = "headline_tab"
  case homeTabSelected = "home_tab_selected"
  case homeTab = "home_tab"
  case myTabSelected = "my_tab_selected"
  case myTab = "my_tab"

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: rawValue, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: rawValue)
    #elseif os(watchOS)
    let image = Image(named: rawValue)
    #endif
    guard let result = image else { fatalError("Unable to load image \(rawValue).") }
    return result
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: Asset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
    #elseif os(OSX) || os(watchOS)
    self.init(named: asset.rawValue)
    #endif
  }
}

private final class BundleToken {}
