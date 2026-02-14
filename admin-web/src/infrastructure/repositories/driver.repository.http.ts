import type { Driver } from '../../domain/entities'
import type { DriverRepository } from '../../application/ports/driver.repository'
import { apiClient } from '../http/api-client'

/**
 * HTTP adapter for DriverRepository port.
 * Fetches drivers from the backend /usuarios endpoint.
 */
export class DriverRepositoryHttp implements DriverRepository {
  async getAll(): Promise<Driver[]> {
    const res = await apiClient.get<Driver[]>('/usuarios')
    return Array.isArray(res.data) ? res.data : []
  }
}
