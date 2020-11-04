//
//  String.swift
//  eul
//
//  Created by Gao Sun on 2020/8/9.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

extension String {
    static func getValue(of column: String, in values: [String], of headers: [String]) -> String? {
        guard
            let index = headers.firstIndex(where: { $0.lowercased() == column }),
            values.indices.contains(index)
        else {
            return nil
        }
        return values[index]
    }

    func titleCase() -> String {
        replacingOccurrences(of: "([A-Z])",
                             with: " $1",
                             options: .regularExpression,
                             range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }

    var splittedByWhitespace: [String] {
        guard let trimWhiteSpaceRegEx = try? NSRegularExpression(pattern: "/ +/g") else {
            return []
        }
        let trimmed = trimWhiteSpaceRegEx.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: count),
            withTemplate: " "
        )
        return trimmed.split(separator: " ").map { String($0) }
    }

    var numericOnly: String {
        filter("0123456789.".contains)
    }
}
