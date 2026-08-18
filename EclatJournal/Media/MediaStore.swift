import Foundation
import UniformTypeIdentifiers

enum MediaStoreError: LocalizedError {
    case unableToReadFile
    case unsupportedType

    var errorDescription: String? {
        switch self {
        case .unableToReadFile: "Impossible de lire ce fichier."
        case .unsupportedType: "Ce format de fichier n’est pas pris en charge."
        }
    }
}

enum MediaStore {
    private static let directoryName = "EclatMedia"

    static var directoryURL: URL {
        let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupport.appendingPathComponent(directoryName, isDirectory: true)
    }

    static func fileURL(for filename: String) -> URL {
        directoryURL.appendingPathComponent(filename, isDirectory: false)
    }

    static func save(
        data: Data,
        kind: AttachmentKind,
        preferredExtension: String? = nil
    ) throws -> String {
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        let fallbackExtension: String
        switch kind {
        case .photo: fallbackExtension = "jpg"
        case .audio: fallbackExtension = "m4a"
        case .video: fallbackExtension = "mov"
        }

        let fileExtension = (preferredExtension?.isEmpty == false ? preferredExtension : fallbackExtension) ?? fallbackExtension
        let filename = "\(UUID().uuidString).\(fileExtension.lowercased())"
        try data.write(to: fileURL(for: filename), options: .atomic)
        return filename
    }

    static func importFile(from sourceURL: URL, kind: AttachmentKind) throws -> String {
        let accessed = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if accessed {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        let data = try Data(contentsOf: sourceURL)
        return try save(data: data, kind: kind, preferredExtension: sourceURL.pathExtension)
    }

    static func remove(filename: String) {
        try? FileManager.default.removeItem(at: fileURL(for: filename))
    }

    static func attachmentKind(for type: UTType) -> AttachmentKind? {
        if type.conforms(to: .image) { return .photo }
        if type.conforms(to: .movie) || type.conforms(to: .video) { return .video }
        if type.conforms(to: .audio) { return .audio }
        return nil
    }
}
