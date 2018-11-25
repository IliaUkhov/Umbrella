//
//  country_codes_dict_loader.hpp
//  Umbrella
//
//  Created by Ilia Ukhov on 11/23/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef country_codes_dict_loader_hpp
#define country_codes_dict_loader_hpp

#include <stdio.h>
#include <string>
#include <fstream>
#include <unordered_map>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/serialization/unordered_map.hpp>
#include <boost/optional.hpp>

#include "aliases_and_constants.hpp"

namespace cities
{

class country_codes_dict_loader
{
    static boost::optional<std::unordered_map<cities::country_code, cities::city_name>>
    country_codes_dict;
    
public:
    
    static boost::optional<std::unordered_map<cities::country_code, cities::city_name>>&
    get_country_codes_dict();
    
    static void
    load(std::string bundle_path);
};
    
}

#endif /* country_codes_dict_loader_hpp */
