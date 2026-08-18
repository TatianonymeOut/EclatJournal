import Foundation
import SwiftUI

enum Mood: String, CaseIterable, Codable, Hashable, Identifiable {
    case joyful
    case calm
    case neutral
    case tired
    case sad
    case anxious
    case angry

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .joyful: "😄"
        case .calm: "😌"
        case .neutral: "🙂"
        case .tired: "😮‍💨"
        case .sad: "😔"
        case .anxious: "😟"
        case .angry: "😠"
        }
    }

    var label: String {
        switch self {
        case .joyful: "Joyeuse"
        case .calm: "Sereine"
        case .neutral: "Neutre"
        case .tired: "Fatiguée"
        case .sad: "Triste"
        case .anxious: "Anxieuse"
        case .angry: "En colère"
        }
    }

    var tint: Color {
        switch self {
        case .joyful: .orange
        case .calm: .teal
        case .neutral: .indigo
        case .tired: .purple
        case .sad: .blue
        case .anxious: .yellow
        case .angry: .red
        }
    }
}

enum HealthEventKind: String, CaseIterable, Codable, Identifiable {
    case symptom
    case medication

    var id: String { rawValue }

    var label: String {
        switch self {
        case .symptom: "Symptôme"
        case .medication: "Médicament"
        }
    }

    var symbolName: String {
        switch self {
        case .symptom: "waveform.path.ecg"
        case .medication: "pills"
        }
    }
}

enum AttachmentKind: String, CaseIterable, Codable, Identifiable {
    case photo
    case audio
    case video

    var id: String { rawValue }

    var label: String {
        switch self {
        case .photo: "Photo"
        case .audio: "Audio"
        case .video: "Vidéo"
        }
    }

    var symbolName: String {
        switch self {
        case .photo: "photo"
        case .audio: "waveform"
        case .video: "video"
        }
    }
}
