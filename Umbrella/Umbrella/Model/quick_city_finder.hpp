//
//  quick_city_finder.hpp
//  CppTest
//
//  Created by Ilia Ukhov on 10/5/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#include "city_finder.hpp"
#include <unordered_map>

namespace cities
{

class quick_city_finder: public city_finder
{
    typedef std::string archived_city, country_code, city_name;

    std::string bundle_path;
    char cash_first_letter;
    std::vector<archived_city> cash;
    std::vector<city> big_cities;
    static constexpr char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const std::unordered_map<country_code, city_name>& country_codes_dict;
    
public:
    quick_city_finder(
        const std::string bundle_path
,       const std::unordered_map<country_code, city_name>& country_codes_dict
    );

    std::vector<city>
    get_similar_cities(
        const std::string& name_part
,       size_t n
    ) override;

    std::vector<city>
    get_big_cities() override;
    
private:
    
    std::vector<archived_city>
    read_cities_with(const std::string& name_part);

    void
    update_cash(char file_letter);

    city
    unarchive_city(const std::string& archived_city) const;

    std::vector<city>
    load_big_cities();
};
    
} /* namespace cities */
