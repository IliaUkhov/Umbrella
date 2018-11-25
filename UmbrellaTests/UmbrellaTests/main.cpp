//
//  main.cpp
//  UmbrellaTests
//
//  Created by Ilia Ukhov on 11/25/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#include <sstream>
#include <iostream>
#include <unordered_map>
#include "aliases_and_constants.hpp"
#include "country_codes_dict_loader.hpp"
#include "forecast_1_or_5_days.hpp"
#include "quick_city_finder.hpp"

#define BOOST_TEST_MODULE test
#include <boost/test/included/unit_test.hpp>

using namespace std;

string bundle_path = "/Users/iliaukhov/Documents/UmbrellaTestResources/";

unordered_map<cities::country_code, cities::city_name>
sample_country_codes_dict =
{
    {"GB", "Great Britain"}
,   {"AU", "Australia"}
,   {"SJ", "Spitzbergen"}
,   {"UA", "Ukraine"}
};

string read_from_test_file(string file)
{
    ifstream ifs{bundle_path + file};
    stringstream stream;
    stream << ifs.rdbuf();
    ifs.close();
    return stream.str();
}

BOOST_AUTO_TEST_CASE(check_country_codes_dict_loader)
{
    cities::country_codes_dict_loader::load(bundle_path);
    auto opt_dict = cities::country_codes_dict_loader::get_country_codes_dict();
    auto dict = opt_dict.get();
    
    BOOST_REQUIRE_EQUAL((bool) opt_dict, true);
    
    BOOST_CHECK_EQUAL(dict.at("AW"), "Aruba");
    BOOST_CHECK_EQUAL(dict.at("NL"), "Netherlands");
    BOOST_CHECK_EQUAL(dict.at("NO"), "Norway");
    
    BOOST_CHECK_THROW(dict.at("ZZ"), out_of_range);
}


BOOST_AUTO_TEST_CASE(check_json_parser_get_city)
{
    weather::json_interpreter json_parser{sample_country_codes_dict};
    json_parser.read(read_from_test_file("forecast_example_Kiev.json"));
    
    cities::city city = json_parser.get_city();
    
    BOOST_CHECK_EQUAL(city.first, "Kiev, Ukraine");
    BOOST_CHECK_EQUAL(city.second, 703448);
}

BOOST_AUTO_TEST_CASE(check_json_parser_get_short_forecast)
{
    weather::json_interpreter json_parser{sample_country_codes_dict};
    json_parser.read(read_from_test_file("forecast_example_Kiev.json"));
    
    weather::short_forecast forecast = json_parser.get_short_forecast();
    auto first = *(forecast->begin());
    
    BOOST_CHECK_EQUAL(forecast->size(), 8);
    BOOST_CHECK_EQUAL(first->description(), "light rain");
}

BOOST_AUTO_TEST_CASE(check_json_parser_get_long_forecast)
{
    weather::json_interpreter json_parser{sample_country_codes_dict};
    json_parser.read(read_from_test_file("forecast_example_Kiev.json"));
    
    weather::long_forecast forecast = json_parser.get_long_forecast();
    auto first = *(forecast->begin());
    
    BOOST_CHECK_EQUAL(forecast->size(), 4);
    BOOST_CHECK_EQUAL(first->description(), "mostly light rain");
}

BOOST_AUTO_TEST_CASE(check_city_finder_get_similar_cities)
{
    cities::country_codes_dict_loader::load(bundle_path);
    auto opt_dict = cities::country_codes_dict_loader::get_country_codes_dict();
    
    if (!opt_dict) BOOST_FAIL("cities::country_codes_dict_loader error");
    
    auto dict = opt_dict.get();
    cities::quick_city_finder finder{bundle_path, dict};
    
    BOOST_CHECK_EQUAL(finder.get_big_cities().size(), 41);
    BOOST_CHECK_EQUAL(finder.get_similar_cities("Ki", 10).size(), 10);
}

BOOST_AUTO_TEST_CASE(check_delete)
{
    cities::quick_city_finder* finder =
        new cities::quick_city_finder{bundle_path, sample_country_codes_dict};
    cities::city_finder* finder_parent = finder;
    
    delete finder_parent;
    
}
