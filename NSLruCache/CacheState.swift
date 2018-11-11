//
//  CacheState.swift
//  NSLruCache
//
//  Created by Fatih Şen on 11.11.2018.
//  Copyright © 2018 Fatih Şen. All rights reserved.
//

import Foundation

public enum CacheState: Int, Codable {
	case valid
	case dirty
	case invalid
}
