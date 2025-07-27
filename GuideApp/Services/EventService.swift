import Foundation
import Combine

// MARK: - класс для работы с массивами event`ов (предназначен для кэширования обьектов)

class EventService {
    public static let shared = EventService()

    private init() {}

    private let lock = NSLock()

    @Published var events: [Event] = []
    @Published var searchBarFilteredEvents: [Event] = []
    @Published var userFavouriteEvents: [Event] = []

    var mainTableSelectedEvent: Event?
    var userFavouriteTableSelectedEvent: Event?

    var areUserFavouriteEventsLoaded = false

// MARK: - методы для всех event в главной main table screen
    func saveEvent(with event: Event) {
        lock.lock()
        if !events.contains(where: { $0.id == event.id }) {
            events.append(event)
        }
        lock.unlock()
    }
    
    func saveEventsArray(with newEvents: [Event]) {
        lock.lock()
        events = newEvents
        lock.unlock()
    }

    func removeEvent(at index: Int) {
        lock.lock()
        events.remove(at: index)
        lock.unlock()
    }

    func removeEvent(with event: Event) {
        lock.lock()
        if let index = events.firstIndex(of: event) {
            events.remove(at: index)
        }
        lock.unlock()
    }

    func getEvent(at index: Int) -> Event {
        return events[index]
    }

    func getEvent(by id: Int) -> Event? {
        if let event = events.first(where: { $0.id == id }) {
            return event
        }
        return nil
    }

    func getAllEvents() -> [Event] {
        return events
    }

    func getCount() -> Int {
        return events.count
    }

    func eventsAreEmpty() -> Bool {
        return events.isEmpty
    }

// MARK: - методы для всех отфильтрованных search bar`ом event в главной main table screen
    func saveSearchBarFilteredEvents(with eventsArray: [Event]) {
        searchBarFilteredEvents = eventsArray
    }
    
    func getSearchBarFilteredEvents() -> [Event] {
        return searchBarFilteredEvents
    }
    func getSearchBarFilteredEventsCount() -> Int {
        return searchBarFilteredEvents.count
    }

// MARK: - методы для избранных event текущего пользователя в favourite table screen (тип Event)
    func saveUserFavouriteEvents(with eventsArray: [Event]) {
        lock.lock()
        userFavouriteEvents = eventsArray
        lock.unlock()
    }

    func getUserFavouriteEvents() -> [Event] {
        return userFavouriteEvents
    }

    func getUserFavouriteEventsCount() -> Int {
        return userFavouriteEvents.count
    }

    func userFavouriteEventsAreEmpty() -> Bool {
        return userFavouriteEvents.isEmpty
    }

    func saveEventInUserFavouriteEvents(with event: Event) {
        lock.lock()
        if !userFavouriteEvents.contains(where: { $0.id == event.id }) {
            userFavouriteEvents.append(event)
        }
        lock.unlock()
    }

    func removeEventFromUserFavouriteEvents(at index: Int) {
        lock.lock()
        userFavouriteEvents.remove(at: index)
        lock.unlock()
    }

    func removeEventFromUserFavouriteEvents(with event: Event) {
        lock.lock()
        if let index = userFavouriteEvents.firstIndex(of: event) {
            userFavouriteEvents.remove(at: index)
        }
        lock.unlock()
    }

    func getEventFromUserFavouriteEvents(at index: Int) -> Event {
        return userFavouriteEvents[index]
    }

    func getEventFromUserFavouriteEvents(by id: Int) -> Event? {
        if let event = userFavouriteEvents.first(where: { $0.id == id }) {
            return event
        }
        return nil
    }

}
