#pragma once

#include "CloudResource.h"

class CloudParentDir : public CloudResource
{
public:
    explicit CloudParentDir( std::shared_ptr<CloudSync::Resource> res, QObject* parent = nullptr );
};