import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

struct MediaComposer: View {
    @Binding var drafts: [MediaAttachmentDraft]
    let onRemove: (MediaAttachmentDraft) -> Void
    @State private var pickerItem: PhotosPickerItem?
    @State private var isImportingAudio = false
    @State private var importError: Error?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                PhotosPicker(
                    selection: $pickerItem,
                    matching: .any(of: [.images, .videos])
                ) {
                    Label("Photo ou vidéo", systemImage: "photo.on.rectangle.angled")
                }

                Button {
                    isImportingAudio = true
                } label: {
                    Label("Audio", systemImage: "waveform")
                }
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.bordered)

            if !drafts.isEmpty {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 10)], spacing: 10) {
                    ForEach(drafts) { draft in
                        ZStack(alignment: .topTrailing) {
                            MediaAttachmentView(
                                kind: draft.kind,
                                fileURL: draft.fileURL,
                                caption: draft.caption,
                                compact: true
                            )

                            Button(role: .destructive) {
                                remove(draft)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.white, .black.opacity(0.55))
                            }
                            .padding(5)
                            .accessibilityLabel("Supprimer le média")
                        }
                    }
                }
            }
        }
        .onChange(of: pickerItem) { _, item in
            guard let item else { return }
            Task {
                await importPickerItem(item)
            }
        }
        .fileImporter(
            isPresented: $isImportingAudio,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                importAudio(url)
            case .failure(let error):
                importError = error
            }
        }
        .alert("Impossible d’ajouter ce média", isPresented: Binding(
            get: { importError != nil },
            set: { if !$0 { importError = nil } }
        )) {
            Button("OK", role: .cancel) { importError = nil }
        } message: {
            Text(importError?.localizedDescription ?? "Réessaie avec un autre fichier.")
        }
    }

    @MainActor
    private func importPickerItem(_ item: PhotosPickerItem) async {
        do {
            let types = item.supportedContentTypes
            guard let type = types.first(where: { MediaStore.attachmentKind(for: $0) != nil }),
                  let kind = MediaStore.attachmentKind(for: type),
                  let data = try await item.loadTransferable(type: Data.self)
            else {
                throw MediaStoreError.unsupportedType
            }
            let filename = try MediaStore.save(
                data: data,
                kind: kind,
                preferredExtension: type.preferredFilenameExtension
            )
            drafts.append(MediaAttachmentDraft(kind: kind, filename: filename))
        } catch {
            importError = error
        }
        pickerItem = nil
    }

    private func importAudio(_ url: URL) {
        do {
            let filename = try MediaStore.importFile(from: url, kind: .audio)
            drafts.append(MediaAttachmentDraft(kind: .audio, filename: filename))
        } catch {
            importError = error
        }
    }

    private func remove(_ draft: MediaAttachmentDraft) {
        onRemove(draft)
        drafts.removeAll { $0.id == draft.id }
    }
}
