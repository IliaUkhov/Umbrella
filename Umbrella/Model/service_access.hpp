//
//  service_access.hpp
//  Umbrella
//
//  Created by Ilia Ukhov on 10/18/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef service_access_hpp
#define service_access_hpp

#include "aliases_and_constants.hpp"

namespace service
{

class service_access
{
public:
    
    virtual
    ~service_access() = default;
    
    virtual void
    send_request(cities::city_id id) = 0;
    
    virtual void
    send_request(double lat, double lon) = 0;
    
    virtual void
    add_response_handling(response_handling handling) = 0;
    
    virtual void
    clear_response_handlings() = 0;
};
    
} /* namespace service */

#endif /* service_access_hpp */
