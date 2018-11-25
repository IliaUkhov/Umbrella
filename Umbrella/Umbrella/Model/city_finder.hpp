//
//  city_finder.hpp
//  Umbrella
//
//  Created by Ilia Ukhov on 10/12/18.
//  Copyright © 2018 Ilia Ukhov. All rights reserved.
//

#ifndef city_finder_hpp
#define city_finder_hpp

#include "aliases_and_constants.hpp"

#include <vector>

namespace cities
{

class city_finder
{
public:

    virtual std::vector<city>
    get_similar_cities(
        const std::string& name_part
,       size_t n
    ) = 0;

    virtual std::vector<city>
    get_big_cities() = 0;
    
    virtual
    ~city_finder() = default;
};

} /* namespace cities */

#endif /* city_finder_hpp */
