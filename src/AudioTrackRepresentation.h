#ifndef AUDIOTRACKREPRESENTATION_H
#define AUDIOTRACKREPRESENTATION_H

#include <QObject>
#include <QAudioBuffer>
#include <QAudioDecoder>

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
    QVector<float> getSamples() const;
    QVector<float> getSamples(int min, int max, int samplesCount, float gain) const;
    void getSamples(int min, int max, QVector<float>& average, QVector<float>& left, QVector<float>& right) const;
    qint64 duration() const;

signals:

    void bufferCreated();

private:

    qreal getPeakValue(const QAudioFormat& format);

    QAudioDecoder _decoder;
    QAudioBuffer _buffer;
    QVector<float> _samples;
    QVector<float> _samplesLeft;
    QVector<float> _samplesRight;
    float _maxAmplitude = 0.f;
    float _minAmplitude = 0.f;

};

#endif // AUDIOTRACKREPRESENTATION_H
