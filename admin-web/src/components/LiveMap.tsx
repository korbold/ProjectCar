import { MapContainer, Marker, Popup, TileLayer } from 'react-leaflet'
import L from 'leaflet'
import type { Truck } from '../domain/entities'

const IBARRA_CENTER: [number, number] = [-0.3517, -78.1223]

const truckIcon = new L.DivIcon({
  className: 'custom-truck-marker',
  html: `<div style="
    width: 28px; height: 28px;
    background: #1976d2;
    border: 2px solid #fff;
    border-radius: 50%;
    box-shadow: 0 2px 6px rgba(0,0,0,0.3);
  "></div>`,
  iconSize: [28, 28],
  iconAnchor: [14, 14],
})

export interface LiveMapProps {
  trucks: Truck[]
}

/**
 * Map centered on Ibarra, Ecuador. Renders custom markers from the trucks prop.
 */
export function LiveMap({ trucks }: LiveMapProps) {
  return (
    <MapContainer
      center={IBARRA_CENTER}
      zoom={13}
      style={{ height: '100%', minHeight: 400, borderRadius: 8 }}
      scrollWheelZoom
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      {trucks
        .filter((t) => t.ubicacion)
        .map((truck) => (
          <Marker
            key={truck.id}
            position={[truck.ubicacion!.lat, truck.ubicacion!.lng]}
            icon={truckIcon}
          >
            <Popup>
              <strong>{truck.placa}</strong>
              {truck.conductor?.email && (
                <div>Conductor: {truck.conductor.email}</div>
              )}
            </Popup>
          </Marker>
        ))}
    </MapContainer>
  )
}

