#include "WaveformWidget.h"

#include <QPainter>
#include <QPainterPath>
#include <QTime>

WaveformWidget::WaveformWidget(QQuickItem *parent) : QQuickPaintedItem(parent), _track(this)
{
    connect(&_track, &AudioTrackRepresentation::bufferCreated, [this]()
    {
        _ratio = static_cast<float>(_track.samplesCount()) / static_cast<float>(_player.duration());
        showAll();
    });

    connect(&_valueForPositionTimer, &QTimer::timeout, [this]()
    {
        emit timerValueChanged(QTime(0, 0).addMSecs(_player.position()).toString("hh:mm:ss.zzz"));
        emit positionChanged(_player.position());
    });
}

void WaveformWidget::paint(QPainter *painter)
{
    QBrush  brush(QColor("#646464"));
    QPen pen;
    pen.setBrush(brush);

    painter->setPen(pen);
    painter->setRenderHints(QPainter::Antialiasing, true);
    painter->setBrush(brush);

    float maxAmplitude = abs(_track.maxAmplitude());
    int maxHeight = boundingRect().height();

    if(_isStereoMode)
    {
        // Левый канал
        if(framesPerPixel() > 100.f)
        {
            int FPP = static_cast<int>(framesPerPixel() + 0.5f); // Округленное до целого количество фреймов на пиксель
            int frameCounter = 0;
            float acc = 0.f;
            for(int i = 0; i < _currentSamplesLeft.size(); i++)
            {
                frameCounter++;
                if(frameCounter < FPP)
                {
                    if(_currentSamplesLeft.at(i) > 1.9f)
                        acc += _track.maxAmplitude();
                    else if(_currentSamplesLeft.at(i) > 1.8f)
                        acc += _currentSamplesLeft.at(i);
                    continue;
                }

                float average = acc / FPP;
                float height =   average / maxAmplitude * (maxHeight / 2 - 10);

                float y1 = ((maxHeight / 2 - 10) - height) / 2;
                float y2 = y1 + height;

                painter->drawLine(i / FPP, y1,  i / FPP, y2);

                frameCounter = 0;
                acc = 0.f;
            }
        }

        else if(framesPerPixel() > 10.f)
        {
            int FPP = static_cast<int>(framesPerPixel() + 0.5f); // Округленное до целого количество фреймов на пиксель
            int frameCounter = 0;
            float acc = 0.f;
            for(int i = 0; i < _currentSamplesLeft.size(); i++)
            {
                frameCounter++;
                if(frameCounter < FPP)
                {
                    if(_currentSamplesLeft.at(i) > 1.9f)
                        acc += _track.maxAmplitude();
                    else if(_currentSamplesLeft.at(i) > 1.8f)
                        acc += _currentSamplesLeft.at(i);
                    else if(_currentSamplesLeft.at(i) > 0.8f)
                        acc += _currentSamplesLeft.at(i) - _currentSamplesLeft.at(i) * 0.5f;
                    else
                        acc += _currentSamplesLeft.at(i) - _currentSamplesLeft.at(i) * 0.3f;
                    continue;
                }

                float average = acc / FPP;
                float height =   average / maxAmplitude * maxHeight / 2;

                float y1 = (maxHeight / 2 - height) / 2;
                float y2 = y1 + height;

                painter->drawLine(i / FPP, y1,  i / FPP, y2);

                frameCounter = 0;
                acc = 0.f;
            }
        }

        // Правый канал
        if(framesPerPixel() > 100.f)
        {
            int FPP = static_cast<int>(framesPerPixel() + 0.5f); // Округленное до целого количество фреймов на пиксель
            int frameCounter = 0;
            float acc = 0.f;
            for(int i = 0; i < _currentSamplesRight.size(); i++)
            {
                frameCounter++;
                if(frameCounter < FPP)
                {
                    if(_currentSamplesRight.at(i) > 1.9f)
                        acc += _track.maxAmplitude();
                    else if(_currentSamplesRight.at(i) > 1.8f)
                        acc += _currentSamplesRight.at(i);
                    continue;
                }

                float average = acc / FPP;
                float height =   average / maxAmplitude * (maxHeight / 2 - 10);

                float y1 = ((maxHeight / 2 - 10) - height) / 2 + maxHeight / 2;
                float y2 = y1 + height;

                painter->drawLine(i / FPP, y1,  i / FPP, y2);

                frameCounter = 0;
                acc = 0.f;
            }
        }

        else if(framesPerPixel() > 10.f)
        {
            int FPP = static_cast<int>(framesPerPixel() + 0.5f); // Округленное до целого количество фреймов на пиксель
            int frameCounter = 0;
            float acc = 0.f;
            for(int i = 0; i < _currentSamplesRight.size(); i++)
            {
                frameCounter++;
                if(frameCounter < FPP)
                {
                    if(_currentSamplesRight.at(i) > 1.9f)
                        acc += _track.maxAmplitude();
                    else if(_currentSamplesRight.at(i) > 1.8f)
                        acc += _currentSamplesRight.at(i);
                    else if(_currentSamplesRight.at(i) > 0.8f)
                        acc += _currentSamplesRight.at(i) - _currentSamplesRight.at(i) * 0.5f;
                    else
                        acc += _currentSamplesRight.at(i) - _currentSamplesRight.at(i) * 0.3f;
                    continue;
                }

                float average = acc / FPP;
                float height =   average / maxAmplitude * maxHeight / 2;

                float y1 = (maxHeight / 2 - height) / 2 + maxHeight / 2;
                float y2 = y1 + height;

                painter->drawLine(i / FPP, y1,  i / FPP, y2);

                frameCounter = 0;
                acc = 0.f;
            }
        }
    }
    else
    {
        if(framesPerPixel() > 100.f)
        {
            int FPP = static_cast<int>(framesPerPixel() + 0.5f); // Округленное до целого количество фреймов на пиксель
            int frameCounter = 0;
            float acc = 0.f;
            for(int i = 0; i < _currentSamples.size(); i++)
            {
                frameCounter++;
                if(frameCounter < FPP)
                {
                    if(_currentSamples.at(i) > 1.9f)
                        acc += _track.maxAmplitude();
                    else if(_currentSamples.at(i) > 1.8f)
                        acc += _currentSamples.at(i);
                    continue;
                }

                float average = acc / FPP;
                float height = average / maxAmplitude * maxHeight;

                float y1 = (maxHeight - height) / 2;
                float y2 = y1 + height;

                painter->drawLine(i / FPP, y1,  i / FPP, y2);

                frameCounter = 0;
                acc = 0.f;
            }
        }

        else if(framesPerPixel() > 10.f)
        {
            int FPP = static_cast<int>(framesPerPixel() + 0.5f); // Округленное до целого количество фреймов на пиксель
            int frameCounter = 0;
            float acc = 0.f;
            for(int i = 0; i < _currentSamples.size(); i++)
            {
                frameCounter++;
                if(frameCounter < FPP)
                {
                    if(_currentSamples.at(i) > 1.9f)
                        acc += _track.maxAmplitude();
                    else if(_currentSamples.at(i) > 1.8f)
                        acc += _currentSamples.at(i);
                    else if(_currentSamples.at(i) > 0.8f)
                        acc += _currentSamples.at(i) - _currentSamples.at(i) * 0.5f;
                    else
                        acc += _currentSamples.at(i) - _currentSamples.at(i) * 0.3f;
                    continue;
                }

                float average = acc / FPP;
                float height =   average / maxAmplitude * maxHeight;

                float y1 = (maxHeight - height) / 2;
                float y2 = y1 + height;

                painter->drawLine(i / FPP, y1,  i / FPP, y2);

                frameCounter = 0;
                acc = 0.f;
            }
        }
    }

//    else if(framesPerPixel() > 1.f)
//    {
//        int FPP = static_cast<int>(framesPerPixel() + 0.5f); // Округленное до целого количество фреймов на пиксель
//        int frameCounter = 0;
//        float max = 0.f;
//        float min = 0.f;
//        for(int i = 0; i < _currentSamples.size(); i++)
//        {
//            frameCounter++;
//            if(frameCounter < FPP)
//            {
//                if(_currentSamples.at(i) > max)
//                    max = _currentSamples.at(i);
//                else if (_currentSamples.at(i) < min)
//                    min = _currentSamples.at(i);

//                continue;
//            }


//            float height =  (maxHeight - min / maxAmplitude * maxHeight) - (maxHeight - max / maxAmplitude * maxHeight);

//            float y1 = (maxHeight - height) / 2;
//            float y2 = y1 + height;

//            painter->drawLine(i / FPP, y1,  i / FPP, y2);

//            frameCounter = 0;
//            max = 0.f;
//            min = 0.f;
//        }
//    }
}

qint64 WaveformWidget::max() const
{
    return m_max / _ratio;
}

qint64 WaveformWidget::min() const
{
    return m_min / _ratio;
}

QString WaveformWidget::maxString() const
{
    return QTime(0, 0).addMSecs(m_max / _ratio).toString("mm:ss");
}

QString WaveformWidget::minString() const
{
    return QTime(0, 0).addMSecs(m_min / _ratio).toString("mm:ss");
}

QString WaveformWidget::positionString(qint64 pos, QString format) const
{
    return QTime(0, 0).addMSecs(pos).toString(format);
}

float WaveformWidget::scaleFactor() const
{
    return m_scaleFactor;
}

void WaveformWidget::setAudioTrackFile(QString fileName)
{
    _audioTrackFile = fileName;
    _player.setMedia(QUrl::fromLocalFile(fileName));
    _track.loadFile(_audioTrackFile);
}

void WaveformWidget::refresh()
{
    _track.getSamples(m_min, m_max, _currentSamples, _currentSamplesLeft, _currentSamplesRight);
    update();
}

qint64 WaveformWidget::duration() const
{
    return _player.duration();
}

void WaveformWidget::setMax(qint64 maxMsec)
{
    if (m_max == maxMsec * _ratio)
        return;

    if(maxMsec * _ratio <= _track.samplesCount())
        m_max = maxMsec * _ratio;
    else
        m_max = _track.samplesCount();

    refresh();
    emit maxChanged(m_max);
}

void WaveformWidget::setMin(qint64 minMsec)
{
    if (m_min == minMsec * _ratio)
        return;

    if(minMsec * _ratio > 0)
        m_min = minMsec * _ratio;
    else
        m_min = 0;

    refresh();
    emit minChanged(m_min);
}

void WaveformWidget::setPlayerPosition(qint64 pos)
{
    _player.setPosition(pos);
}

void WaveformWidget::setVolume(int value)
{
    _player.setVolume(value);
}

void WaveformWidget::setStereoMode(bool state)
{
    _isStereoMode = state;
    refresh();
}

void WaveformWidget::moveVisibleRange(qint64 pos)
{
    qint64 tempMin = m_min + pos * _ratio;
    qint64 tempMax = m_max + pos * _ratio;

    if(tempMin > 0 && tempMax < _track.samplesCount())
    {
        m_min = tempMin;
        m_max = tempMax;
        refresh();
        emit minChanged(m_min);
        emit maxChanged(m_max);
    }
}

void WaveformWidget::showAll()
{
    m_min = 0;
    m_max = _track.samplesCount();
    refresh();
    emit minChanged(m_min);
    emit maxChanged(m_max);
}

void WaveformWidget::zoomIn()
{
    float range = m_max - m_min;
    float newRange = range - range * 0.05;

    if((m_max - (range - newRange) / 2) / _ratio - (m_min + (range - newRange) / 2) / _ratio > 1000) // Разница в 1000 мс
    {
        m_max -= (range - newRange) / 2;
        m_min += (range - newRange) / 2;
        refresh();
        emit minChanged(m_min);
        emit maxChanged(m_max);
    }
}

void WaveformWidget::zoomOut()
{
    float range = m_max - m_min;
    float newRange = range + range * 0.05;

    if(m_max + (newRange - range) / 2 <= _track.samplesCount() && m_min - (newRange - range) / 2 >= 0)
    {
        m_max += (newRange - range) / 2;
        m_min -= (newRange - range) / 2;
    }

    else
    {
        m_max = _track.samplesCount();
        m_min = 0;
    }

    refresh();
    emit minChanged(m_min);
    emit maxChanged(m_max);
}

void WaveformWidget::setscaleFactor(float scaleFactor)
{
    m_scaleFactor = scaleFactor;
    refresh();
    emit scaleFactorChanged(m_scaleFactor);
}

float WaveformWidget::framesPerPixel() const
{
    return static_cast<float>(_currentSamples.size()) / static_cast<float>(boundingRect().width());
}

void WaveformWidget::play()
{
    _valueForPositionTimer.start(20);
    _player.play();
}

void WaveformWidget::pause()
{
    _valueForPositionTimer.stop();
    _player.pause();
}

void WaveformWidget::stop()
{
    _valueForPositionTimer.stop();
    _player.stop();
    emit timerValueChanged(QTime(0, 0).addMSecs(_player.position()).toString("hh:mm:ss.zzz"));
    emit positionChanged(_player.position());
}
