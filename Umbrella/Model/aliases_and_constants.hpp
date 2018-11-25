//
//  aliases_and_constants.hpp
//  Umbrella
//
//  Created by Ilia Ukhov on 10/22/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef aliases_and_constants_hpp
#define aliases_and_constants_hpp

#include <stdio.h>
#include <chrono>
#include <string>
#include <vector>
#include <functional>

namespace service
{
    const std::chrono::seconds request_try_interval(3);
    const std::string call_id_link =
        "https://api.openweathermap.org/data/2.5/forecast?"
        "id=ID&appid=e7ea8c35bfd882055a3b45b3bf70aa0b";
    
    const std::string call_coords_link =
        "https://api.openweathermap.org/data/2.5/forecast?"
        "lat=LAT&lon=LON&appid=e7ea8c35bfd882055a3b45b3bf70aa0b";
    
    typedef unsigned long status_code;
    typedef std::function<void(status_code code, std::string text)> response_handling;
}

namespace cities
{
    typedef unsigned long city_id;
    typedef std::pair<std::string, city_id> city;
    typedef std::string country_code, city_name;
}

namespace weather
{
    typedef unsigned long time_interval_1970;
    typedef float kelvin, percent;
}

#endif /* aliases_and_constants_hpp */
