//
//  CacheExpiry.swift
//  NSLruCache
//
//  Created by Fatih Şen on 11.11.2018.
//  Copyright © 2018 Fatih Şen. All rights reserved.
//

import Foundation

public struct CacheExpiry: Codable {
	
	public var expiry: Expiry
	public var interval: Date
	
	public enum Expiry: Int, Codable {
		case never
		case seconds
		case date
	}
}
