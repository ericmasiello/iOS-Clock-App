//
//  OpenWeather.swift
//  Clock It
//
//  Created by Eric Masiello on 10/24/24.
//
import Foundation
import OpenMeteoSdk

struct WeatherData {
    let current: Current
    let daily: Daily

    struct Current {
        let time: Date
        let temperature2m: Float
        let relativeHumidity2m: Float
        let apparentTemperature: Float
        let isDay: Float
        let precipitation: Float
        let rain: Float
        let showers: Float
        let snowfall: Float
        let weatherCode: Float
        let cloudCover: Float
        let windSpeed10m: Float
    }
    struct Daily {
        let time: [Date]
        let weatherCode: [Float]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
        let apparentTemperatureMax: [Float]
        let apparentTemperatureMin: [Float]
        let precipitationSum: [Float]
        let rainSum: [Float]
        let showersSum: [Float]
        let snowfallSum: [Float]
        let precipitationHours: [Float]
        let precipitationProbabilityMax: [Float]
        let windSpeed10mMax: [Float]
        let windGusts10mMax: [Float]
    }
}

/// Make sure the URL contains `&format=flatbuffers`
class WeatherClient {
    static func getWeather() async -> WeatherData? {
        /**
         * TODO: the lat/long is harcoded. I'll need to access this information via the iOS hardware somehow
         * TODO: this data comes back as a buffer. It works but is difficutl to debug. if you change &format=json it'll be JSON. then i need to figure out how to parse that into a struct. Chat GPT it.
         */
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=39.15722&longitude=-77.05496&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,rain,showers,snowfall,weather_code,cloud_cover,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_sum,rain_sum,showers_sum,snowfall_sum,precipitation_hours,precipitation_probability_max,wind_speed_10m_max,wind_gusts_10m_max&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch&timeformat=unixtime&timezone=America%2FNew_York&forecast_days=3&format=flatbuffers")!
        
        let responses = try? await WeatherApiResponse.fetch(url: url)
        
        guard let responses else {
            return nil
        }
        let response = responses[0];
        
        /// Attributes for timezone and location
        let utcOffsetSeconds = response.utcOffsetSeconds
        let timezone = response.timezone
        let timezoneAbbreviation = response.timezoneAbbreviation
        let latitude = response.latitude
        let longitude = response.longitude

        let current = response.current!
        let daily = response.daily!

        /// Note: The order of weather variables in the URL query and the `at` indices below need to match!
        let data = WeatherData(
            current: .init(
                time: Date(timeIntervalSince1970: TimeInterval(current.time + Int64(utcOffsetSeconds))),
                temperature2m: current.variables(at: 0)!.value,
                relativeHumidity2m: current.variables(at: 1)!.value,
                apparentTemperature: current.variables(at: 2)!.value,
                isDay: current.variables(at: 3)!.value,
                precipitation: current.variables(at: 4)!.value,
                rain: current.variables(at: 5)!.value,
                showers: current.variables(at: 6)!.value,
                snowfall: current.variables(at: 7)!.value,
                weatherCode: current.variables(at: 8)!.value,
                cloudCover: current.variables(at: 9)!.value,
                windSpeed10m: current.variables(at: 10)!.value
            ),
            daily: .init(
                time: daily.getDateTime(offset: utcOffsetSeconds),
                weatherCode: daily.variables(at: 0)!.values,
                temperature2mMax: daily.variables(at: 1)!.values,
                temperature2mMin: daily.variables(at: 2)!.values,
                apparentTemperatureMax: daily.variables(at: 3)!.values,
                apparentTemperatureMin: daily.variables(at: 4)!.values,
                precipitationSum: daily.variables(at: 5)!.values,
                rainSum: daily.variables(at: 6)!.values,
                showersSum: daily.variables(at: 7)!.values,
                snowfallSum: daily.variables(at: 8)!.values,
                precipitationHours: daily.variables(at: 9)!.values,
                precipitationProbabilityMax: daily.variables(at: 10)!.values,
                windSpeed10mMax: daily.variables(at: 11)!.values,
                windGusts10mMax: daily.variables(at: 12)!.values
            )
        )

        
        
        return data
    }
}
