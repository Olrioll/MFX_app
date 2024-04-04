#ifndef DMXWRITER_H
#define DMXWRITER_H

#include <QThread>
#include <QObject>
#include "DMXDevice.h"
class QDMXWriter : public QThread
{
public:
	explicit QDMXWriter();
	void run() override;
	void init(DMXDevice* device, QByteArray data);
	void stop();
	void changeData(QByteArray data);

signals:
	void writeFinished();


private: 
	void sleepRemainder(QElapsedTimer timer, bool stability);

	QByteArray m_data;
	DMXDevice* m_device;
	bool m_running;
};

#endif // DMXWRITER_H
