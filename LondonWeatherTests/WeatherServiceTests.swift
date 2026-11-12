import Foundation
import Testing
@testable import LondonWeather

@Suite(.serialized)
struct WeatherServiceTests {
    @Test func emptyCityDoesNotCallTheNetwork() async {
        StubbedWeatherURLProtocol.responder = { _ in
            Issue.record("The service asked the network for an empty city.")
            return (500, Data())
        }
        let service = makeLiveService()

        await #expect(throws: WeatherServiceError.emptyCity) {
            try await service.currentWeather(forCity: "  ")
        }
    }

    @Test func londonRequestUsesTheTimelinePath() async throws {
        let requestedURL = RequestedURL()
        StubbedWeatherURLProtocol.responder = { request in
            requestedURL.value = request.url
            return (200, WeatherFixture.data)
        }
        let service = makeLiveService()

        let weather = try await service.currentLondonWeather()

        let url = try #require(requestedURL.value)
        #expect(url.path.hasSuffix("/London"))
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems?.contains { $0.name == "include" && $0.value == "current,hours" } == true)
        #expect(components?.queryItems?.contains { $0.name == "unitGroup" && $0.value == "metric" } == true)
        #expect(weather.resolvedAddress == "London")
        #expect(weather.currentConditions.temp == 9.0)
        #expect(weather.currentConditions.conditions == "Overcast")
        #expect(weather.days.count == 1)
    }

    @Test func allowanceExceededMapsToTheFreeAllowanceError() async {
        StubbedWeatherURLProtocol.responder = { _ in
            (429, Data("quota".utf8))
        }
        let service = makeLiveService()

        await #expect(throws: WeatherServiceError.allowanceExceeded) {
            try await service.currentWeather(forCity: "London")
        }
    }

    @Test func invalidJSONMapsToAnUndecodableResponse() async {
        StubbedWeatherURLProtocol.responder = { _ in
            (200, Data("{".utf8))
        }
        let service = makeLiveService()

        await #expect(throws: WeatherServiceError.undecodableResponse) {
            try await service.currentWeather(forCity: "London")
        }
    }

    @Test func missingNetworkMapsToNoNetwork() async {
        StubbedWeatherURLProtocol.responder = { _ in
            throw URLError(.notConnectedToInternet)
        }
        let service = makeLiveService()

        await #expect(throws: WeatherServiceError.noNetwork) {
            try await service.currentWeather(forCity: "London")
        }
    }
}

private func makeLiveService() -> LiveWeatherService {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [StubbedWeatherURLProtocol.self]
    return LiveWeatherService(session: URLSession(configuration: configuration))
}

private final class RequestedURL: @unchecked Sendable {
    var value: URL?
}

private final class StubbedWeatherURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var responder: ((URLRequest) throws -> (Int, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let responder = Self.responder else {
            client?.urlProtocol(self, didFailWithError: URLError(.unknown))
            return
        }

        do {
            let (statusCode, data) = try responder(request)
            let response = HTTPURLResponse(
                url: request.url ?? LiveWeatherService.timelineBaseURL,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
