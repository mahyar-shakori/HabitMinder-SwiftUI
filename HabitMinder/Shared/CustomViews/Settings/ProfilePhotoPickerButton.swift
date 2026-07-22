//
//  ProfilePhotoPickerButton.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import PhotosUI
import SwiftUI

struct ProfilePhotoPickerButton: View {
    let imageData: Data?
    var imageSize: CGFloat
    var placeholderPadding: CGFloat
    var borderColor: Color
    var editIconSize: CGFloat = FontSize.small
    var editBadgeSize: CGFloat = Size.large
    var editBadgeOffset: CGFloat = Spacing.x2Small
    let onImagePicked: (Data) -> Void

    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isShowingPhotoPicker = false
    @State private var selectedProfilePhoto: PhotosPickerItem?

    var body: some View {
        Button {
            isShowingPhotoPicker = true
        } label: {
            ZStack(alignment: .bottomTrailing) {
                profileImage

                editBadge
            }
        }
        .buttonStyle(.plain)
        .onChange(of: selectedProfilePhoto) { _, newItem in
            loadProfilePhoto(from: newItem)
        }
        .photosPicker(
            isPresented: $isShowingPhotoPicker,
            selection: $selectedProfilePhoto,
            matching: .images
        )
    }

    private var profileImage: some View {
        Group {
            if let imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: SystemIconName.profile)
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.appWhite, themeManager.appPrimary.opacity(Opacity.iconBackground))
                    .padding(placeholderPadding)
                    .background(themeManager.appSecondary.opacity(Opacity.subtle))
            }
        }
        .frame(width: imageSize, height: imageSize)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(borderColor, lineWidth: LineWidth.medium)
        }
    }

    private var editBadge: some View {
        Image(systemName: SystemIconName.pencil)
            .font(.system(size: editIconSize, weight: .bold))
            .foregroundStyle(.appWhite)
            .frame(width: editBadgeSize, height: editBadgeSize)
            .liquidGlass(
                tint: themeManager.appPrimary,
                in: Circle(),
                fallback: themeManager.appPrimary
            )
            .offset(x: editBadgeOffset, y: editBadgeOffset)
    }

    private func loadProfilePhoto(from item: PhotosPickerItem?) {
        guard let item else {
            return
        }

        Task {
            guard let data = try? await item.loadTransferable(type: Data.self) else {
                return
            }

            await MainActor.run {
                onImagePicked(data)
            }
        }
    }
}
