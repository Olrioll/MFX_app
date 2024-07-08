#ifndef WAVEFORMWIDGET_H
#define WAVEFORMWIDGET_H

#include <QMediaPlayer>
#include <QQuickPaintedItem>
#include <QTimer>
#include <QtMath>
#include "AudioTrackRepresentation.h"
#include "DmxWorker.h"
#include <QSGGeometryNode>

#define USEOPENGL   // option for use standart Paint or OpenGl UpdatePaintNode


#ifdef USEOPENGL
class WaveformWidget : public QQuickItem
        #else
class WaveformWidget : public QQuickPaintedItem
        #endif
{
    Q_OBJECT

public:

    explicit WaveformWidget(QQuickItem *parent = nullptr);
    float scaleFactor() const;

protected:

#ifdef USEOPENGL
    virtual QSGNode *updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData* updatePaintNodeData) override;
#else
    void paint(QPainter *painter)override;
#endif

public slots:

    void setAudioTrackFile(const QString& fileName);

    qint64 duration() const;
    static qint64 sampleCount();
    void setMax(const float maxMsec);
    void setMin(const float minMsec);
    void setMinMax(const float minMSec, const float maxMsec);
    void setMaxSample(const qint64 max);
    void setMinSample(const qint64 min);
    void setPlayerPosition(const qint64 pos);
    qint64 playerPosition() const;
    void setVolume(const int value);
    void setStereoMode(bool state);
    QString maxString() const;
    QString minString() const;
    QString positionString(qint64 pos, QString format) const;
    qint64 maxo() const;
    qint64 mino() const;
    qint64 maxSample() const;
    qint64 minSample() const;
    float ratio() const;
    void moveVisibleRange(qint64 pos);
    void showAll();
    void setscaleFactor(float scaleFactor);
    void setHourTimer(bool isMoreThanHour);

    void play();
    void pause();
    void stop();

signals:
    void trackDownloading();
    void trackDownloaded();
    void trackFail();
    void maxChanged(qint64 max);
    void minChanged(qint64 min);
    void scaleFactorChanged(float scaleFactor);
    void positionChanged(qint64 position);
    void timerValueChanged(QString value);
    void channelAudioChanged(bool isStereoTrack);

private:

    QString _audioTrackFile;
    static AudioTrackRepresentation _track;
    /*static*/ QMediaPlayer _player;
    //    QTimer _valueForPositionTimer; //changind to _player setNotifyInterval --- old and maybe unused
    qint64 m_max = 0;
    qint64 m_min = 0;
    float _ratio = 1.f; // Количество фреймов в миллисекунде
    float m_scaleFactor = 1.f;
    bool _isStereoMode = false;
    std::vector<qint16> m_displayMins;
    std::vector<qint16> m_displayMaxes;
    std::vector<qint16> m_displayMinsR;
    std::vector<qint16> m_displayMaxesR;
    std::vector<float>  m_rms;
    std::vector<float>  m_rmsR;
    qint64 m_oldMax = 0;
    qint64 m_oldMin = 0;
    double m_framesPerPixel = 0;
    bool m_isMoreHour = false;
};

#endif // WAVEFORMWIDGET_H
