import Foundation

enum AppInfo {
    static var displayName: String {
        if let name = mainBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String, !name.isEmpty {
            return name
        }
        if let name = mainBundle.object(forInfoDictionaryKey: "CFBundleName") as? String, !name.isEmpty {
            return name
        }
        return "tigersync"
    }

    static var versionString: String {
        let short = mainBundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = mainBundle.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(short) (\(build))"
    }

    private static var mainBundle: Bundle {
        Bundle.main
    }
}
