#include "AudioTrackRepresentation.h"

#include <QDebug>

AudioTrackRepresentation::AudioTrackRepresentation(QObject *parent) : QObject(parent)
{
    _trackDownloadingTimer.setSingleShot(true);
    _trackDownloadingTimer.setInterval(1000);
    connect(&_decoder, SIGNAL(bufferReady()), this, SLOT(createBuffer()));
    connect(&_decoder, SIGNAL(bufferReady()), &_trackDownloadingTimer, SLOT(start()));
    connect(&_trackDownloadingTimer, SIGNAL(timeout()), this, SIGNAL(trackDownloaded()));
    connect(&_decoder, &QAudioDecoder::finished, this, &AudioTrackRepresentation::bufferCreated);
}

float AudioTrackRepresentation::maxAmplitude() const
{
    return _maxAmplitude;
}

float AudioTrackRepresentation::minAmplitude() const
{
    return _minAmplitude;
}

void AudioTrackRepresentation::loadFile(const QString &fileName)
{
    _samples.clear();
    _samplesLeft.clear();
    _samplesRight.clear();
    _maxAmplitude = 0.f;
    _minAmplitude = 0.f;
    _decoder.setSourceFilename(fileName);
    _decoder.start();
    _trackDownloadingTimer.start(1000);
}

void AudioTrackRepresentation::createBuffer()
{
    _buffer = _decoder.read();
    QAudioBuffer::S16S *data = _buffer.data<QAudioBuffer::S16S>();
    for (int i = 0; i < _buffer.frameCount(); i++)
    {
        float val = data[i].average();
        if(val > _maxAmplitude)
        {
            _maxAmplitude = val;
        }

        else if(val < _minAmplitude)
        {
            _minAmplitude = val;
        }

        _samples.append(val);
        _samplesLeft.append(data[i].left);
        _samplesRight.append(data[i].right);
    }
}

const QVector<float> &AudioTrackRepresentation::getSamples() const
{
    return _samples;
}

const QVector<float> &AudioTrackRepresentation::getSamplesLeft() const
{
    return _samplesLeft;
}

const QVector<float> &AudioTrackRepresentation::getSamplesRight() const
{
    return _samplesRight;
}

qint64 AudioTrackRepresentation::duration() const
{
    return _buffer.duration() / 1000;
}
