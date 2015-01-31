The purpose of this project is to exercise the OpenWeatherMap API using the JSON responses.

Using the CoreLocation and AFNetworking Libraries this app will gather the current weather information for a City or the device's current GPS location.  A very basic UI is used to show this information.

Of the many features the OpenWeatherMap API provides, this application currently supports three REST API calls.  These are the calls to get the current weather for city name (api.openweathermap.org/data/2.5/weather?q=London,ca), city ID (api.openweathermap.org/data/2.5/weather?id=2172797) and by longitude and latitude (api.openweathermap.org/data/2.5/weather?lat=35&lon=139).  The other API calls are stubbed out for future implementation.
