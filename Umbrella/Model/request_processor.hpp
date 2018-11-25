//
//  request_processor.hpp
//  Umbrella
//
//  Created by Ilia Ukhov on 10/18/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#include "service_access.hpp"
#include <cpr/cpr.h>
#include <vector>

namespace service
{

class request_processor: public service_access
{
    std::vector<response_handling> response_handlings;
    
public:
    
    void
    send_request(cities::city_id id) override;
    
    void
    send_request(double lat, double lon) override;
    
    void
    add_response_handling(response_handling handling) override;
    
    void
    clear_response_handlings() override;
    
private:
    
    void
    send_request(std::string& url);
};

} /* namespace service */
