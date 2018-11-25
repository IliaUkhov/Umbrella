//
//  forecast.hpp
//  Umbrella
//
//  Created by Ilia Ukhov on 10/13/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef forecast_hpp
#define forecast_hpp

#include "aliases_and_constants.hpp"

namespace weather
{

struct weather
{
    virtual time_interval_1970
    date() const = 0;
    
    virtual std::string
    description() const = 0;
    
    virtual kelvin
    temperature() const = 0;
    
    virtual percent
    humidity() const = 0;
    
    virtual float
    wind_speed() const = 0;
    
    virtual ~weather() = default;
};

struct day_weather
{
    virtual time_interval_1970
    date() const = 0;
    
    virtual std::string
    description() const = 0;
    
    virtual std::pair<kelvin, kelvin>
    temperature_range() const = 0;
    
    virtual std::pair<percent, percent>
    humidity_range() const = 0;
    
    virtual std::pair<float, float>
    wind_speed_range() const = 0;
    
    virtual ~day_weather() = default;
};

class interpreter
{
public:
    
    virtual
    ~interpreter() = default;
    
    virtual std::vector<weather*>*
    get_short_forecast() const = 0;
    
    virtual std::vector<day_weather*>*
    get_long_forecast() const = 0;
    
    virtual cities::city
    get_city() const = 0;
    
    virtual void
    read(const std::string& file_string) = 0;
};
    
typedef std::vector<weather*>* short_forecast;
typedef std::vector<day_weather*>* long_forecast;

} /* namespace weather */

#endif /* forecast_hpp */
