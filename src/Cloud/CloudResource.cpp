#include "CloudResource.h"

#include "CloudSync/Resource.hpp"

CloudResource::CloudResource( QObject* parent /*= nullptr*/ )
    : QObject( parent )
{}

CloudResource::CloudResource( std::shared_ptr<CloudSync::Resource> res, QObject* parent /*= nullptr*/ )
    : QObject( parent )
{
    if( res )
    {
        setType( res->is_file() ? CloudFSItemType::File : CloudFSItemType::Folder );
        setName( QString::fromStdString( res->name() ) );
    }
}