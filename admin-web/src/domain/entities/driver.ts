/**
 * Driver (usuario with CONDUCTOR role) for the drivers table.
 * Domain entity with no framework dependencies.
 */
export interface Driver {
  id: number
  email: string
  rol: 'ADMIN' | 'CONDUCTOR'
}
