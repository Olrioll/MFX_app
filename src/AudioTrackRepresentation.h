#ifndef AUDIOTRACKREPRESENTATION_H
#define AUDIOTRACKREPRESENTATION_H

#include <QObject>
#include <QAudioBuffer>
#include <QAudioDecoder>
#include <QTimer>

class AudioTrackRepresentation : public QObject
{
    Q_OBJECT

public:
    explicit AudioTrackRepresentation(QObject *parent = nullptr);
    float maxAmplitude() const;
    float minAmplitude() const;

public slots:

    void loadFile(const QString& fileName);
    void createBuffer();
    int samplesCount() const {return _samples.size();}
    const QVector<float>& getSamples() const;
    const QVector<float>& getSamplesLeft() const;
    const QVector<float>& getSamplesRight() const;
    qint64 duration() const;

signals:

    void bufferCreated();
    void trackDownloaded();

private:

    QAudioDecoder _decoder;
    QAudioBuffer _buffer;
    QVector<float> _samples;
    QVector<float> _samplesLeft;
    QVector<float> _samplesRight;
    float _maxAmplitude = 0.f;
    float _minAmplitude = 0.f;

    QTimer _trackDownloadingTimer;
};

#endif // AUDIOTRACKREPRESENTATION_H
