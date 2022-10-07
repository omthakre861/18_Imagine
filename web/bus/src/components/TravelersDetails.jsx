import React from 'react'

const TravelersDetails = ({Name,Age, Contact, Email, TripFromTo, SeatNo }) => {
  return (
      <div className='travelers-details-cont'>
          <div className="left-cont">
              <h2 className>{Name}</h2>
              <div className='flex-row'><h3>Age: {Age}</h3>
              <h3>Contact: { Contact } </h3></div>
              
              <h3>Email: { Email } </h3>
              <h3>Trip:  { TripFromTo } </h3>
          </div>
          <div className="right-cont">
              <h1>{SeatNo}</h1>
              <h3>Seat No.</h3>
          </div>
      </div> 
              
  )
}

export default TravelersDetails