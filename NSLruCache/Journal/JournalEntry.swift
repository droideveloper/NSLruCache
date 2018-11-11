//
//  JournalEntry.swift
//  NSLruCache
//
//  Created by Fatih Şen on 11.11.2018.
//  Copyright © 2018 Fatih Şen. All rights reserved.
//

import Foundation

struct JournalEntry: Codable {
	
	var expiry: CacheExpiry
	var state: CacheState
	var hash: Int64
	var size: Int64
	
	func copy(expiry: CacheExpiry? = nil,
					  state: CacheState? = nil,
					  hash: Int64? = nil,
					  size: Int64? = nil) -> JournalEntry {
		return JournalEntry(expiry: expiry ?? self.expiry,
												state: state ?? self.state,
												hash: hash ?? self.hash,
												size: size ?? self.size)
	}
}
