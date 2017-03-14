import React from 'react';
import { Map, Marker, Popup, TileLayer } from 'react-leaflet';
import L from 'leaflet'

class Travap extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      places: []
    };

    this.props.fetch.places().then(response => {
      this.setState({ places: response });
    });
  }

  travapIcon(place) {
    return L.divIcon({ className: 'travap-icon', html: place.name })
  }

  render() {
    return (
      <div>
        <h1>Travap</h1>
        <Map center={[52.52, 13.40]} zoom={6} style={{height: '250px'}}>
          <TileLayer
            url='http://a.tile.stamen.com/watercolor/{z}/{x}/{y}.jpg'
            attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
            minZoom={3}
            maxZoom={12}
          />
          {this.state.places.map(place =>
            <Marker key={place.id} position={[place.coordinates.lat, place.coordinates.lng]} icon={this.travapIcon(place)}>
              <Popup>
                <span>{place.name}</span>
              </Popup>
            </Marker>
          )}
        </Map>
      </div>
    );
  }
}

export default Travap
