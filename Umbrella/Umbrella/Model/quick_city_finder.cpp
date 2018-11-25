//
//  quick_city_finder.cpp
//  CppTest
//
//  Created by Ilia Ukhov on 10/5/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#include "quick_city_finder.hpp"
#include <fstream>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/serialization/vector.hpp>

using namespace std;
using namespace cities;

typedef string archived_city;
typedef unsigned long city_id;

quick_city_finder::quick_city_finder(
    const std::string bundle_path
,   const std::unordered_map<country_code, city_name>& country_codes_dict
) : bundle_path(bundle_path)
,   country_codes_dict(country_codes_dict)
{
    big_cities = load_big_cities();
}

vector<city>
quick_city_finder::get_similar_cities(
    const string& name_part
,   size_t number
)
{
    auto archived_cities = read_cities_with(name_part);
    auto begin = archived_cities.begin(); auto end = archived_cities.end();
    auto ceiling = upper_bound(begin, end, name_part);
    
    if (ceiling == end) return vector<city>();
    
    auto end_subrange = distance(ceiling, end) >= number ? ceiling + number : end;
    auto similar_cities = vector<string>(ceiling, end_subrange);
    
    vector<city> cities;
    for (const string& c : similar_cities) cities.push_back(unarchive_city(c));
    return cities;
}

vector<city>
quick_city_finder::get_big_cities()
{
    return big_cities;
}

constexpr char quick_city_finder::alphabet[];

vector<archived_city>
quick_city_finder::read_cities_with(const string& name_part)
{
    char first_letter = name_part[0];
    
    char letter_to_search_file =
        find(begin(alphabet), end(alphabet), first_letter)
            != end(alphabet) ? first_letter : '_';
    
    if (letter_to_search_file != cash_first_letter) update_cash(letter_to_search_file);
    return cash;
}

void
quick_city_finder::update_cash(char file_letter)
{
    string path = bundle_path + "/cities_" + file_letter + ".cppvct";
    auto ifs = ifstream(path);
    boost::archive::binary_iarchive ia(ifs);
    ia >> cash;
    cash_first_letter = file_letter;
    ifs.close();
}

city
quick_city_finder::unarchive_city(const string& archived_city) const
{
    size_t i = 0;
    for (; !isdigit(archived_city[i]); ++i);
    unsigned long id = strtoul(archived_city.substr(i).c_str(), nullptr, 10);
    
    string country_code = archived_city.substr(i - 2, 2);
    string city_name = archived_city.substr(0, i - 2);
    string country = country_codes_dict.at(country_code);
    
    if (!country.empty()) {
        city_name += ", ";
        city_name += country;
    } else {
        city_name += "th";
    }
    
    return {city_name, id};
}

vector<city>
quick_city_finder::load_big_cities()
{
    string path = bundle_path + "/big_cities.cppvct";
    vector<archived_city> archived_cities;
    auto ifs = ifstream(path);
    boost::archive::binary_iarchive ia(ifs);
    ia >> archived_cities;
    ifs.close();
    
    vector<city> cities;
    for (const string& c : archived_cities) cities.push_back(unarchive_city(c));
    return cities;
}
