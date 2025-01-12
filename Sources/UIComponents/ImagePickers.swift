//
//  File.swift
//  UIComponents
//
//  Created by Nhat Le on 12/1/25.
//

import SwiftUI
import PhotosUI

@MainActor
@Observable public final class ImagePickers {
    public init() {}
    /// Single image selection
    public var image: Image?
    public var imageSelection: PhotosPickerItem? {
        didSet {
            guard let imageSelection else { return }
            Task { try await loadTransferable(from: imageSelection)}
        }
    }
    /// Multiple image selection
    public var images: [Image] = []
    public var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            Task {
                guard !imageSelections.isEmpty else { return }
                try await loadTransferable(from: imageSelections)
                imageSelections = []
            }
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws {
        do {
            guard let imageData = try await imageSelection.loadTransferable(type: Data.self),
            let uiImage = UIImage(data: imageData) else { return }
            self.image = Image(uiImage: uiImage)
        } catch {
            print(error.localizedDescription)
            image = nil
        }
    }
    
    func loadTransferable(from imageSelections: [PhotosPickerItem]) async throws {
        do {
            for imageSelection in imageSelections {
                guard let imageData = try await imageSelection.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: imageData) else { return }
                self.images.append(Image(uiImage: uiImage))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
