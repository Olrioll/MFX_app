#ifndef WAVEFORMWIDGET_H
#define WAVEFORMWIDGET_H

#include <QQuickPaintedItem>
#include "AudioTrackRepresentation.h"

class WaveformWidget : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(int max READ max WRITE setMax NOTIFY maxChanged)
    Q_PROPERTY(int min READ min WRITE setMin NOTIFY minChanged)
    Q_PROPERTY(float scaleFactor READ scaleFactor WRITE setscaleFactor NOTIFY scaleFactorChanged)

public:

    explicit WaveformWidget(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    int max() const
    {
        return m_max;
    }

    int min() const
    {
        return m_min;
    }

    float scaleFactor() const
    {
        return m_scaleFactor;
    }

public slots:

    void refresh();
    void setMax(int max);
    void setMin(int min);
    void moveVisibleRange(double pos);
    void showAll();
    void zoomIn();
    void zoomOut();

    void setscaleFactor(float scaleFactor);

signals:
    void maxChanged(int max);

    void minChanged(int min);

    void scaleFactorChanged(float scaleFactor);

private:

    AudioTrackRepresentation _track;
    QVector<float> _currentSamples;
    int m_max = 1100000;
    int m_min = 0;
    float m_scaleFactor = 2.f;
};

#endif // WAVEFORMWIDGET_H
