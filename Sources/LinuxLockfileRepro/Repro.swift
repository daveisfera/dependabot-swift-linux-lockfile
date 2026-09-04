import HostConditional
import Logging

public enum Repro {
    public static let dependencyName = HostConditional.name
    public static let logger = Logger(label: "linux-lockfile-repro")
}
