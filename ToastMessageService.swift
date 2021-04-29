//
//  ToastMessageService.swift
//
//  Created by Yaromyr Oleksyshyn on 30.03.2021.
//

import UIKit

protocol ToastMessageService {

	/// Shows a ToastMessageView in a new UIWindow with specifed info
	///
	/// - Parameter info: Specified information for the toast
	/// - Parameter topOffset: Used for setting a top offset on iPad.
	/// - Parameter topOffset: Used for setting a bottom offset on iPhone.
	func showToast(_ info: ToastMessageInfo, topOffset: CGFloat?, bottomOffset: CGFloat?)
}

extension ToastMessageService {
	
	/// Calculates an offset for cases when there is a navigation controller
	///
	/// - Parameter navigationController: a current navigation controller
	/// - Parameter window: a window that holds a current view
	func topOffset(for navigationController: UINavigationController?, in window: UIWindow?) -> CGFloat? {
		func topOffset(for navigationController: UINavigationController?, in window: UIWindow?) -> CGFloat? {
		guard let navigationController = navigationController,
			  let window = window else {
			return nil
		}
		let maxY = navigationController.navigationBar.frame.maxY

		let origin = CGPoint(x: 0, y: maxY)
		return navigationController.view.convert(origin, to: window).y
		}
	}
}
