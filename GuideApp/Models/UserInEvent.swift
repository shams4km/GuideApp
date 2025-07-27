import UIKit

// MARK: - модель пользователя (слово User нельзя использовать т.к. оно занято Firebase`ом)

struct UserInEvent {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var favoriteEventsId: [Int]
    var avatarImage: UIImage?

    var representation: [String: Any] {
        var repres: [String: Any] = [:]
        repres["id"] = self.id
        repres["firstName"] = self.firstName
        repres["lastName"] = self.lastName
        repres["email"] = self.email
        repres["favoriteEventsId"] = self.favoriteEventsId

        return repres
    }
}
