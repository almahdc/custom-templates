//___FILEHEADER___

import Foundation
import Combine

class ViewModel: NSObject, ObservableObject {
  @Published var title = "Hello, world! :]"
}
