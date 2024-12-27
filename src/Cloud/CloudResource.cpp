#include "CloudResource.h"

#include "CloudSync/Resource.hpp"

CloudResource::CloudResource( std::shared_ptr<CloudSync::Resource> res, QObject* parent /*= nullptr*/ )
    : QObject( parent )
    , mCloudRes( res )
{
    if( mCloudRes )
    {
        setType( mCloudRes->is_file() ? CloudFSItemType::File : CloudFSItemType::Folder );
        setName( QString::fromStdString( mCloudRes->name() ) );
    }
}