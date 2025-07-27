import UIKit
import Combine

// MARK: - вью модель главной таблицы с ивентами

class MainViewModel {
    private var eventService = EventService.shared
    private var locationService = LocationService.shared

    @Published var eventsAreEmpty = true

    var eventsPublisher: AnyPublisher<[Event], Never> {
        return eventService.$events
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var searchBarFilteredEventsPublisher: AnyPublisher<[Event], Never> {
        return eventService.$searchBarFilteredEvents
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    var selectedCityPublisher: AnyPublisher<String?, Never> {
        return locationService.$filterTableSelectedCity
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
// запрашиваем ивенты с сети по рандомной странице на которой они находятся
    func getAllEvents() {
        let randomPageNumber = String(getRandomNumber())

        NetworkService.shared.fetchAllEventsByPage(byPage: randomPageNumber) { [weak self] events, error in
            if let error = error {
                print("error: ", error)
            } else if let events {
                self?.eventService.saveEventsArray(with: events)
            }
            self?.checkEventsEmpty()
        }
    }
// запрашиваем ивенты с сети по городу
    func getAllEventsByCity(cityName: String) {
        let slug = locationService.getSlug(forFullCityName: cityName)
        
        guard let slug = slug else { return }

        NetworkService.shared.fetchAllEventsWithLocationFilter(slug: slug) { [weak self] events, error in
            if let error = error {
                print("error: ", error)
            } else if let events {
                self?.eventService.saveEventsArray(with: events)
            }
            self?.checkEventsEmpty()
        }
    }

    func getRandomNumber() -> Int {
        let randomInt = Int.random(in: 1...100)
        return randomInt
    }

    func checkEventsEmpty() {
        eventsAreEmpty = eventService.eventsAreEmpty()
    }

}
extension MainViewModel {
    func numberOfRowsInSection(searchController: UISearchController) -> Int {
        let inSearchMode = inSearchMode(searchController)
        return inSearchMode ?
        eventService.getSearchBarFilteredEventsCount() :
        eventService.getCount()
    }
// чтобы свифтлинт не ругался :(
    func configureCell(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath,
        searchController: UISearchController
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MainTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MainTableViewCell

        guard let cell = cell else { return UITableViewCell() }

        let inSearchMode = inSearchMode(searchController)

        let event = inSearchMode ?
        eventService.searchBarFilteredEvents[indexPath.row] :
        eventService.events[indexPath.row]

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

    func saveCurrentMainTableSelectedEventInEventService(
        didSelectRowAt indexPath: IndexPath,
        searchController: UISearchController
    ) {
        let inSearchMode = inSearchMode(searchController)

        let event = inSearchMode ?
        eventService.searchBarFilteredEvents[indexPath.row] :
        eventService.events[indexPath.row]

        eventService.mainTableSelectedEvent = event
    }

}
extension MainViewModel {
    func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""

        return isActive && !searchText.isEmpty
    }

    func updateSearchController(searchBarText: String?) {
        eventService.saveSearchBarFilteredEvents(with: eventService.getAllEvents())

        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { print("no text in search bar"); return }

            let newFilteredEventsArrayByText = eventService.getSearchBarFilteredEvents()
                .filter { $0.title.lowercased().contains(searchText) }

            eventService.saveSearchBarFilteredEvents(with: newFilteredEventsArrayByText)
        }

    }
    
}
