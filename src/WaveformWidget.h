#ifndef WAVEFORMWIDGET_H
#define WAVEFORMWIDGET_H

#include <QMediaPlayer>
#include <QQuickPaintedItem>
#include <QTimer>
#include "AudioTrackRepresentation.h"

class WaveformWidget : public QQuickPaintedItem
{
    Q_OBJECT

public:

    explicit WaveformWidget(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    float scaleFactor() const;

public slots:

    void setAudioTrackFile(QString fileName);

    qint64 duration() const;
    qint64 sampleCount() const;
    void setMax(qint64 maxMsec);
    void setMin(qint64 minMsec);
    void setMaxSample(qint64 max);
    void setMinSample(qint64 min);
    void setPlayerPosition(qint64 pos);
    qint64 playerPosition() const;
    void setVolume(int value);
    void setStereoMode(bool state);
    QString maxString() const;
    QString minString() const;
    QString positionString(qint64 pos, QString format) const;
    qint64 max() const;
    qint64 min() const;
    qint64 maxSample() const;
    qint64 minSample() const;
    float ratio() const;
    void moveVisibleRange(qint64 pos);
    void showAll();
    void setscaleFactor(float scaleFactor);

    void play();
    void pause();
    void stop();

signals:

    void trackDownloaded();
    void maxChanged(qint64 max);
    void minChanged(qint64 min);
    void scaleFactorChanged(float scaleFactor);
    void positionChanged(qint64 position);
    void timerValueChanged(QString value);

private:

    QString _audioTrackFile;
    AudioTrackRepresentation _track;
    QMediaPlayer _player;
    QTimer _valueForPositionTimer;
    int m_max = 0;
    int m_min = 0;
    float _ratio = 1.f; // Количество фреймов в миллисекунде
    float m_scaleFactor = 1.f;
    bool _isStereoMode = false;
};

#endif // WAVEFORMWIDGET_H
