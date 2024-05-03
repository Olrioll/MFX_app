#include <QMutex>
#include <QDateTime>
#include "QDebug"

#include "Logger.h"

constexpr qint64 SIZE_1MB = 1024 * 1024;
constexpr qint64 LOG_MAX_SIZE = SIZE_1MB;
constexpr char APP_NAME[] = "MFX";

Logger::Logger( const QDir& logDir )
{
    m_LogDir = logDir;

    QMutexLocker lock( &m_Locker );

    OpenLogFile();
}

void Logger::Log( QtMsgType type, const QString& msg, const QString& file, const QString& func, int line )
{
    static QHash<QtMsgType, QString> msgLevelHash
    {
        {QtDebugMsg, "Debug"},
        {QtInfoMsg, "Info"},
        {QtWarningMsg, "Warning"},
        {QtCriticalMsg, "Critical"},
        {QtFatalMsg, "Fatal"}
    };

    QMutexLocker lock( &m_Locker );

    if( m_File.isOpen() )
    {
        if( m_File.size() >= LOG_MAX_SIZE )
            OpenLogFile(); // rotate log file

        if( m_File.isOpen() )
        {
            const QString time = QDateTime::currentDateTime().toString( "dd.MM.yyyy hh:mm:ss.zzz " );
            QString str = QString( "%1 [%2]: " ).arg( time, msgLevelHash[type] );

            if( !func.isEmpty() )
              str.append( func ).append( ". " );

            str.append( msg );

            if( !file.isEmpty() )
              str.append( " (at " ).append( file ).append( ":" ).append( std::to_string( line ).c_str() ).append( ")" );

            str.append( "\n" );

            m_File.write( str.toUtf8() );
            m_File.flush();
        }
    }
}

void Logger::OpenLogFile()
{
    const QString time = QDateTime::currentDateTime().toString( "yyyy_MM_dd-hh_mm_ss" );
    const QString file = QString( APP_NAME ).append( "_" ).append( time ).append( ".log" );
    const QString path = m_LogDir.filePath( file );

    if( !m_LogDir.exists() )
        m_LogDir.mkdir( "." );

    m_File.close();
    m_File.setFileName( path );

    if( !m_File.open( QIODevice::Append | QIODevice::Text ) )
        qCritical() << "error opening log file" << path;
}