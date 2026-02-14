import type { Truck } from '../../domain/entities'
import type { TruckRepository } from '../../application/ports/truck.repository'
import { apiClient } from '../http/api-client'

/**
 * HTTP adapter for TruckRepository port.
 * Fetches trucks from the backend /camiones endpoint.
 */
export class TruckRepositoryHttp implements TruckRepository {
  async getAll(): Promise<Truck[]> {
    const res = await apiClient.get<Truck[]>('/camiones')
    return Array.isArray(res.data) ? res.data : []
  }
}
