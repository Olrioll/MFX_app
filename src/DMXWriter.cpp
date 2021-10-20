#include "DMXWriter.h"

QDMXWriter::QDMXWriter()
{
    m_data.resize(512);
    m_data.fill(0, 512);
    m_device = NULL;
    m_running = false;
}

void QDMXWriter::init(DMXDevice* device, QByteArray data) {
    m_data = data;
    m_device = device;
}

void QDMXWriter::changeData(QByteArray data)
{
    m_data = data;
}

void QDMXWriter::stop() {
    m_running = false;
}

void QDMXWriter::run()
{
    QElapsedTimer timer;
    timer.start();
    usleep(1000);
    bool stability = timer.elapsed() <= 3;
    bool status = false;
    m_running = true;
    while (m_running) {
        timer.restart();

        //status = m_device->setBreak(true);
        if (!m_device->setBreak(true)) {
            sleepRemainder(timer, stability);
            continue;
        }

        if (stability) usleep(110);

        //status = m_device->setBreak(false);
        if (!m_device->setBreak(false)) {
            sleepRemainder(timer, stability);
            continue;
        }

        if (stability) usleep(16);

        //status = m_device->write(m_data);
        m_device->write(m_data);

        sleepRemainder(timer, stability);
    }

}


void QDMXWriter::sleepRemainder(QElapsedTimer timer, bool stability) {
	while (timer.elapsed() < 33) {
		if (stability) QThread::usleep(1000);
	}
}

