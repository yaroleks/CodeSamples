//
//  ToastManager.swift
//
//  Created by Yaromyr Oleksyshyn on 30.03.2021.


import Foundation
import UIKit

private struct Constants {
	var windowMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
}

final class ToastMessageManager: ToastMessageService {

	// MARK: - Properties
	private var toastMessageController: ToastPresentingViewController?
	private var toastMessageWindow: UIWindow?
	private var constants = Constants()

	// MARK: - Public functions
	func showToast(_ info: ToastMessageInfo, topOffset: CGFloat?, bottomOffset: CGFloat?) {
		let toast = toastMessageView(info)
		setupWindow(toast, topOffset: topOffset, bottomOffset: bottomOffset)
		setupToastMessageController(info)
	}

	func topOffset(for navigationController: UINavigationController?, in window: UIWindow?) -> CGFloat? {
		guard let navigationController = navigationController,
			  let window = window else {
			return nil
		}
		let maxY = navigationController.navigationBar.frame.maxY

		let origin = CGPoint(x: 0, y: maxY)
		return navigationController.view.convert(origin, to: window).y
	}

	// MARK: - Private functions
	private func toastMessageView(_ info: ToastMessageInfo) -> ToastMessageView {
		let toast = ToastMessageView.loadFromNib()
		toast.setupWith(info)
		return toast
	}

	private func toastSize(_ toast: ToastMessageView, _ margins: UIEdgeInsets) -> CGSize {
		let width: CGFloat

		if UIDevice.isPhone {
			width = UIScreen.main.bounds.width - margins.left - margins.right
		}
		else {
			width = ToastPresentingViewController.Constraints.width.value
		}

		let size = CGSize(
			width: width,
			height: UIView.layoutFittingCompressedSize.height
		)
		var viewSize = toast.systemLayoutSizeFitting(
			size,
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel
		)
		let verticalSpacing = UIDevice.isPhone ? ToastPresentingViewController.Constraints.iPhoneVerticalSpacing.value :
			ToastPresentingViewController.Constraints.iPadVerticalSpacing.value
		viewSize.height += verticalSpacing

		return viewSize
	}

	private func windowFrame(_ toast: ToastMessageView, topOffset: CGFloat?, bottomOffset: CGFloat?) -> CGRect {
		let margin = constants.windowMargins
		let viewSize = toastSize(toast, margin)

		let originX: CGFloat
		let originY: CGFloat

		if UIDevice.isPhone {
			// Display on the bottom screen
			originX = margin.left
			originY = UIScreen.main.bounds.maxY - viewSize.height - (bottomOffset ?? 0)
		}
		else {
			// Display on the top right corner
			originX = UIScreen.main.bounds.maxX - viewSize.width - margin.right
			originY = topOffset ?? margin.top
		}

		let origin = CGPoint(x: originX, y: originY)

		return CGRect(origin: origin, size: viewSize)
	}

	private func setupWindow(_ toast: ToastMessageView, topOffset: CGFloat?, bottomOffset: CGFloat?) {
		toastMessageWindow = UIWindow(frame:
			windowFrame(
				toast,
				topOffset: topOffset,
				bottomOffset: bottomOffset)
		)
		toastMessageWindow?.windowLevel = UIWindow.Level(
			rawValue: CGFloat.greatestFiniteMagnitude
		)

		toastMessageWindow?.isHidden = false
		toastMessageWindow?.isUserInteractionEnabled = true
	}

	private func setupToastMessageController(_ info: ToastMessageInfo) {
		toastMessageController = ToastPresentingViewController(info: info)
		toastMessageController?.closeCompletion = { [weak self] in
			self?.toastMessageWindow = nil
		}
		toastMessageWindow?.rootViewController = toastMessageController
	}
}

// MARK: - Extension: NML + ToastMessageService
extension NML {
	class func setToastMessageService(_ toastMessageService: ToastMessageService) {
		register(ToastMessageService.self, service: toastMessageService)
	}

	class var toastMessageService: ToastMessageService {
		return resolve(ToastMessageService.self)
	}
}
