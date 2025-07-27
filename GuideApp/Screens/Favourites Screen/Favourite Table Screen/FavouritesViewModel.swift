import UIKit
import Combine

// MARK: - вью модель таблицы избранных ивентов

class FavouritesViewModel {

    private var eventService = EventService.shared

    @Published var userFavouriteEventsAreEmpty = true

    var favouriteEventsPublisher: AnyPublisher<[Event], Never> {
        return eventService.$userFavouriteEvents
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func getAllUserFavouriteEventsByIdArray() {
        checkUserFavouriteEventsChanging()

        // проверяем были ли загружены избранные ивенты пользователя с удаленного сервера
        if eventService.areUserFavouriteEventsLoaded {
            return
        }
        let user = UserService.shared.getCurrentUser()

        if let favoriteEventsId = user?.favoriteEventsId {
            guard !favoriteEventsId.isEmpty else { return }

            let joinedIdsString = favoriteEventsId.map { String($0) }.joined(separator: ",")
            NetworkService.shared.fetchAllEventsByIds(byIds: joinedIdsString) { [weak self] events, error in
                if let error = error {
                    print("error: ", error)
                } else if let events {
                    self?.eventService.saveUserFavouriteEvents(with: events)
                    self?.eventService.areUserFavouriteEventsLoaded = true
                }
                self?.checkUserFavouriteEventsChanging()
            }
        }

    }

    func checkUserFavouriteEventsChanging() {
        userFavouriteEventsAreEmpty = eventService.userFavouriteEventsAreEmpty()
    }

}
extension FavouritesViewModel {
    func numberOfRowsInSection() -> Int {
        return eventService.getUserFavouriteEventsCount()
    }
    
    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavouritesTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? FavouritesTableViewCell
        guard let cell = cell else { return UITableViewCell() }

        let event = eventService.userFavouriteEvents[indexPath.row]

        if let imageLink = event.images?.first?.image {
            Task {
                let image = try? await ImageNetworkManager.shared.downloadImage(by: imageLink)
                if let imageReady = image {
                    DispatchQueue.main.async {
                        cell.configureCell(with: imageReady)
                    }
                } else {
                    if let noPicture = UIImage(named: "no_photo") {
                        await cell.configureCell(with: noPicture)
                    }
                }
            }
        }
        cell.configureCell(with: event)

        return cell
    }

    func saveCurrentFavouriteTableSelectedEventInEventService(didSelectRowAt indexPath: IndexPath) {
        let event = eventService.userFavouriteEvents[indexPath.row]

        eventService.userFavouriteTableSelectedEvent = event
    }

    func deleteByLeftSwipe(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            
            self?.deleteFavouriteEvent(by: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .left)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func deleteFavouriteEvent(by arrayIndex: Int) {
        let curUser = UserService.shared.getCurrentUser()

        if var curUser = curUser {
            let event = eventService.getEventFromUserFavouriteEvents(at: arrayIndex)

            guard let index = curUser.favoriteEventsId.firstIndex(of: event.id) else { return }

            curUser.favoriteEventsId.remove(at: index)
            //  удаляем ивент из кэша
            eventService.removeEventFromUserFavouriteEvents(at: arrayIndex)
            //  обновляем информацию про пользователя в локальном сервисе пользователя
            UserService.shared.setUpdatedUser(user: curUser)
            //  обновляем информацию про пользователя на удаленном сервере (firebase)
            UserService.shared.updateUserInfo(with: curUser) { result in
                switch result {
                case .success:
                    print("event successfully deleted!")
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
        }

    }

}
