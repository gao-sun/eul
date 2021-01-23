//
//  IOHelper.swift
//  eul
//
//  Created by Gao Sun on 2021/1/23.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Foundation

enum IOHelper {
    static func getProperties(entry: io_object_t) -> NSDictionary? {
        var serviceDict: Unmanaged<CFMutableDictionary>?

        defer {
            serviceDict?.release()
        }

        if IORegistryEntryCreateCFProperties(entry, &serviceDict, kCFAllocatorDefault, 0) != kIOReturnSuccess {
            return nil
        }

        return serviceDict?.takeUnretainedValue()
    }

    static func getPropertyList(for service: String) -> [NSDictionary]? {
        var iterator = io_iterator_t()

        defer {
            IOObjectRelease(iterator)
        }

        guard IOServiceGetMatchingServices(
            kIOMasterPortDefault,
            IOServiceMatching(service),
            &iterator
        ) == kIOReturnSuccess else {
            return nil
        }

        var propertyList = [NSDictionary]()
        var entry = IOIteratorNext(iterator)

        while entry != 0 {
            if let properties = getProperties(entry: entry) {
                propertyList.append(properties)
            }
            IOObjectRelease(entry)
            entry = IOIteratorNext(entry)
        }

        return propertyList
    }
}
