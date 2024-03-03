#pragma once

#include <qlogging.h>

class Logger;

void AppMessageHandler( QtMsgType type, const QMessageLogContext& context, const QString& msg );
void AssignMessageHandlerToLog( const std::shared_ptr<Logger>& logger );