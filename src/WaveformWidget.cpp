#include "WaveformWidget.h"

#include <QPainter>

WaveformWidget::WaveformWidget(QQuickItem *parent) : QQuickPaintedItem(parent), _track(this)
{
    connect(&_track, &AudioTrackRepresentation::bufferCreated, [this](){showAll();});
    _track.loadFile("scorpions.mp3");
}

void WaveformWidget::paint(QPainter *painter)
{
    QBrush  brush(Qt::white);
    QPen pen;
    pen.setBrush(brush);

    painter->setPen(pen);
    painter->setRenderHints(QPainter::Antialiasing, true);
    painter->setBrush(brush);

    int maxY = boundingRect().height() / 2;
    float maxAmplitude = 0.f;
    for(auto & i : _currentSamples)
    {
        if (i > maxAmplitude)
           maxAmplitude = i;
    }

    for(int i = 0; i < _currentSamples.size(); i++)
    {
        int amplitude = maxY * _currentSamples[i];
        painter->drawLine(i + 1 , maxY - amplitude / 2 * m_scaleFactor,  i + 1, maxY + amplitude / 2  * m_scaleFactor);
    }
}

void WaveformWidget::refresh()
{
    _currentSamples = _track.getSamples(m_min, m_max, boundingRect().width());
    update();
}

void WaveformWidget::setMax(int max)
{
    if (m_max == max)
        return;

    if(max <= _track.samplesCount())
        m_max = max;
    else
        m_max = _track.samplesCount();

    refresh();
    emit maxChanged(m_max);
}

void WaveformWidget::setMin(int min)
{
    if (m_min == min)
        return;

    if(min > 0)
        m_min = min;
    else
        m_min = 0;

    refresh();
    emit minChanged(m_min);
}

void WaveformWidget::moveVisibleRange(double pos)
{
    int range = m_max - m_min;
    int tempMin = _track.samplesCount() * pos - range / 2;
    int tempMax = _track.samplesCount() * pos + range / 2;

    if(tempMin > 0 && tempMax < _track.samplesCount())
    {
        m_min = tempMin;
        m_max = tempMax;
        refresh();
    }
}

void WaveformWidget::showAll()
{
    m_min = 0;
    m_max = _track.samplesCount();
    refresh();
}

void WaveformWidget::zoomIn()
{
    setMax(m_max - 150000);
    setMin(m_min + 150000);
    refresh();
}

void WaveformWidget::zoomOut()
{
    setMax(m_max + 150000);
    setMin(m_min - 150000);
    refresh();
}

void WaveformWidget::setscaleFactor(float scaleFactor)
{
    m_scaleFactor = scaleFactor;
    refresh();
    emit scaleFactorChanged(m_scaleFactor);
}
