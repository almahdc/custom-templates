/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import Combine

class SpaceImageFetcher {
  private let apiKey = "TCmYkGR6fyYgKlHrN96VkBhrZeAtdxc5yRhltqEU"
  private let session: URLSession

  init(session: URLSession = .shared) {
    self.session = session
  }

  func dailyPicture(date: Date) -> AnyPublisher<PicOfDayResponse, APIError> {
    let components = makeURLComponents(date: date)
    guard let url = components.url else {
      let error = APIError.network(description: "Couldn't create URL")
      return Fail(error: error).eraseToAnyPublisher()
    }
    return session.dataTaskPublisher(for: URLRequest(url: url))
      .mapError { error in
        .network(description: error.localizedDescription)
      }
      .flatMap(maxPublishers: .max(1)) { pair in
        self.decode(pair.data)
      }
      .mapError { error in
        .parsing(description: error.localizedDescription)
      }
      .eraseToAnyPublisher()
  }

  func loadImage(url: URL) -> AnyPublisher<UIImage?, APIError> {
    session.dataTaskPublisher(for: URLRequest(url: url))
      .mapError { error in
        .network(description: error.localizedDescription)
      }
      .map {
        UIImage(data: $0.data)
      }
      .eraseToAnyPublisher()
  }

  private func makeURLComponents(date: Date) -> URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.nasa.gov"
    components.path = "/planetary/apod"

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    let dateString = dateFormatter.string(from: date)

    components.queryItems = [
      URLQueryItem(name: "date", value: dateString),
      URLQueryItem(name: "api_key", value: apiKey)
    ]

    return components
  }

  private func decode(_ data: Data) -> AnyPublisher<PicOfDayResponse, APIError> {
    Just(data)
      .decode(type: PicOfDayResponse.self, decoder: JSONDecoder())
      .mapError { error in
        .parsing(description: error.localizedDescription)
      }
      .eraseToAnyPublisher()
  }
}
