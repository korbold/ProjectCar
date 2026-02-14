import type { Truck } from '../../domain/entities'
import type { TruckRepository } from '../ports/truck.repository'

/**
 * Use case: get all trucks (e.g. for the live map).
 * Depends only on the TruckRepository port.
 */
export class GetTrucksUseCase {
  constructor(private readonly truckRepository: TruckRepository) {}

  async execute(): Promise<Truck[]> {
    return this.truckRepository.getAll()
  }
}
