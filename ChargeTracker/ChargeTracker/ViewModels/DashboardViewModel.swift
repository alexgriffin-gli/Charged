import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var selectedVehicle: Vehicle?
    @Published var totalCost: Double = 0
    @Published var totalKWh: Double = 0
    @Published var averagePricePerKWh: Double = 0
    @Published var totalMilesDriven: Double = 0
    @Published var averageMilesPerKWh: Double = 0

    private var vehicleManager = VehicleManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        vehicleManager.$vehicles
            .sink { [weak self] vehicles in
                guard let self = self else { return }
                if let selectedVehicle = self.selectedVehicle, let updatedVehicle = vehicles.first(where: { $0.id == selectedVehicle.id }) {
                    self.selectedVehicle = updatedVehicle
                } else if let firstVehicle = vehicles.first {
                    self.selectedVehicle = firstVehicle
                } else {
                    self.selectedVehicle = nil
                }
                self.updateDashboard()
            }
            .store(in: &cancellables)

        $selectedVehicle
            .sink { [weak self] _ in
                self?.updateDashboard()
            }
            .store(in: &cancellables)
    }

    func updateDashboard() {
        guard let vehicle = selectedVehicle else {
            totalCost = 0
            totalKWh = 0
            averagePricePerKWh = 0
            totalMilesDriven = 0
            averageMilesPerKWh = 0
            return
        }

        totalCost = vehicle.chargingSessions.reduce(0) { $0 + ($1.pricePerKWh * $1.kwhAdded) }
        totalKWh = vehicle.chargingSessions.reduce(0) { $0 + $1.kwhAdded }

        if totalKWh > 0 {
            averagePricePerKWh = totalCost / totalKWh
        } else {
            averagePricePerKWh = 0
        }

        totalMilesDriven = vehicle.totalMilesDriven
        averageMilesPerKWh = vehicle.averageMilesPerKWh
    }
}
