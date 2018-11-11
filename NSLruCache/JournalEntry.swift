//
//  JournalEntry.swift
//  NSLruCache
//
//  Created by Fatih Şen on 11.11.2018.
//  Copyright © 2018 Fatih Şen. All rights reserved.
//

import Foundation

public struct JournalEntry: Codable {
	
	public var expiry: CacheExpiry
	public var state: CacheState
	public var key: String
	public var hash: Int64
	public var url: URL
	
	public func copy(expiry: CacheExpiry? = nil,
									 state: CacheState? = nil,
									 key: String? = nil,
									 hash: Int64? = nil,
									 url: URL? = nil) -> JournalEntry {
		return JournalEntry(expiry: expiry ?? self.expiry,
												state: state ?? self.state,
												key: key ?? self.key,
												hash: hash ?? self.hash,
												url: url ?? self.url)
	}
}
