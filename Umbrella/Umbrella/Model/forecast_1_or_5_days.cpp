//
//  forecast_1_or_5_days.cpp
//  Umbrella
//
//  Created by Ilia Ukhov on 10/13/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#include "forecast_1_or_5_days.hpp"

#include <sstream>
#include <unordered_map>
#include <boost/property_tree/json_parser.hpp>

using namespace std;
using namespace boost::property_tree;

// MARK: json_interpreter

weather::json_interpreter::json_interpreter
(
    const std::unordered_map<cities::country_code, cities::city_name>& country_codes_dict
) : country_codes_dict(country_codes_dict)
{
}

// MARK: public methods

void
weather::json_interpreter::read(const string& json_string)
{
    stringstream ss;
    ss << json_string;
    read_json(ss, json);
}

weather::short_forecast
weather::json_interpreter::get_short_forecast() const
{
    ptree entry_list = json.get_child("list");
    auto entries = new vector<weather*>;
    int i = 0;
    for (const auto& entry : entry_list)
    {
        if (i == 8) break;
        entries->push_back
        (
            new instant_weather{get_info(entry.second)}
        );
        ++i;
    }
    return entries;
}

weather::long_forecast
weather::json_interpreter::get_long_forecast() const
{
    ptree entry_list = json.get_child("list");
    
    array<string, 8> ds;
    array<kelvin, 8> ts;
    array<percent, 8> hs;
    array<float, 8> ws;
    
    auto entries = new vector<day_weather*>;
    
    int i = 0;
    bool skipped_today = false;
    for (const auto& entry : entry_list)
    {
        time_interval_1970 date;
        
        tie(date, ds[i], ts[i], hs[i], ws[i]) = get_info(entry.second);
        
        string hours = entry.second.get<string>("dt_txt").substr(11, 2);
        
        if (hours != "00" && !skipped_today) continue;
        else skipped_today = true;
        
        ++i;
        
        if (i == 8)
        {
            i = 0;
            entries->push_back(make_period_weather(date, ds, ts, hs, ws));
        }
    }
    return entries;
}

// MARK: private methods

weather::day_period_weather*
weather::json_interpreter::make_period_weather(
    time_interval_1970 date
,   std::array<std::string, 8>& day_descriptions
,   std::array<kelvin, 8>& day_temperatures
,   std::array<percent, 8>& day_humidities
,   std::array<float, 8>& day_wind_speeds
) const
{
    
    auto minmax_t =
        minmax_element(day_temperatures.begin(), day_temperatures.end());
    auto minmax_h =
        minmax_element(day_humidities.begin(), day_humidities.end());
    auto minmax_w =
        minmax_element(day_wind_speeds.begin(), day_wind_speeds.end());
    
    string most_frequent_description;
    size_t count;
    tie(most_frequent_description, count) = most_frequent(day_descriptions);
    
    if (count < 8)
    {
        most_frequent_description = "mostly " + most_frequent_description;
    }
    
    return new day_period_weather
    {
        date
,       most_frequent_description
,       {*minmax_t.first, *minmax_t.second}
,       {*minmax_h.first, *minmax_h.second}
,       {*minmax_w.first, *minmax_w.second}
    };
}

pair<string, size_t>
weather::json_interpreter::most_frequent(array<string, 8> strs) const
{
    unordered_map<string, short> frequencies;
    
    for (const string& a : strs)
    {
        for (const string& b : strs)
        {
            if (a == b)
            {
                frequencies[b] = frequencies.find(b) != frequencies.end()
                    ? frequencies[b] + 1 : 1;
            }
        }
    }
    
    string most_frequent;
    short count = 0;
    for (const auto& f : frequencies)
    {
        if (f.second > count) most_frequent = f.first;
    }
    
    return {most_frequent, count};
}

tuple<weather::time_interval_1970, string, weather::kelvin, weather::percent, float>
weather::json_interpreter::get_info(const ptree& weather_entry) const
{
    time_interval_1970 date = weather_entry.get<unsigned long>("dt");
    
    ptree info = weather_entry.get_child("weather").begin()->second;
    string description = info.get<string>("description");
    ptree params = weather_entry.get_child("main");
    
    kelvin temperature =
        (params.get<float>("temp_min") + params.get<float>("temp_max")) / 2;
    
    percent humidity = params.get<int>("humidity");
    ptree wind = weather_entry.get_child("wind");
    float wind_speed = wind.get<float>("speed");
    
    return {date, description, temperature, humidity, wind_speed};
}

cities::city
weather::json_interpreter::get_city() const
{
    ptree city = json.get_child("city");
    std::string country_code = city.get<cities::country_code>("country");
    std::string country = country_codes_dict.at(country_code);
    return {
        city.get<string>("name") + ", " + country
,       city.get<cities::city_id>("id")
    };
}

// MARK: - instant_weather
// MARK: Init

weather::instant_weather::instant_weather(
    std::tuple<time_interval_1970
,   std::string, kelvin, percent, float> t
) : _date(get<0>(t))
,   _description(get<1>(t))
,   _temperature(get<2>(t))
,   _humidity(get<3>(t))
,   _wind_speed(get<4>(t))
{
}

weather::instant_weather::instant_weather(
    time_interval_1970 date
,   string desc
,   kelvin t
,   percent h
,   float w
) : _date(date)
,   _description(desc)
,   _temperature(t)
,   _humidity(h)
,   _wind_speed(w)
{
}

// MARK: Getters

weather::time_interval_1970
weather::instant_weather::date()
const {
    return _date;
}

string
weather::instant_weather::description() const
{
    return _description;
}

weather::kelvin
weather::instant_weather::temperature() const
{
    return _temperature;
}

weather::percent
weather::instant_weather::humidity() const
{
    return _humidity;
}

float
weather::instant_weather::wind_speed() const
{
    return _wind_speed;
}

// MARK: - day_period_weather
// MARK: Init

weather::day_period_weather::day_period_weather(
    time_interval_1970 date
,   string desc
,   pair<kelvin, kelvin> t_range
,   pair<percent, percent> h_range
,   pair<float, float> w_range
) : _date(date)
,   _description(desc)
,   _temperature_range(t_range)
,_humidity_range(h_range)
,_wind_speed_range(w_range)
{
}

// MARK: Getters

weather::time_interval_1970
weather::day_period_weather::date() const
{
    return _date;
}

string
weather::day_period_weather::description() const
{
    return _description;
}

pair<weather::kelvin, weather::kelvin>
weather::day_period_weather::temperature_range() const
{
    return _temperature_range;
}

pair<weather::percent, weather::percent>
weather::day_period_weather::humidity_range() const
{
    return _humidity_range;
}

pair<float, float>
weather::day_period_weather::wind_speed_range() const
{
    return _wind_speed_range;
}
