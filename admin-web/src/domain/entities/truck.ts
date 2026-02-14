/**
 * Truck location for map markers and API.
 * Domain entity with no framework dependencies.
 */
export interface Truck {
  id: string
  placa: string
  conductor?: { id: number; email: string }
  ubicacion?: { lat: number; lng: number }
  activo: boolean
  ultimoReporte?: string
}
