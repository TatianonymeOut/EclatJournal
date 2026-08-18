import Foundation

struct DailyMantra: Identifiable, Equatable {
    let id: Int
    let text: String
}

enum MantraCatalog {
    static let all: [DailyMantra] = [
        DailyMantra(id: 0, text: "Je peux avancer doucement et rester présente à moi-même."),
        DailyMantra(id: 1, text: "Ce que je ressens a le droit d’exister, sans avoir besoin d’être corrigé."),
        DailyMantra(id: 2, text: "Une petite attention envers moi compte déjà beaucoup."),
        DailyMantra(id: 3, text: "Je laisse cette journée être ce qu’elle est, une étape à la fois."),
        DailyMantra(id: 4, text: "Respirer, observer, choisir la prochaine chose douce à faire."),
        DailyMantra(id: 5, text: "Je n’ai pas besoin d’être parfaite pour mériter du repos."),
        DailyMantra(id: 6, text: "Aujourd’hui, je m’écoute avec curiosité plutôt qu’avec jugement."),
        DailyMantra(id: 7, text: "Les jours ordinaires méritent aussi d’être remarqués."),
        DailyMantra(id: 8, text: "Je peux demander de l’aide et conserver ma force."),
        DailyMantra(id: 9, text: "Un moment difficile ne raconte pas toute mon histoire."),
        DailyMantra(id: 10, text: "Je fais de la place pour ce qui me nourrit vraiment."),
        DailyMantra(id: 11, text: "Mon rythme est valable, même lorsqu’il ne ressemble à celui de personne d’autre."),
        DailyMantra(id: 12, text: "Je peux célébrer ce qui a été possible aujourd’hui.")
    ]

    static func mantra(for date: Date, calendar: Calendar = .autoupdatingCurrent) -> DailyMantra {
        let day = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        return all[(day - 1) % all.count]
    }
}
