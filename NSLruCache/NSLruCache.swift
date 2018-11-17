//
//  NSLruCache.swift
//  NSLruCache
//
//  Created by Fatih Şen on 11.11.2018.
//  Copyright © 2018 Fatih Şen. All rights reserved.
//

import Foundation
import UIKit

public class NSLruCache {
	
	private let decoder = JSONDecoder()
	private let encoder = JSONEncoder()
	private let fileManager = FileManager.default
	private let queue = DispatchQueue(label: String(describing: NSLruCache.self), attributes: DispatchQueue.Attributes.concurrent)
	
	private let cacheSize: Int64
	private let cacheStrategy: NSLruCacheStrategy
	
	private var entries = Array<JournalEntry>()
	private var memory = Dictionary<JournalEntry, UIImage>()
	
	private var cacheDirectory: URL?
	private var cacheJournalFile: URL?
	private var cacheImagesDirectory: URL?
	
	/// Default initializer
	/// param cacheSize will provide 64mb cache size
	/// param cacheStrategy will provide both memory and disk caching options
	public init(cacheSize: Int64 = 1024 * 1024 * 64, cacheStrategy: NSLruCacheStrategy = .all) {
		self.cacheSize = cacheSize
		self.cacheStrategy = cacheStrategy
		self.cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
		self.cacheJournalFile = cacheDirectory?.appendingPathComponent("journal.jrl")
		self.cacheImagesDirectory = cacheDirectory?.appendingPathComponent("images", isDirectory: true)
		// read journal
		queue.sync { [weak weakSelf = self] in
			do {
				if let url = weakSelf?.cacheJournalFile {
					weakSelf?.entries = try read(url: url, type: [JournalEntry].self)
				}
				for key in weakSelf?.entries ?? [] {
					if let url = weakSelf?.cacheImagesDirectory?.appendingPathComponent("\(key.hash).jrl") {
					  let data = try Data(contentsOf: url)
						memory[key] = UIImage(data: data)
					}
 				}
			} catch {
				// TODO Log if build type is DEBUG
			}
		}
	}
	
	private func write<T>(url: URL, data: T) throws where T: Codable {
		if fileManager.fileExists(atPath: url.path) {
			try fileManager.removeItem(at: url)
		}
		let data = try encoder.encode(data)
		fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
	}
	
	private func read<T>(url: URL, type: T.Type) throws -> T where T: Codable {
		if fileManager.fileExists(atPath: url.path) {
			if let data = fileManager.contents(atPath: url.path) {
				return try decoder.decode(type, from: data)
			}
			throw NSError.create("io error occured while reading file at \(url.path)", code: 401)
		}
		throw NSError.create("We could not find jorunal file at \(url.path)", code: 404)
	}
	
	private func persist() throws {
		for (key, value) in memory {
			if let url = cacheImagesDirectory?.appendingPathComponent("\(key.hash).jrl") {
				if key.state == .dirty || key.state == .invalid {
					if fileManager.fileExists(atPath: url.path) {
						memory.removeValue(forKey: key)
						try fileManager.removeItem(at: url)
					}
					if key.state == .dirty {
						let k = key.copy(state: .valid)
						memory[k] = value
						if let data = value.pngData() {
							try data.write(to: url)
						} else if let data = value.jpegData(compressionQuality: 1.0) {
							try data.write(to: url)
						}
					}
				} else if key.state == .valid {
					if !fileManager.fileExists(atPath: url.path) {
						if let data = value.pngData() {
							try data.write(to: url)
						} else if let data = value.jpegData(compressionQuality: 1.0) {
							try data.write(to: url)
						}
					}
				}
			}
		}
	}
	
	deinit {
		
	}
}
