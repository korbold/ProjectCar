import type { Driver } from '../../domain/entities'

/**
 * Port (secondary): fetches drivers from an external source (e.g. HTTP API).
 * Implemented by infrastructure adapters.
 */
export interface DriverRepository {
  getAll(): Promise<Driver[]>
}
