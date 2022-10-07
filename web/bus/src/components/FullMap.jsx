import React from 'react'
import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';


mapboxgl.accessToken = "pk.eyJ1Ijoib210aGFrcmUiLCJhIjoiY2w4eWxmamxwMGFjMzN2cWkxM2U2OXB0cCJ9.RMfHQBfY6xeN_MhvoOX3Zw";

const FullMap = () => {


    const mapContainerRef = useRef(null);
    
    let [lng, setLng] = React.useState(-87.65);
    let [lat, setLat] = React.useState(41.84);
    let [zoom, setZoom] = React.useState(10);

    useEffect(() => {
        const map = new mapboxgl.Map({
            container: mapContainerRef.current,
            center: [lng, lat],
            zoom: zoom,
        })

        map.addControl(new mapboxgl.NavigationControl(), 'top-right');
        map.on('move', () => {
            setLng(map.getCenter().lng.toFixed(4));
            setLat(map.getCenter().lat.toFixed(4));
            setZoom(map.getZoom().toFixed(2));
        })

        return () => map.remove();

    },[])
  return (
      <ReactMapGL {...viewport}
    
          
          onViewPortChange={(newView) =>setViewport(newView)} />
  )
}

export default FullMap;