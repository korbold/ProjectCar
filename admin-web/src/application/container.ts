import { GetTrucksUseCase } from './use-cases/get-trucks.use-case'
import { GetDriversUseCase } from './use-cases/get-drivers.use-case'
import { TruckRepositoryHttp } from '../infrastructure/repositories/truck.repository.http'
import { DriverRepositoryHttp } from '../infrastructure/repositories/driver.repository.http'

/**
 * Composition root: wires ports (repositories) with use cases.
 * Single place to swap adapters (e.g. mock repos for tests).
 */
const truckRepository = new TruckRepositoryHttp()
const driverRepository = new DriverRepositoryHttp()

export const getTrucksUseCase = new GetTrucksUseCase(truckRepository)
export const getDriversUseCase = new GetDriversUseCase(driverRepository)
