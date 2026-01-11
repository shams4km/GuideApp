import Foundation

class AppContainer {
    static let shared = AppContainer()
    
    let eventService: EventService
    let locationService: LocationService
    
    private init() {
        self.eventService = EventService.shared
        self.locationService = LocationService.shared
    }
}
