//
//  NSError+Extension.swift
//  NSLruCache
//
//  Created by Fatih Şen on 12.11.2018.
//  Copyright © 2018 Fatih Şen. All rights reserved.
//

import Foundation

public extension NSError {
	
	public static func create(_ description: String = String.empty, code: Int = 404) -> Error {
		return NSError(domain: description, code: code, userInfo: nil)
	}
}
