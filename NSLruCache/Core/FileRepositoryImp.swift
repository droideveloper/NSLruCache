//
//  FileRepositoryImp.swift
//  NSLruCache
//
//  Created by Fatih Şen on 11.11.2018.
//  Copyright © 2018 Fatih Şen. All rights reserved.
//

import Foundation

class FileRepositoryImp: FileRepository {
	
	private let decoder = JSONDecoder()
	private let endcoder = JSONEncoder()
	
	private let fileManager = FileManager.default
	
	func read<T>(url: URL, type: T.Type) throws -> T? where T: Codable {
		guard fileManager.fileExists(atPath: url.path) else {
			return nil
		}
		
		guard let data = fileManager.contents(atPath: url.path) else {
			return nil
		}
	
		return try decoder.decode(type, from: data)
	}
	
	func write<T>(url: URL, data: T) throws where T: Codable {
		if fileManager.fileExists(atPath: url.path) {
			try fileManager.removeItem(at: url)
		}
		
		let data = try endcoder.encode(data)
		fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
	}
	
	func evict(url: URL) throws -> Data? {
		return try Data(contentsOf: url)
	}
	
	func put(url: URL, data: Data) throws {
		try data.write(to: url)
	}
}
