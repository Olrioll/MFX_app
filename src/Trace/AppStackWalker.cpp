#include <QDebug>
#include "AppStackWalker.h"

void AppStackWalker::OnOutput( LPCSTR szText )
{
  qDebug() << szText;
  StackWalker::OnOutput( szText );
}