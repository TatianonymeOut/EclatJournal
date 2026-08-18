import AVFoundation
import AVKit
import SwiftUI

struct MediaAttachmentView: View {
    let kind: AttachmentKind
    let fileURL: URL
    let caption: String
    var compact = false

    var body: some View {
        Group {
            switch kind {
            case .photo:
                AsyncImage(url: fileURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        unavailableContent
                    default:
                        ProgressView()
                    }
                }
            case .video:
                VideoPlayer(player: AVPlayer(url: fileURL))
            case .audio:
                AudioAttachmentPlayer(fileURL: fileURL, caption: caption)
            }
        }
        .frame(height: compact ? 96 : 180)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(alignment: .bottomLeading) {
            if !caption.isEmpty, kind != .audio {
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.black.opacity(0.5))
            }
        }
    }

    private var unavailableContent: some View {
        ContentUnavailableView(
            "Média indisponible",
            systemImage: "exclamationmark.triangle",
            description: Text("Le fichier d’origine est introuvable.")
        )
        .background(.secondary.opacity(0.08))
    }
}

private struct AudioAttachmentPlayer: View {
    let fileURL: URL
    let caption: String
    @State private var player: AVPlayer
    @State private var isPlaying = false

    init(fileURL: URL, caption: String) {
        self.fileURL = fileURL
        self.caption = caption
        _player = State(initialValue: AVPlayer(url: fileURL))
    }

    var body: some View {
        Group {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                HStack(spacing: 14) {
                    Button {
                        togglePlayback()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.title3)
                            .frame(width: 42, height: 42)
                            .background(.tint, in: Circle())
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isPlaying ? "Mettre l’audio en pause" : "Lire la note audio")

                    VStack(alignment: .leading, spacing: 4) {
                        Text(caption.isEmpty ? "Note audio" : caption)
                            .font(.subheadline.weight(.medium))
                            .lineLimit(2)
                        Text(isPlaying ? "Lecture en cours" : "Prêt à lire")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "waveform")
                        .font(.title2)
                        .foregroundStyle(.tint)
                }
                .padding()
            } else {
                ContentUnavailableView(
                    "Média indisponible",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Le fichier d’origine est introuvable.")
                )
            }
        }
        .frame(maxWidth: .infinity)
        .background(.tint.opacity(0.08))
        .onDisappear {
            player.pause()
            isPlaying = false
        }
    }

    private func togglePlayback() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
}
