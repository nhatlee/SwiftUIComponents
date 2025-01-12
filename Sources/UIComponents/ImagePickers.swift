//
//  File.swift
//  UIComponents
//
//  Created by Nhat Le on 12/1/25.
//

import SwiftUI
import PhotosUI

@Observable public final class ImagePickers {
    var image: Image?
    var imageSelection: PhotosPickerItem? {
        didSet {
            guard let imageSelection else { return }
            Task { try await loadTransferable(from: imageSelection)}
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws {
        do {
            guard let image = try await imageSelection.loadTransferable(type: Image.self) else { return }
            self.image = image
        } catch {
            print(error.localizedDescription)
            image = nil
        }
    }
}
