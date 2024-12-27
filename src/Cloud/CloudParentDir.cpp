#include "CloudParentDir.h"

CloudParentDir::CloudParentDir( std::shared_ptr<CloudSync::Resource> res, QObject* parent /*= nullptr*/ )
    : CloudResource( res, parent )
{
    setName( ".." );
}
