//
//  service.cpp
//  Umbrella
//
//  Created by Ilia Ukhov on 10/18/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#include "request_processor.hpp"
#include <thread>
#include <boost/algorithm/string/replace.hpp>
#include <iostream>

using namespace std;
using namespace service;

void
request_processor::send_request(double lat, double lon)
{
    std::string url = boost::replace_all_copy(call_coords_link, "LAT", to_string(lat));
    url = boost::replace_all_copy(url, "LON", to_string(lon));
    std::cout << url << std::endl;
    send_request(url);
}

void
request_processor::send_request(cities::city_id id)
{
    std::string url = boost::replace_all_copy(call_id_link, "ID", to_string(id));
    send_request(url);
}

void
request_processor::send_request(std::string& url)
{
    thread background([this, url]{
        
        future<cpr::Response> future_response;
        
        do
        {
            future_response = cpr::GetAsync(cpr::Url{url});
        }
        while (future_response.wait_for(request_try_interval) != future_status::ready);
        
        auto response = future_response.get();
        
        for (response_handling& handling : this->response_handlings)
        {
            handling(response.status_code, response.text);
        }
    });
    background.detach();
}

void
request_processor::add_response_handling(response_handling handling)
{
    response_handlings.push_back(handling);
}

void
request_processor::clear_response_handlings()
{
    response_handlings.clear();
}
