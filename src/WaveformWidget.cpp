#include "WaveformWidget.h"

#include <QPainter>
#include <QPainterPath>
#include <QTime>

WaveformWidget::WaveformWidget(QQuickItem *parent) : QQuickPaintedItem(parent), _track(this)
{
    connect(&_track, &AudioTrackRepresentation::trackDownloaded, [this]()
    {
        _ratio = static_cast<float>(_track.samplesCount()) / static_cast<float>(_player.duration());
        emit trackDownloaded();
    });

    connect(&_valueForPositionTimer, &QTimer::timeout, [this]()
    {
        emit timerValueChanged((QTime(0, 0).addMSecs(_player.position()).toString("hh:mm:ss.zzz")).chopped(1));
        quint64 pos = _player.position() / 10; // the least meaningful time interval is 10 ms
        static quint64 prevPos;
        if(prevPos == pos) { // our time signals should't repeat
            return;
        }
        quint64 diff = pos - prevPos;
        if((diff > 0) && (diff < 10)) { // in case no more than 100 ms was skipped
            for(quint64 i = prevPos; i < pos; i++) {
                emit positionChanged(10 * i); // generate missing signals to ensure our time is consistent and ticks every 10 ms
            }
        }
        prevPos = pos;
    });
    connect(&_player, &QMediaPlayer::stateChanged, DMXWorker::instance(), &DMXWorker::onPlayerStateChanged);
}

void WaveformWidget::paint(QPainter *painter)
{
    if(m_max - m_min == 0)
        return;

    QBrush  brush1(QColor("#646464"));
    QBrush  brush2(QColor("#bbbbbb"));
    QPen pen;
    pen.setBrush(brush1);
    painter->setPen(pen);
    painter->setBrush(brush1);

    painter->setRenderHints(QPainter::Antialiasing, true);

    float maxAmplitude = _track.maxAmplitude() - _track.minAmplitude();
    int maxHeight = boundingRect().height();
    float framesPerPixel = static_cast<float>(m_max - m_min + 1) / static_cast<float>(boundingRect().width());

    if(_isStereoMode)
    {
        // Левый канал
        if(framesPerPixel > 1.f)
        {
            int frameCounter = 0;
            float acc = 0.f;
            float max = 0.f;
            float min = 0.f;

            for(int i = m_min; i <= m_max; i++)
            {
                frameCounter++;
                if(frameCounter < framesPerPixel)
                {
                    acc += _track.getSamplesLeft().at(i) * _track.getSamplesLeft().at(i);

                    if(_track.getSamplesLeft().at(i) > max)
                        max = _track.getSamplesLeft().at(i);
                    else if(_track.getSamplesLeft().at(i) < min)
                        min = _track.getSamplesLeft().at(i);

                    continue;
                }

                float y1 = maxHeight * (_track.maxAmplitude() - min) / maxAmplitude;
                float y2 = maxHeight * (_track.maxAmplitude() - max) / maxAmplitude;

                float scaleFactor = 0.6f;

                y1 += (maxHeight / 2 - y1) * scaleFactor - maxHeight / 4;
                y2 += (maxHeight / 2 - y2) * scaleFactor - maxHeight / 4;
                float x = (i - m_min) / framesPerPixel;

                pen.setBrush(brush1);
                painter->setPen(pen);
                painter->setBrush(brush1);
                painter->drawLine(x, y1,  x, y2);

                float average = qSqrt(acc / framesPerPixel);
                float height = average / maxAmplitude * maxHeight;

                y1 = (maxHeight - height) / 2;
                y2 = y1 + height;

                y1 += (maxHeight / 2 - y1) * scaleFactor - maxHeight / 4;
                y2 += (maxHeight / 2 - y2) * scaleFactor - maxHeight / 4;

                pen.setBrush(brush2);
                painter->setPen(pen);
                painter->setBrush(brush2);
                painter->drawLine(x, y1,  x, y2);

                frameCounter = 0;
                acc = 0.f;
                max = 0.f;
                min = 0.f;
            }
        }

        // Правый канал
        if(framesPerPixel > 1.f)
        {
            int frameCounter = 0;
            float acc = 0.f;
            float max = 0.f;
            float min = 0.f;

            for(int i = m_min; i <= m_max; i++)
            {
                frameCounter++;
                if(frameCounter < framesPerPixel)
                {
                    acc += _track.getSamplesRight().at(i) * _track.getSamplesRight().at(i);

                    if(_track.getSamplesRight().at(i) > max)
                        max = _track.getSamplesRight().at(i);
                    else if(_track.getSamplesRight().at(i) < min)
                        min = _track.getSamplesRight().at(i);

                    continue;
                }

                float y1 = maxHeight * (_track.maxAmplitude() - min) / maxAmplitude;
                float y2 = maxHeight * (_track.maxAmplitude() - max) / maxAmplitude;

                float scaleFactor = 0.6f;

                y1 += (maxHeight / 2 - y1) * scaleFactor + maxHeight / 4;
                y2 += (maxHeight / 2 - y2) * scaleFactor + maxHeight / 4;
                float x = (i - m_min) / framesPerPixel;

                pen.setBrush(brush1);
                painter->setPen(pen);
                painter->setBrush(brush1);
                painter->drawLine(x, y1,  x, y2);

                float average = sqrtf(acc / framesPerPixel);
                float height = average / maxAmplitude * maxHeight;

                y1 = (maxHeight - height) / 2;
                y2 = y1 + height;

                y1 += (maxHeight / 2 - y1) * scaleFactor + maxHeight / 4;
                y2 += (maxHeight / 2 - y2) * scaleFactor + maxHeight / 4;

                pen.setBrush(brush2);
                painter->setPen(pen);
                painter->setBrush(brush2);
                painter->drawLine(x, y1,  x, y2);

                frameCounter = 0;
                acc = 0.f;
                max = 0.f;
                min = 0.f;
            }
        }
    }
    else
    {
        if(framesPerPixel > 1.f)
        {
            int frameCounter = 0;
            float acc = 0.f;
            float max = 0.f;
            float min = 0.f;

            for(int i = m_min; i <= m_max; i++)
            {
                frameCounter++;
                if(frameCounter < framesPerPixel)
                {
                    acc += _track.getSamples().at(i) * _track.getSamples().at(i);

                    if(_track.getSamples().at(i) > max)
                        max = _track.getSamples().at(i);
                    else if(_track.getSamples().at(i) < min)
                        min = _track.getSamples().at(i);

                    continue;
                }

                float y1 = maxHeight * (_track.maxAmplitude() - min) / maxAmplitude;
                float y2 = maxHeight * (_track.maxAmplitude() - max) / maxAmplitude;
                float x = (i - m_min) / framesPerPixel;

                pen.setBrush(brush1);
                painter->setPen(pen);
                painter->setBrush(brush1);
                painter->drawLine(x, y1,  x, y2);

                float average = sqrtf(acc / framesPerPixel);
                float height = average / maxAmplitude * maxHeight;

                y1 = (maxHeight - height) / 2;
                y2 = y1 + height;

                pen.setBrush(brush2);
                painter->setPen(pen);
                painter->setBrush(brush2);
                painter->drawLine(x, y1,  x, y2);

                frameCounter = 0;
                acc = 0.f;
                max = 0.f;
                min = 0.f;
            }
        }

        else // Рисуем по точкам
        {
//            float prevX = 0.f;
//            float prevY = 0.f;

//            for(int i = 0; i < _currentSamples.size(); i++)
//            {
//                float currX = i / framesPerPixel();
//                float currY = maxHeight * (1 - _currentSamples.at(i) / maxAmplitude);

//                painter->drawLine(prevX, prevY, currX, currY);
//                prevX = currX;
//                prevY = currY;
//            }
        }
    }
}

qint64 WaveformWidget::max() const
{
    return m_max / _ratio;
}

qint64 WaveformWidget::min() const
{
    return m_min / _ratio;
}

qint64 WaveformWidget::maxSample() const
{
    return m_max;
}

qint64 WaveformWidget::minSample() const
{
    return m_min;
}

float WaveformWidget::ratio() const
{
    return _ratio;
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

qint64 WaveformWidget::duration() const
{
    return _player.duration();
}

qint64 WaveformWidget::sampleCount() const
{
    return _track.samplesCount();
}

void WaveformWidget::setMax(qint64 maxMsec)
{
    if (m_max == maxMsec * _ratio)
        return;

    if(maxMsec * _ratio <= _track.samplesCount())
        m_max = maxMsec * _ratio;
    else
        m_max = _track.samplesCount();

    update();
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

    update();
    emit minChanged(m_min);
}

void WaveformWidget::setMaxSample(qint64 max)
{
    if (m_max == max)
        return;

    if(max <= _track.samplesCount())
        m_max = max;
    else
        m_max = _track.samplesCount() - 1;

    update();
    emit maxChanged(m_max);
}

void WaveformWidget::setMinSample(qint64 min)
{
    if (m_min == min)
        return;

    if(min > 0)
        m_min = min;
    else
        m_min = 0;

    update();
    emit minChanged(m_min);
}

void WaveformWidget::setPlayerPosition(qint64 pos)
{
    _player.setPosition(pos);
}

qint64 WaveformWidget::playerPosition() const
{
   return _player.position();
}

void WaveformWidget::setVolume(int value)
{
    _player.setVolume(value);
}

void WaveformWidget::setStereoMode(bool state)
{
    _isStereoMode = state;
    update();
}

void WaveformWidget::moveVisibleRange(qint64 pos)
{
    qint64 tempMin = m_min + pos * _ratio;
    qint64 tempMax = m_max + pos * _ratio;

    if(tempMin > 0 && tempMax < _track.samplesCount())
    {
        m_min = tempMin;
        m_max = tempMax;
        emit minChanged(m_min);
        emit maxChanged(m_max);
        update();
    }
}

void WaveformWidget::showAll()
{
    m_min = 0;
    m_max = _track.samplesCount();
    emit minChanged(m_min);
    emit maxChanged(m_max);
    update();
}

void WaveformWidget::setscaleFactor(float scaleFactor)
{
    m_scaleFactor = scaleFactor;
    update();
    emit scaleFactorChanged(m_scaleFactor);
}

void WaveformWidget::play()
{
    _valueForPositionTimer.start(10);
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
    emit timerValueChanged((QTime(0, 0).addMSecs(_player.position()).toString("hh:mm:ss.zzz")).chopped(1));
    emit positionChanged(_player.position());
}
