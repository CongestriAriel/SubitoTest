//
//  ViewModelState.swift
//  Subito
//
//  Created by Ariel Congestri on 17/12/2021.
//

import Foundation

enum ViewModelState: Equatable {
    case failure(ErrorViewData)
    case loading
    case success
}
