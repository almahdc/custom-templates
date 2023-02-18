//
//  ViewModel.swift
//  Templates
//
//  Created by Alma Hodzic on 18.02.23.
//

import Foundation
import Combine

class ViewModel: NSObject, ObservableObject {
  @Published var title = "Hello, world! :]"
}
