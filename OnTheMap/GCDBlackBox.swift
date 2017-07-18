//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Erik Uecke on 7/18/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
