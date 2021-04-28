//
//  ToastMessageService.swift
//  NemligApp
//
//  Created by Yaromyr Oleksyshyn on 30.03.2021.
//  Copyright © 2021 NEMLIG.COM A/S. All rights reserved.
//

import UIKit

protocol ToastMessageService {

	/// Shows a ToastMessageView in a new UIWindow with specifed info
	///
	/// - Parameter info: Specified information for the toast
	/// - Parameter topOffset: Used for setting a top offset on iPad.
	/// - Parameter topOffset: Used for setting a bottom offset on iPhone.
	func showToast(_ info: ToastMessageInfo, topOffset: CGFloat?, bottomOffset: CGFloat?)

	/// Calculates an offset for cases when there is a navigation controller
	///
	/// - Parameter navigationController: a current navigation controller
	/// - Parameter window: a window that holds a current view
	func topOffset(for navigationController: UINavigationController?, in window: UIWindow?) -> CGFloat?
}
