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

public slots:

    void loadFile(const QString& fileName);
    void createBuffer();
    int samplesCount() const {return _samples.size();}
    QVector<float> getSamples() const;
    QVector<float> getSamples(int min, int max, int samplesCount, float gain) const;
    qint64 duration() const;

signals:

    void bufferCreated();

private:

    qreal getPeakValue(const QAudioFormat& format);

    QAudioDecoder _decoder;
    QAudioBuffer _buffer;
    QVector<float> _samples;

};

#endif // AUDIOTRACKREPRESENTATION_H
