class Year {
  String year;

  Year(this.year);

  static List<Year> getYear() {
    return <Year>[
      Year('Select Year'),
      Year('2020'),
      Year('2019'),
      Year('2018'),
      Year('2017'),
      Year('2016'),
      Year('2015'),
      Year('2014'),
      Year('2013'),
      Year('2012'),
      Year('2011'),
      Year('2010'),
      Year('2009'),
      Year('2008'),
      Year('2007'),
      Year('2006'),
      Year('2005'),
      Year('2004'),
      Year('2003'),
      Year('2002'),
      Year('2001'),
      Year('2000'),
    ];
  }
}

class FuelType {
  String fuelT;

  FuelType(this.fuelT);

  static List<FuelType> getFuelType() {
    return <FuelType>[
      FuelType('Select Fuel Type'),
      FuelType('Petrol'),
      FuelType('Diesel'),
      FuelType('Electric'),
      FuelType('Hybrid'),
      FuelType('Gas'),
    ];
  }
}

class Transmission {
  String transmission;

  Transmission(this.transmission);

  static List<Transmission> getTransmissionType() {
    return <Transmission>[
      Transmission('Select Transmission Type'),
      Transmission('Auto'),
      Transmission('Manual'),
    ];
  }
}
