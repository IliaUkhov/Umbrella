//
//  forecast_1_or_5_days.hpp
//  Umbrella
//
//  Created by Ilia Ukhov on 10/13/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#include "forecast.hpp"
#include <array>
#include <unordered_map>
#include <boost/property_tree/ptree.hpp>

namespace weather
{

struct instant_weather: public weather
{
    instant_weather
    (
    time_interval_1970
,   std::string
,   kelvin
,   percent
,   float
    );
    
    instant_weather
    (
    std::tuple
     <
        time_interval_1970
,       std::string
,       kelvin
,       percent
,       float
     >
    );
    
    time_interval_1970
    date() const override;
    
    std::string
    description() const override;
    
    kelvin
    temperature() const override;
    
    percent
    humidity() const override;
    
    float
    wind_speed() const override;
    
private:
    
    time_interval_1970 _date;
    std::string _description;
    kelvin _temperature;
    percent _humidity;
    float _wind_speed;
};
    
struct day_period_weather: public day_weather
{
    day_period_weather
    (
        time_interval_1970
,       std::string
,       std::pair<kelvin, kelvin>
,       std::pair<percent, percent>
,       std::pair<float, float>
    );
    
    time_interval_1970
    date() const override;
    
    std::string
    description() const override;
    
    std::pair<kelvin, kelvin>
    temperature_range() const override;
    
    std::pair<percent, percent>
    humidity_range() const override;
    
    std::pair<float, float>
    wind_speed_range() const override;
    
private:
    
    time_interval_1970 _date;
    std::string _description;
    std::pair<kelvin, kelvin> _temperature_range;
    std::pair<percent, percent> _humidity_range;
    std::pair<float, float> _wind_speed_range;
};

class json_interpreter: public interpreter
{
    boost::property_tree::ptree json;
    const std::unordered_map<cities::country_code, cities::city_name>& country_codes_dict;
    
public:
    
    json_interpreter
    (
        const std::unordered_map<cities::country_code, cities::city_name>& country_codes_dict
    );
    
    short_forecast
    get_short_forecast() const override;
    
    long_forecast
    get_long_forecast() const override;
    
    cities::city
    get_city() const override;
    
    void
    read(const std::string& json_string) override;
    
private:
    
    day_period_weather*
    make_period_weather
    (
        time_interval_1970
,       std::array<std::string, 8>&
,       std::array<kelvin, 8>&
,       std::array<percent, 8>&
,       std::array<float, 8>&
    ) const;
    
    std::tuple<time_interval_1970, std::string, kelvin, percent, float>
    get_info(const boost::property_tree::ptree& weather_entry) const;
    
    std::pair<std::string, size_t>
    most_frequent(std::array<std::string, 8>) const;
};
    
} /* namespace weather */
