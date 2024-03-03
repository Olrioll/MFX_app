#include "Logger.h"
#include "AppMessageHandler.h"

const QtMessageHandler qtDefaultMessageHandler = qInstallMessageHandler( nullptr );
std::weak_ptr<Logger> appLogger;

void AppMessageHandler( QtMsgType type, const QMessageLogContext& context, const QString& msg )
{
    (qtDefaultMessageHandler)( type, context, msg );

    if( auto logger = appLogger.lock() )
        logger->Log( type, msg, context.file, context.function, context.line );
}

void AssignMessageHandlerToLog( const std::shared_ptr<Logger>& logger )
{
    appLogger = logger;
}