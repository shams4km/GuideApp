import UIKit

// MARK: - вью модель детального экрана ивента из главной таблицы

class MainTableDetailViewModel {

    private var eventService = EventService.shared

    func fetchSelectedEvent() -> Event? {
        if let event = eventService.mainTableSelectedEvent {
            return event
        }
        return nil
    }

    func fetchSelectedEventImage(completion: @escaping (UIImage?) -> Void) {
        let noImage = UIImage(named: "no_photo")
        if let event = eventService.mainTableSelectedEvent, let imageLink = event.images?.first?.image {
            Task {
                do {
                    let image = try await ImageNetworkManager.shared.downloadImage(by: imageLink)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(noImage)
                    }
                }
            }
        } else {
            completion(noImage)
        }
    }

    func saveFavoriteEvent(with event: Event) {
        let curUser = UserService.shared.getCurrentUser()

        if var curUser = curUser {
            if curUser.favoriteEventsId.contains(where: { $0 == event.id }) {
                print("event уже есть в избранных")
                return
            }
            curUser.favoriteEventsId.append(event.id)
            //  обновляем информацию про пользователя в локальном сервисе пользователя
            UserService.shared.setUpdatedUser(user: curUser)
            //  сохраняем ивент в кэш
            eventService.saveEventInUserFavouriteEvents(with: event)
            //  обновляем информацию про пользователя на удаленном сервере (firebase)
            UserService.shared.updateUserInfo(with: curUser) { result in
                switch result {
                case .success:
                    print("event successfully saved!")
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
        }
    }

    func deleteFavouriteEvent(with event: Event) {
        let curUser = UserService.shared.getCurrentUser()

        let id = event.id
        
        if var curUser = curUser {
            if let index = curUser.favoriteEventsId.firstIndex(of: id) {
                curUser.favoriteEventsId.remove(at: index)
            } else {
                print("event не в избранных", event)
                return
            }
            //  обновляем информацию про пользователя в локальном сервисе пользователя
            UserService.shared.setUpdatedUser(user: curUser)
            //  удаляем ивент из кэша
            eventService.removeEventFromUserFavouriteEvents(with: event)
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
    
    func isEventFavourite(selectedEvent: Event) -> Bool {
        let curUser = UserService.shared.getCurrentUser()
        let selectedId = selectedEvent.id

        if let curUser = curUser {
            return curUser.favoriteEventsId.contains { $0 == selectedId }
        }
        return false
    }

// если ивент уже в избранных то детальный экран открывается с черным флажком
    func getBookmarkImageNameBySelectedEventBeforeAnimation(selectedEvent: Event) -> String {
        if isEventFavourite(selectedEvent: selectedEvent) {
            return "bookmark-black"
        } else {
            return "bookmark"
        }
    }

}
extension MainTableDetailViewModel {
    func getConfiguredEventBodyTextView(with event: Event) -> String {
        var eventText = event.bodyText ?? event.description

        if eventText.hasPrefix("<p>") {
            eventText.removeFirst(3)
        }
        if eventText.hasSuffix("</p>") {
            eventText.removeLast(4)
        }
        return eventText
    }
    func getConfiguredAgeRestrictionLabel(with event: Event) -> String {
        var ageRestriction = "No info about age restriction"
        if let ageRestrictionEvent = event.ageRestriction {
            if ageRestrictionEvent == "0" {
                ageRestriction = "0+"
            } else {
                ageRestriction = ageRestrictionEvent
            }
        }
        return ageRestriction
    }
    func getConfiguredPriceLabel(with event: Event) -> String {
        var priceLabel = "No info about price"

        if let priceEvent = event.price, !priceEvent.isEmpty {
            priceLabel = priceEvent
        }
        return priceLabel
    }
    func getConfiguredCityLabel(with event: Event) -> String {
        var cityLabel = "No info about city"

        if let cityEvent = event.location?.slug, !cityEvent.isEmpty {
            cityLabel = LocationService.shared.getFullCityName(bySlug: cityEvent)
        }
        return cityLabel
    }
    func getConfiguredDateLabel(with event: Event) -> String {
        var dateLabel = "No info about date"

        var datesEvent: [String] = []

        if let dates = event.dates {
            for dateElement in dates {
                var fullDate = ""
                let sDate = dateElement.startDate ?? ""
                let eDate = dateElement.endDate ?? ""
                if !eDate.isEmpty && !sDate.isEmpty {
                    fullDate = "from \(sDate) to \(eDate)"
                } else if !sDate.isEmpty && eDate.isEmpty {
                    fullDate = "\(sDate)"
                } else if !eDate.isEmpty && sDate.isEmpty {
                    fullDate = "... to \(eDate)"
                }
                datesEvent.append(fullDate)
            }
        }
        if !datesEvent.isEmpty {
            if let firstDate = datesEvent.first {
                dateLabel = firstDate
            }
        }
        return dateLabel
    }
}
