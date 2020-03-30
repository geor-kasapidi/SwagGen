//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension TFL.StopPoint {

    /** Gets a list of StopPoints filtered by the modes available at that StopPoint. */
    public enum StopPointGetByMode {

        public static let service = APIService<Response>(id: "StopPoint_GetByMode", tag: "StopPoint", method: "GET", path: "/StopPoint/Mode/{modes}", hasBody: false)

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** A comma-seperated list of modes e.g. tube,dlr */
                public var modes: [String]

                /** The data set page to return. Page 1 equates to the first 1000 stop points, page 2 equates to 1001-2000 etc. Must be entered for bus mode as data set is too large. */
                public var page: Int?

                public init(modes: [String], page: Int? = nil) {
                    self.modes = modes
                    self.page = page
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: StopPointGetByMode.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(modes: [String], page: Int? = nil) {
                let options = Options(modes: modes, page: page)
                self.init(options: options)
            }

            public override var path: String {
                return super.path.replacingOccurrences(of: "{" + "modes" + "}", with: "\(self.options.modes.joined(separator: ","))")
            }

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                if let page = options.page {
                  params["page"] = page
                }
                return params
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {

            /** A paged response containing StopPoints */
            public class Status200: APIModel {

                /** The centre latitude/longitude of this list of StopPoints */
                public var centrePoint: [Double]?

                /** The index of this page */
                public var page: Int?

                /** The maximum size of the page in this response i.e. the maximum number of StopPoints */
                public var pageSize: Int?

                /** Collection of stop points */
                public var stopPoints: [StopPoint]?

                /** The total number of StopPoints available across all pages */
                public var total: Int?

                public init(centrePoint: [Double]? = nil, page: Int? = nil, pageSize: Int? = nil, stopPoints: [StopPoint]? = nil, total: Int? = nil) {
                    self.centrePoint = centrePoint
                    self.page = page
                    self.pageSize = pageSize
                    self.stopPoints = stopPoints
                    self.total = total
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    centrePoint = try container.decodeArrayIfPresent("centrePoint")
                    page = try container.decodeIfPresent("page")
                    pageSize = try container.decodeIfPresent("pageSize")
                    stopPoints = try container.decodeArrayIfPresent("stopPoints")
                    total = try container.decodeIfPresent("total")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encodeIfPresent(centrePoint, forKey: "centrePoint")
                    try container.encodeIfPresent(page, forKey: "page")
                    try container.encodeIfPresent(pageSize, forKey: "pageSize")
                    try container.encodeIfPresent(stopPoints, forKey: "stopPoints")
                    try container.encodeIfPresent(total, forKey: "total")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? Status200 else { return false }
                  guard self.centrePoint == object.centrePoint else { return false }
                  guard self.page == object.page else { return false }
                  guard self.pageSize == object.pageSize else { return false }
                  guard self.stopPoints == object.stopPoints else { return false }
                  guard self.total == object.total else { return false }
                  return true
                }

                public static func == (lhs: Status200, rhs: Status200) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }
            public typealias SuccessType = Status200

            /** OK */
            case status200(Status200)

            public var success: Status200? {
                switch self {
                case .status200(let response): return response
                }
            }

            public var response: Any {
                switch self {
                case .status200(let response): return response
                }
            }

            public var statusCode: Int {
                switch self {
                case .status200: return 200
                }
            }

            public var successful: Bool {
                switch self {
                case .status200: return true
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 200: self = try .status200(decoder.decode(Status200.self, from: data))
                default: throw APIClientError.unexpectedStatusCode(statusCode: statusCode, data: data)
                }
            }

            public var description: String {
                return "\(statusCode) \(successful ? "success" : "failure")"
            }

            public var debugDescription: String {
                var string = description
                let responseString = "\(response)"
                if responseString != "()" {
                    string += "\n\(responseString)"
                }
                return string
            }
        }
    }
}
