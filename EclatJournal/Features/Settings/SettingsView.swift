import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var hasShownSampleConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Confidentialité") {
                    Label("Toutes les données restent sur cet appareil.", systemImage: "lock")
                    Label("Aucun compte, publicité ou traceur n’est utilisé.", systemImage: "hand.raised")
                    Label("Les mantras sont inclus dans l’app : aucun texte de journal n’est envoyé à une IA.", systemImage: "sparkles")
                }

                Section("Journal") {
                    Button {
                        SampleData.insertIfNeeded(into: modelContext)
                        hasShownSampleConfirmation = true
                    } label: {
                        Label("Ajouter des données fictives", systemImage: "wand.and.stars")
                    }

                    Text("Pratique pour découvrir les écrans. Cette action n’écrase jamais tes propres entrées.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("À propos") {
                    LabeledContent("Version", value: "0.1.0")
                    Link(destination: URL(string: "https://github.com/TatianonymeOut/EclatJournal")!) {
                        Label("Voir le projet open source", systemImage: "arrow.up.right.square")
                    }
                    Text("Éclat est un journal de bien-être personnel. Il ne remplace pas un professionnel de santé.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Réglages")
        }
        .alert("Données fictives ajoutées", isPresented: $hasShownSampleConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Trois entrées d’exemple sont maintenant disponibles dans ton journal.")
        }
    }
}
