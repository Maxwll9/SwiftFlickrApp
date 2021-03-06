//
//  ComposeCommentViewController.swift
//  Flickr
//
//  Created by Maxim Nasakin on 08/07/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import UIKit

final class ComposeCommentViewController: UIViewController {
	var viewModel: ComposeCommentViewModel!
	
	@IBOutlet var commentTextView: UITextView!
}

// MARK: IBActions
extension ComposeCommentViewController {
	@IBAction func sendComment(sender: AnyObject) {
		viewModel.addComment(commentTextView.text) { [weak self] result in
			let alertTitle = (result) ? "Success!" : "ERROR"
			let alertMessage = (result) ? "The message was successfully sent" : "Something went wrong"
			
			let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
			let action = UIAlertAction(title: "OK", style: .Default) { _ in
				self?.dismissViewControllerAnimated(true, completion: nil)
			}
			
			alert.addAction(action)
			self?.presentViewController(alert, animated: true, completion: nil)
		}
	}
}

// MARK: View lifecycle
extension ComposeCommentViewController {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard viewModel.didSend else { return }
		
		let destinationVC = segue.destinationViewController as? PhotoDetailTableViewController
		destinationVC?.refresh()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		commentTextView.becomeFirstResponder()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupKeyboardNotifications()
	}
}

// MARK: Setup Keyboard
extension ComposeCommentViewController {
	private func setupKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeCommentViewController.keyboardWasShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeCommentViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func keyboardWasShown(aNotification: NSNotification) {
		let info = aNotification.userInfo
		let infoNSValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue
		let kbSize = infoNSValue.CGRectValue().size
		let contentBottomInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0).bottom
		commentTextView.contentInset.bottom = contentBottomInsets
		commentTextView.scrollIndicatorInsets.bottom = contentBottomInsets
	}
	
	func keyboardWillBeHidden(aNotification: NSNotification) {
		let contentBottomInsets = UIEdgeInsetsZero.bottom
		commentTextView.contentInset.bottom = contentBottomInsets
		commentTextView.scrollIndicatorInsets.bottom = contentBottomInsets
	}
}
