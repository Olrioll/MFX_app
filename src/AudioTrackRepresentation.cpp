#include "AudioTrackRepresentation.h"

#include <QDebug>

AudioTrackRepresentation::AudioTrackRepresentation(QObject *parent) : QObject(parent)
{
    connect(&_decoder, SIGNAL(bufferReady()), this, SLOT(createBuffer()));
    connect(&_decoder, &QAudioDecoder::finished, this, &AudioTrackRepresentation::bufferCreated);

}

float AudioTrackRepresentation::maxAmplitude() const
{
    return _maxAmplitude;
}

void AudioTrackRepresentation::loadFile(const QString &fileName)
{
    _samples.clear();
    _samplesLeft.clear();
    _samplesRight.clear();
    _maxAmplitude = 0.f;
    _decoder.setSourceFilename(fileName);
    _decoder.start();
}

void AudioTrackRepresentation::createBuffer()
{
    _buffer = _decoder.read();
    qreal peak = getPeakValue(_buffer.format());
    QAudioBuffer::S16U *data = _buffer.data<QAudioBuffer::S16U>();
    for (int i = 0; i < _buffer.frameCount(); i++)
    {
        float val = pow(10, data[i].average() / peak);
//        float val = data[i].average() / peak;
        if(val > _maxAmplitude)
        {
            _maxAmplitude = val;
        }
        _samples.append(val);
        _samplesLeft.append(pow(10, data[i].left / peak));
        _samplesRight.append(pow(10, data[i].right / peak));
    }
}

QVector<float> AudioTrackRepresentation::getSamples() const
{
    return _samples;
}

QVector<float> AudioTrackRepresentation::getSamples(int min, int max, int samplesCount, float gain) const
{
    QVector<float> samples;
    int step = 1;
    if( (max - min) > samplesCount )
        step = (max - min) / samplesCount;

    int counter = 0;
    float acc = 0.f;
    for(int i = min; i < max; i ++)
    {
        counter++;
        float curr = abs(_samples[i]);
        if(curr > gain)
            acc += curr;

        if(counter == step)
        {
            counter = 0;
            samples.append(acc / step);
            acc = 0.f;
//            qDebug() << acc / step;
        }
    }

    return samples;
}

void AudioTrackRepresentation::getSamples(int min, int max, QVector<float> &average, QVector<float> &left, QVector<float> &right) const
{
    average = _samples.mid(min, max - min + 1);
    left = _samplesLeft.mid(min, max - min + 1);
    right = _samplesRight.mid(min, max - min + 1);
}

qint64 AudioTrackRepresentation::duration() const
{
    return _buffer.duration() / 1000;
}

qreal AudioTrackRepresentation::getPeakValue(const QAudioFormat &format)
{
    qreal ret(0);
    if (format.isValid())
    {
        switch (format.sampleType())
        {
        case QAudioFormat::Unknown:
            break;
        case QAudioFormat::Float:
            if (format.sampleSize() != 32) // other sample formats are not supported
                ret = 0;
            else
                ret = 1.00003;
            break;
        case QAudioFormat::SignedInt:
            if (format.sampleSize() == 32)
#ifdef Q_OS_WIN
                ret = INT_MAX;
#endif
#ifdef Q_OS_UNIX
            ret = SHRT_MAX;
#endif
            else if (format.sampleSize() == 16)
                ret = SHRT_MAX;
            else if (format.sampleSize() == 8)
                ret = CHAR_MAX;
            break;
        case QAudioFormat::UnSignedInt:
            if (format.sampleSize() == 32)
                ret = UINT_MAX;
            else if (format.sampleSize() == 16)
                ret = USHRT_MAX;
            else if (format.sampleSize() == 8)
                ret = UCHAR_MAX;
            break;
        default:
            break;
        }
    }
    return ret;
}
