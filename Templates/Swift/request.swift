//
// {{ operationId|upperCamelCase }}.swift
//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension {{ options.name }}{% if tag %}.{{ options.tagPrefix }}{{ tag|upperCamelCase }}{{ options.tagSuffix }}{% endif %} {

    public enum {{ operationId|upperCamelCase }} {

      public static let service = APIService<Response>(id: "{{ operationId }}", tag: "{{ tag }}", method: "{{ method|uppercase }}", path: "{{ path }}", hasBody: {% if hasBody %}true{% else %}false{% endif %}{% if securityRequirement %}, authorization: Authorization(type: "{{ securityRequirement.name }}", scope: "{{ securityRequirement.scope }}"){% endif %})

      {% if description %}
      /** {{ description }} */
      {% endif %}
      public class Request: APIRequest<Response> {
          {% for enum in enums %}
          {% if not enum.isGlobal %}

          {% if enum.description %}
          /** {{ enum.description }} */
          {% endif %}
          public enum {{ enum.enumName }}: String {
              {% for enumCase in enum.enums %}
              case {{ enumCase.name }} = "{{enumCase.value}}"
              {% endfor %}

              public static let cases: [{{ enum.enumName }}] = [
                {% for enumCase in enum.enums %}
                .{{ enumCase.name }},
                {% endfor %}
              ]
          }
          {% endif %}
          {% endfor %}
          {% if nonBodyParams %}

          public struct Options {
              {% for param in nonBodyParams %}

              {% if param.description %}
              /** {{ param.description }} */
              {% endif %}
              public var {{ param.name }}: {{ param.optionalType }}
              {% endfor %}

              public init({% for param in nonBodyParams %}{{param.name}}: {{param.optionalType}}{% ifnot param.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}) {
                  {% for param in nonBodyParams %}
                  self.{{param.name}} = {{param.name}}
                  {% endfor %}
              }
          }

          public var options: Options
          {% endif %}
          {% if bodyParam %}
          {% if bodyParam.anonymousSchema %}

          {% if bodyParam.anonymousSchema.description %}
          /** {{ bodyParam.schema.description }} */
          {% endif %}
          public struct {{ bodyParam.anonymousSchema.type }} {
            {% for property in bodyParam.anonymousSchema.properties %}

            {% if property.description %}
            /** {{ property.description }} */
            {% endif %}
            public var {{ property.name }}: {{ property.optionalType }}
            {% endfor %}

            public init({% for property in bodyParam.anonymousSchema.properties %}{{property.name}}: {{property.optionalType}}{% ifnot property.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}) {
                {% for property in bodyParam.anonymousSchema.properties %}
                self.{{property.name}} = {{property.name}}
                {% endfor %}
            }
          }
          {% endif %}

          public var {{ bodyParam.name}}: {{bodyParam.optionalType}}
          {% endif %}

          public init({% if bodyParam %}{{ bodyParam.name}}: {{ bodyParam.optionalType }}{% if nonBodyParams %}, {% endif %}{% endif %}{% if nonBodyParams %}options: Options{% endif %}) {
              {% if bodyParam %}
              self.{{ bodyParam.name}} = {{ bodyParam.name}}
              {% endif %}
              {% if nonBodyParams %}
              self.options = options
              {% endif %}
              super.init(service: {{ operationId|upperCamelCase }}.service)
          }
          {% if nonBodyParams %}

          /// convenience initialiser so an Option doesn't have to be created
          public convenience init({% for param in params %}{{ param.name }}: {{ param.optionalType }}{% ifnot param.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}) {
              {% if nonBodyParams %}
              let options = Options({% for param in nonBodyParams %}{{param.name}}: {{param.name}}{% ifnot forloop.last %}, {% endif %}{% endfor %})
              {% endif %}
              self.init({% if bodyParam %}{{ bodyParam.name}}: {{ bodyParam.name}}{% if nonBodyParams %}, {% endif %}{% endif %}{% if nonBodyParams %}options: options{% endif %})
          }
          {% endif %}
          {% if pathParams %}

          public override var path: String {
              return super.path{% for param in pathParams %}.replacingOccurrences(of: "{" + "{{ param.name }}" + "}", with: "\(self.options.{{ param.encodedValue }})"){% endfor %}
          }
          {% endif %}
          {% if encodedParams %}

          public override var parameters: [String: Any] {
              var params: JSONDictionary = [:]
              {% for param in encodedParams %}
              {% if param.optional %}
              if let {{ param.name }} = options.{{ param.encodedValue }} {
                params["{{ param.value }}"] = {{ param.name }}
              }
              {% else %}
              params["{{ param.value }}"] = options.{{ param.encodedValue }}
              {% endif %}
              {% endfor %}
              return params
          }
          {% endif %}
          {% if bodyParam %}

          public override var jsonBody: Any? {
              return {{ bodyParam.encodedValue }}
          }
          {% endif %}
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            {% for response in responses %}
            {% if response.description %}

            /** {{ response.description }} */
            {% endif %}
            {% if response.statusCode %}
            case {{ response.name }}{% if response.type %}({{ response.type }}){% endif %}
            {% else %}
            case {{ response.name }}(statusCode: Int{% if response.type %}, {{ response.type }}{% endif %})
            {% endif %}
            {% endfor %}

            {% if singleSuccessType %}
            public var success: {{ singleSuccessType }}? {
                switch self {
                {% for response in responses where response.type == singleSuccessType and response.success %}
                case .{{ response.name }}({% if not response.statusCode %}_, {% endif %}let response): return response
                {% endfor %}
                default: return nil
                }
            }
            {% endif %}

            {% if singleFailureType %}
            public var failure: {{ singleFailureType }}? {
                switch self {
                {% for response in responses where response.type == singleFailureType and not response.success %}
                case .{{ response.name }}({% if not response.statusCode %}_, {% endif %}let response): return response
                {% endfor %}
                default: return nil
                }
            }
            {% endif %}

            public var response: Any {
                switch self {
                {% for response in responses where response.type %}
                case .{{ response.name }}({% if not response.statusCode %}_, {% endif %}let response): return response
                {% endfor %}
                {% if not alwaysHasResponseType %}
                default: return ()
                {% endif %}
                }
            }

            public var statusCode: Int {
              switch self {
              {% for response in responses %}
              {% if response.statusCode %}
              case .{{ response.name }}: return {{ response.statusCode }}
              {% else %}
              case .{{ response.name }}(let statusCode, _): return statusCode
              {% endif %}
              {% endfor %}
              }
            }

            public var successful: Bool {
              switch self {
              {% for response in responses %}
              case .{{ response.name }}: return {{ response.success }}
              {% endfor %}
              }
            }

            public init(statusCode: Int, json: Any) throws {
                switch statusCode {
                {% for response in responses where response.statusCode %}
                {% if response.type %}
                case {{ response.statusCode }}: self = try .{{ response.name }}(JSONDecoder.decode(json: json))
                {% else %}
                case {{ response.statusCode }}: self = .{{ response.name }}
                {% endif %}
                {% endfor %}
                {% if defaultResponse %}
                {% if defaultResponse.type %}
                default: self = try .{{ defaultResponse.name }}(statusCode: statusCode, JSONDecoder.decode(json: json))
                {% else %}
                default: self = .{{ defaultResponse.name }}(statusCode: statusCode)
                {% endif %}
                {% else %}
                default: self = try APIError.unexpectedStatusCode(statusCode: statusCode, data: json)
                {% endif %}
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
