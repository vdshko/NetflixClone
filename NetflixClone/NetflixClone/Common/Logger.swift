//
//  Logger.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import Foundation
import OSLog

private typealias SystemLogger = os.Logger

/// An enum with functions for printing any needed information in the console and stand it out among all other prints.
enum Logger {

    /// With this parameter, the Logger decides what message passes through and what discard.
    /// **(feel free to change it during the Debug)**
    static var currentLevelPriority: LogLevelPriority = LogLevelPriority.test

    /// With this parameter, the Logger decides what separator to use while printing each value from each input.
    /// **(feel free to change it during the Debug)**
    static var separator: String = " <>|<> "

    private static let systemLogger: SystemLogger = SystemLogger(subsystem: Bundle.main.bundleIdentifier ?? "NetflixClone app", category: "Logger")

    private static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter
    }()

    /// Print to the console an  input with the **Test level priority**.
    static func test(_ input: Any..., separator: String = Self.separator, file: String = #file, line: Int = #line) {
        log(.test, complete(input, with: separator), file: file, line: line)
    }

    /// Print to the console an  input with the **Information level priority**.
    static func info(_ input: Any..., separator: String = Self.separator, file: String = #file, line: Int = #line) {
        log(.information, complete(input, with: separator), file: file, line: line)
    }

    /// Print to the console an  input with the **Success level priority**.
    static func success(_ input: Any..., separator: String = Self.separator, file: String = #file, line: Int = #line) {
        log(.success, complete(input, with: separator), file: file, line: line)
    }

    /// Print to the console an  input with the **Warning level priority**.
    static func warn(_ input: Any..., separator: String = Self.separator, file: String = #file, line: Int = #line) {
        log(.warning, complete(input, with: separator), file: file, line: line)
    }

    /// Print to the console an  input with the **Failure level priority**.
    static func error(_ input: Any..., separator: String = Self.separator, file: String = #file, line: Int = #line) {
        log(.failure, complete(input, with: separator), file: file, line: line)
    }

    private static func complete(_ input: Any..., with separator: String) -> String {
        return input.map { return "\($0)" }.joined(separator: separator)
    }

    private static func log(_ levelPriority: LogLevelPriority, _ completeString: @autoclosure () -> String, file: String = #file, line: Int = #line) {
        #if DEBUG
        guard currentLevelPriority.rawValue <= levelPriority.rawValue else { return }
        let startIndex: String.Index? = file.range(of: "/", options: .backwards)?.upperBound
        let fileName: String.SubSequence = file[startIndex!...]
        let message: String = " \(levelPriority.glyph) [\(dateFormatter.string(from: Date()))] \(fileName)(\(line)) | \(completeString())"
        let isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        guard !isPreview else { print(message); return }
        switch levelPriority {
        case .test: systemLogger.debug("\(message)")
        case .information: systemLogger.info("\(message)")
        case .success: systemLogger.notice("\(message)")
        case .warning: systemLogger.warning("\(message)")
        case .failure: systemLogger.fault("\(message)")
        }
        #endif
    }
}

enum LogLevelPriority: Int {

    /// Level for the local test (must not be left in the code after task completion) **(rawValue = 0)**
    case test

    /// Level for informing about anything **(rawValue = 1)**
    case information

    /// Level for any success operation (for example: success Network response) **(rawValue = 2)**
    case success

    /// Level for any warnings (for example TODOs or failure Network response that actually doesn't need attention) **(rawValue = 3)**
    case warning

    /// Level for any failure operation (for example: failure Network response) **(rawValue = 4)**
    case failure

    var glyph: String {
        switch self {
        case .test: return "💜"
        case .information: return "💙"
        case .success: return "💚"
        case .warning: return "💛"
        case .failure: return "💔"
        }
    }
}
