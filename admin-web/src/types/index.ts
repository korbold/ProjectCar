/**
 * Truck location for map markers and API.
 */
export interface Truck {
  id: string
  placa: string
  conductor?: { id: number; email: string }
  ubicacion?: { lat: number; lng: number }
  activo: boolean
  ultimoReporte?: string
}

/**
 * Driver (usuario with CONDUCTOR role) for the drivers table.
 */
export interface Driver {
  id: number
  email: string
  rol: 'ADMIN' | 'CONDUCTOR'
}
