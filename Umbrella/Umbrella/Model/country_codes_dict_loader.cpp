//
//  country_codes_dict_loader.cpp
//  Umbrella
//
//  Created by Ilia Ukhov on 11/23/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#include "country_codes_dict_loader.hpp"

using namespace cities;

boost::optional<std::unordered_map<country_code, city_name>>
country_codes_dict_loader::country_codes_dict;

boost::optional<std::unordered_map<country_code, city_name>>&
country_codes_dict_loader::get_country_codes_dict()
{
    return country_codes_dict;
}

void
country_codes_dict_loader::load(std::string bundle_path)
{
    if (country_codes_dict) return;
    std::unordered_map<country_code, city_name> dict;
    std::string path = bundle_path + "/codes.cppumap";
    auto ifs = std::ifstream(path);
    boost::archive::binary_iarchive ia(ifs);
    ia >> dict;
    ifs.close();
    country_codes_dict = boost::make_optional(dict);
}
