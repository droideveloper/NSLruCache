//
//  FileRepository.swift
//  NSLruCache
//
//  Created by Fatih Şen on 11.11.2018.
//  Copyright © 2018 Fatih Şen. All rights reserved.
//

import Foundation

protocol FileRepository {
	func read<T>(url: URL, type: T.Type) throws -> T? where T: Codable
	func write<T>(url: URL, data: T) throws where T: Codable
	func put(url: URL, data: Data) throws
	func evict(url: URL) throws -> Data?
}
