//
//  CacheExpiry.swift
//  NSLruCache
//
//  Created by Fatih Şen on 11.11.2018.
//  Copyright © 2018 Fatih Şen. All rights reserved.
//

import Foundation

struct CacheExpiry: Codable {
	
	var expiry: Expiry
	var interval: Date
	
	func copy(expiry: Expiry? = nil, interval: Date? = nil) -> CacheExpiry {
		return CacheExpiry(expiry: expiry ?? self.expiry, interval: interval ?? self.interval)
	}
	
	enum Expiry: Int, Codable {
		case never
		case seconds
		case date
	}
	
	static func by(expiry: Expiry, and distance: TimeInterval? = nil) -> CacheExpiry {
		switch expiry {
		case .never:
			return CacheExpiry(expiry: .never, interval: Date.distantFuture)
		case .seconds, .date:
			return CacheExpiry(expiry: .seconds, interval: Date().addingTimeInterval(distance ?? 0))
		}
	}
}
