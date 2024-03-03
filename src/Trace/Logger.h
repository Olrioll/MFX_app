#pragma once

#include <QDir>
#include <QMutex>

class Logger
{
public:
    explicit Logger( const QDir& appDir );

    void Log( QtMsgType type, const QString& msg, const QString& file, const QString& func, int line );

private:
    void OpenLogFile();

private:
    QFile m_File;
    QDir m_LogDir;
    QMutex m_Locker;
};