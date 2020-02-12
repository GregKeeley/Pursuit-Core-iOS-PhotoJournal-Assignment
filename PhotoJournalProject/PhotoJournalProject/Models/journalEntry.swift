//
//  journalEntry.swift
//  PhotoJournalProject
//
//  Created by Gregory Keeley on 1/25/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation

enum entryState {
    case newEntry
    case existingEntry
}

struct Entry: Codable & Equatable {
    let identifier = UUID().uuidString
    var imageData: Data?
    var date: Date
    var caption: String

}
