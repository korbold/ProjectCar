import type { Truck } from '../../domain/entities'

/**
 * Port (secondary): fetches trucks from an external source (e.g. HTTP API).
 * Implemented by infrastructure adapters.
 */
export interface TruckRepository {
  getAll(): Promise<Truck[]>
}
