import type { Driver } from '../../domain/entities'
import type { DriverRepository } from '../ports/driver.repository'

/**
 * Use case: get all drivers (e.g. for the drivers table).
 * Depends only on the DriverRepository port.
 */
export class GetDriversUseCase {
  constructor(private readonly driverRepository: DriverRepository) {}

  async execute(): Promise<Driver[]> {
    return this.driverRepository.getAll()
  }
}
