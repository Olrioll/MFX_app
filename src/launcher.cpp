#include <QApplication>
#include <QProcess>
#include <QScreen>
#include <QDebug>

int main(int argc, char** argv)
{
    QApplication app(argc, argv);
    QProcess proc;
    QStringList args = {};

    QScreen* screen = QApplication::screens().at(0);
    QSize size = screen->availableSize();

    if(size.width() > 1920)
    {
        args.append("-platform");
        args.append("windows:dpiawareness=0");
        qDebug() << "launched for 4K";
    }

    else
        qDebug() << "launched for FullHD";

    proc.startDetached("MFX.exe", args);
    return 0;
}
