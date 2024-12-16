//
//  WeatherData.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//

import Foundation

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
