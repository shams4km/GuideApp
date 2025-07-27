import UIKit

// MARK: - вью модель таблицы фильтрации по городу

class FilterViewModel {
    var locationService = LocationService.shared
}
extension FilterViewModel {
    func numberOfRowsInSection() -> Int {
        locationService.citySlug.count
    }
    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? FilterTableViewCell

        guard let cell = cell else { return UITableViewCell() }

        let slug = locationService.citySlug[indexPath.row]
        let cityName = locationService.cityMap[slug]

        if let unwrappedCityName = cityName {
            cell.configureCell(with: unwrappedCityName)
        }
        return cell
    }

    func saveCurrentFilterTableSelectedCityInLocationService(didSelectRowAt indexPath: IndexPath) {
        let slug = locationService.citySlug[indexPath.row]
        let cityName = locationService.cityMap[slug]

        if let unwrappedCityName = cityName {
            locationService.filterTableSelectedCity = unwrappedCityName
        }
    }

}
