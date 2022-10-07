import React from 'react'
import TravelersDetails from './TravelersDetails'

const Trip = () => {

    let namee = "Chinmay Dandekar";
    let age = "20";
    let contact = "9673936656";
    let email = "chinmay2201.cd@gmail.com";
    let trip = "Virar Bus Dep. to Nalasopara Bus Dep."
    let seatNo = "6";

    let numberPlate = "MH04AU5824";
    let busModel = "Volvo";

    let driverName = "Vin Petrol"
    let driverMobile = "082826969"

    return (<>
      <div className="main-cont-trip">
          
            <div className="left-cont-trip">
                <h1 className='title'>Bus Name</h1>
                <div className="cont-row">
                    <div className='details'>
                        <h2>Bus Details</h2>
                        <h3>Bus Model: { busModel }</h3>
                        <h3>Vehicle Number:   { numberPlate }</h3>
                    </div>
                    <div className='details'>
                        <h2>Driver Details</h2>
                        <h3>Name:  { driverName }</h3>
                        <h3>Number:   { driverMobile }</h3>


                    </div>
                </div>
                <h2 className='travelers-details-text'>Traveler's Details:</h2>
                <TravelersDetails Name={namee} Age={age} Contact={contact} Email={email} TripFromTo={trip} SeatNo={ seatNo } />
                <TravelersDetails Name={namee} Age={age} Contact={contact} Email={email} TripFromTo={trip} SeatNo={ seatNo } />
                <TravelersDetails Name={namee} Age={age} Contact={contact} Email={email} TripFromTo={trip} SeatNo={ seatNo } />
                <TravelersDetails Name={namee} Age={age} Contact={contact} Email={email} TripFromTo={trip} SeatNo={ seatNo } />
          </div>
      </div>
        <div className="right-cont-trip">
           <div className="container-column">
                <h2>Map:</h2>
                <div className='image-cont'></div>
            </div>
      </div>
  </>
  )
}

export default Trip