#include "AudioTrackRepresentation.h"
#include <QAudioBuffer>

#include <cmath>

#include <QDebug>

FrameBlock::FrameBlock( const size_t len )
{
    std::memset( mSamples, 0, sizeof mSamples );
    std::memset( mMaxLut, 0, sizeof mMaxLut );
    std::memset( mMinLut, 0, sizeof mMinLut );
    std::memset( mRms, 0, sizeof mRms );
    mLen = len;

    assert( mLen <= MAX_FRAMES );
}

void FrameBlock::addSample( const qint16 val )
{
    assert( mLen < MAX_FRAMES );
    mSamples[mLen++] = val;
}

void FrameBlock::initLuts()
{
    if( mLen == MAX_FRAMES )
    {
        std::iota( std::begin( mMaxLut ), std::end( mMaxLut ), 0 );
        std::for_each( std::execution::par, std::cbegin( mMaxLut ), std::cend( mMaxLut ),
            [&]( const qint16& n )
        {
            const auto i = n;
            const auto it = i * FRAMES_PER_LUT;
            qint16* currentSample = mSamples + it;
            qint16 _min = INT16_MAX;
            qint16 _max = INT16_MIN;
            float _rms = 0.f;
            for( unsigned j = 0; j < FRAMES_PER_LUT; j++ )
            {
                _rms += static_cast<float>(*currentSample) * static_cast<float>(*currentSample);
                _min = std::min( *currentSample, _min );
                _max = std::max( *currentSample, _max );
                currentSample++;
            }
            mRms[i] = _rms;
            mMaxLut[i] = _max;
            mMinLut[i] = _min;
        } );
    }
    else
    {
        qint16* currentSample = mSamples;
        qint16* lastSample = mSamples + mLen;
        for( unsigned i = 0; i < LUT_SIZE; i++ )
        {
            qint16 _min = INT16_MAX;
            qint16 _max = INT16_MIN;
            float _rms = 0.f;
            for( unsigned j = 0; j < FRAMES_PER_LUT; j++ )
            {
                if( currentSample >= lastSample )
                    break;

                _rms += static_cast<float>(*currentSample) * static_cast<float>(*currentSample);
                _min = std::min( *currentSample, _min );
                _max = std::max( *currentSample, _max );
                currentSample++;
            }
            mRms[i] = _rms;
            mMaxLut[i] = _max;
            mMinLut[i] = _min;
        }
    }
}

//////////////////////////////////////////////////////////////////////////
size_t WaveFormChannel::getLength() const
{
	size_t len = 0;
	for (const auto& mBlock : m_blocks)
		len += mBlock.mLen;
	return len;
}

void WaveFormChannel::setMaxAmplitude(const qint16 max)
{
	maxAmplitude = max;
}


WaveFormChannel::FramePos WaveFormChannel::getFramePosFromSampleIdx(size_t sampleIdx) const
{
    size_t blockIdx = 0;

    if (m_blocks.empty())
        return FramePos(0, 0);

    while( sampleIdx >= m_blocks[blockIdx].mLen )
    {
        if( blockIdx + 1 == m_blocks.size() )
            return FramePos( blockIdx, m_blocks[blockIdx].mLen );

        sampleIdx -= m_blocks[blockIdx].mLen;
        ++blockIdx;
    }

    return FramePos(blockIdx, sampleIdx);
}

FrameBlock* WaveFormChannel::incrementFramePos( FramePos* pos, size_t numSamples )
{
    if( pos->mBlockIdx >= m_blocks.size() )
        return nullptr;

    FrameBlock* block = &m_blocks[pos->mBlockIdx];
    assert( pos->mSampleIdx < block->mLen && "invalid position" );

    while( numSamples )
    {
        if( pos->mSampleIdx + numSamples < block->mLen )
        {
            pos->mSampleIdx += numSamples;
            numSamples = 0;
        }
        else
        {
            numSamples -= block->mLen - pos->mSampleIdx;

            if( pos->mBlockIdx + 1 == m_blocks.size() )
                return nullptr;

            pos->mBlockIdx++;
            block = &m_blocks[pos->mBlockIdx];
            pos->mSampleIdx = 0;
        }
    }

    return block;
}

void WaveFormChannel::insertSilent(const size_t _size)
{
    size_t size = _size;
    while (size > MAX_FRAMES)
    {
        m_blocks.emplace(m_blocks.begin(), MAX_FRAMES);
        size -= MAX_FRAMES;
    }

    if (size > 0)
        m_blocks.emplace(m_blocks.begin(), size);
}


void WaveFormChannel::calculateLuts( FramePos* pos, size_t numSamples, qint16* resultMin, qint16* resultMax, float* rms )
{
    assert( pos->mBlockIdx < m_blocks.size() );

    FrameBlock* block = &m_blocks[pos->mBlockIdx];

    qint16 _min = INT16_MAX;
    qint16 _max = INT16_MIN;
    float _rms = 0.f;

    {
        constexpr unsigned int lutItemBoundaryMask = FRAMES_PER_LUT - 1;
        const unsigned int numSamplesToNextLutItemBoundary = (FRAMES_PER_LUT - pos->mSampleIdx) & lutItemBoundaryMask;
        size_t numSlowSamples = numSamplesToNextLutItemBoundary;
        if( numSlowSamples > numSamples )
            numSlowSamples = numSamples;
        if( numSlowSamples > block->mLen )
            numSlowSamples = block->mLen;

        size_t idx = pos->mSampleIdx;
        size_t endIdx = idx + numSlowSamples;
        if( endIdx > block->mLen )
            endIdx = block->mLen;

        while( idx < endIdx )
        {
            _min = std::min( block->mSamples[idx], _min );
            _max = std::max( block->mSamples[idx], _max );
            _rms += static_cast<float>(block->mSamples[idx]) * static_cast<float>(block->mSamples[idx]);
            idx++;
        }

        numSamples -= numSlowSamples;
        block = incrementFramePos( pos, numSlowSamples );
    }

    while( block && numSamples > FRAMES_PER_LUT )
    {
        const size_t numLutItemsWeNeed = numSamples / FRAMES_PER_LUT;
        size_t currentLutItemIdx = pos->mSampleIdx / FRAMES_PER_LUT;
        const size_t numLutItemsInThisBlock = ((block->mLen - 1) / FRAMES_PER_LUT) + 1;
        const size_t numLutItemsLeftInThisBlock = numLutItemsInThisBlock - currentLutItemIdx;

        size_t numLutItemsToUse = numLutItemsWeNeed;
        if( numLutItemsLeftInThisBlock < numLutItemsToUse )
            numLutItemsToUse = numLutItemsLeftInThisBlock;

        const size_t endLutItemIdx = currentLutItemIdx + numLutItemsToUse;
        while( currentLutItemIdx < endLutItemIdx )
        {
            _min = std::min( block->mMinLut[currentLutItemIdx], _min );
            _max = std::max( block->mMaxLut[currentLutItemIdx], _max );
            _rms += block->mRms[currentLutItemIdx];
            currentLutItemIdx++;
        }

        const size_t numSamplesLeftInThisBlockBeforeWeDidTheFastBit = block->mLen - pos->mSampleIdx;
        size_t numSamplesProcessedThisIteration = numLutItemsToUse * FRAMES_PER_LUT;
        if( numSamples > numSamplesLeftInThisBlockBeforeWeDidTheFastBit )
            numSamplesProcessedThisIteration = numSamplesLeftInThisBlockBeforeWeDidTheFastBit;

        numSamples -= numSamplesProcessedThisIteration;
        block = incrementFramePos( pos, numSamplesProcessedThisIteration );
    }

    while( block && numSamples )
    {
        size_t idx = pos->mSampleIdx;
        size_t endIdx = pos->mSampleIdx + numSamples;

        if( endIdx > block->mLen )
            endIdx = block->mLen;

        const size_t numSamplesThisIteration = endIdx - idx;
        while( idx < endIdx )
        {
            _min = std::min( block->mSamples[idx], _min );
            _max = std::max( block->mSamples[idx], _max );
            _rms += static_cast<float>(block->mSamples[idx]) * static_cast<float>(block->mSamples[idx]);
            idx++;
        }

        block = incrementFramePos( pos, numSamplesThisIteration );
        numSamples -= numSamplesThisIteration;
    }

    *resultMin = _min;
    *resultMax = _max;
    *rms = _rms;
}

inline float sqrtFast(const float& n)
{
	static union
	{
		int i;
		float f;
	} u;
	u.i = 0x5F375A86 - (*(int*)&n >> 1);
	return (3 - n * u.f * u.f) * n * u.f * 0.5f;
}

void WaveFormChannel::calculateWaveForm( const size_t startSampleIdx, qint16* mins, qint16* maxes,
                                         const size_t widthInPixels, const double samplesPerPixel, float* rms )
{
    FramePos pos = getFramePosFromSampleIdx( startSampleIdx );

    const double widthErrorPerPixel = samplesPerPixel - std::floor( samplesPerPixel );
    double error = 0;
    for( size_t x = 0; x < widthInPixels; x++ )
    {
        if( pos.mBlockIdx < m_blocks.size() )
        {
            auto samplesThisPixel = static_cast<size_t>(samplesPerPixel);
            if( error > 1.0 )
            {
                samplesThisPixel++;
                error -= 1.0;
            }
            error += widthErrorPerPixel;

            calculateLuts( &pos, samplesThisPixel, &mins[0] + x, &maxes[0] + x, &rms[0] + x );

            if( x > 0 )
            {
                if( mins[x] > maxes[x - 1] )
                    mins[x] = static_cast<qint16>(maxes[x - 1] + 1);
                if( maxes[x] < mins[x - 1] )
                    maxes[x] = static_cast<qint16>(mins[x - 1] - 1);
            }
        }
        else
        {
            mins[x] = 0;
            maxes[x] = 0;
            rms[x] = 0;
        }

        rms[x] = sqrtFast( rms[x] / static_cast<float>(samplesPerPixel) );
    }

    /*for (size_t x = 0; x < widthInPixels; ++x)
    {
        rms[x] = sqrtFast(rms[x] / static_cast<float>(samplesPerPixel));
    }*/
}

AudioTrackRepresentation::AudioTrackRepresentation( QObject* parent ) : QObject( parent )
{
    //    _decoder = new QAudioDecoder(this);
    _trackDownloadingTimer.setSingleShot( true );
    _trackDownloadingTimer.setInterval( 1000 );
    //    connect(_decoder, SIGNAL(bufferReady()), this, SLOT(createBuffer()));
    //    connect(_decoder, SIGNAL(bufferReady()), &_trackDownloadingTimer, SLOT(start()));
    connect( &_trackDownloadingTimer, SIGNAL( timeout() ), this, SLOT( onTrackDownloaded() ) );
    //    connect(_decoder, &QAudioDecoder::finished, this, &AudioTrackRepresentation::bufferCreated);
    //    connect(_decoder, &QAudioDecoder::finished,this, &AudioTrackRepresentation::decodeFinished);
}

qint16 AudioTrackRepresentation::maxAmplitude() const noexcept
{
	return _maxAmplitude;
}

void AudioTrackRepresentation::initAudioDecoder()
{
	deleteAudioDecoder();

	_decoder = new QAudioDecoder(this);
	connect(_decoder, SIGNAL(bufferReady()), this, SLOT(createBuffer()));
	connect(_decoder, SIGNAL(bufferReady()), &_trackDownloadingTimer, SLOT(start()));
    connect(_decoder, SIGNAL(error(QAudioDecoder::Error)), this, SLOT(decodeError()));
	connect(_decoder, &QAudioDecoder::finished, this, &AudioTrackRepresentation::decodeFinished);


}

void AudioTrackRepresentation::deleteAudioDecoder()
{
	if (_decoder != nullptr)
	{
		_decoder->stop();
		disconnect(_decoder, SIGNAL(bufferReady()), this, SLOT(createBuffer()));
		disconnect(_decoder, SIGNAL(bufferReady()), &_trackDownloadingTimer, SLOT(start()));
		disconnect(_decoder, &QAudioDecoder::finished, this, &AudioTrackRepresentation::decodeFinished);
		delete _decoder;
        _decoder = nullptr;
    }
}

void AudioTrackRepresentation::decodeError()
{
    qWarning() << "Decoding error:" << _decoder->errorString();
}


qint16 AudioTrackRepresentation::minAmplitude() const
{
	return _minAmplitude;
}

void AudioTrackRepresentation::addSilent(const size_t addSample)
{
    qDebug() << addSample;

    for (auto& x : m_channels)
        x.insertSilent(addSample);

    m_SampleSize = m_channels[0].getLength();
}


void AudioTrackRepresentation::loadFile(const QString& fileName)
{
	initAudioDecoder();

	m_SampleSize = 0;

	m_channels.clear();
	m_numChannels = 0;

	_maxAmplitude = 0;
	_minAmplitude = 0;

	m_first = true;

	_decoder->setSourceFilename(fileName);
	_decoder->start();
    //    _trackDownloadingTimer.start(1000);
}


void AudioTrackRepresentation::createBuffer()
{
	if (m_first)
	{
		m_first = false;
		m_sampleRate = _decoder->audioFormat().sampleRate() * 0.001;
		const auto reserve = static_cast<long double>(_decoder->duration()) * m_sampleRate;
		m_numChannels = _decoder->audioFormat().channelCount();
		emit isHourTime(static_cast<double>(_decoder->duration()) / 3600000.0 >= 1);
		m_channels.clear();
		for (auto i = 0; i < m_numChannels; i++)
		{
			m_channels.emplace_back();
            m_channels[i].m_blocks.reserve(static_cast<size_t>(reserve / MAX_FRAMES) + 15);
			m_channels[i].m_blocks.emplace_back();
		}
	}

	if (m_numChannels < 2)
	{
		const auto buffer = _decoder->read();
		auto* data = buffer.constData<qint16>();
		const auto frameCount = buffer.frameCount();

		for (auto i = 0; i < frameCount; i++)
		{
			const qint16 val = data[i];

			if (val > _maxAmplitude)
				_maxAmplitude = val;
			else if (val < _minAmplitude)
				_minAmplitude = val;

			auto &block = m_channels[0].m_blocks;
            if (block.back().mLen >= MAX_FRAMES)
			{
				block.back().initLuts();
				block.emplace_back();
			}

			m_channels[0].m_blocks.back().addSample(val);
		}
	}
	else
	{
		const auto buffer = _decoder->read();
		const auto data = buffer.constData<QAudioBuffer::S16S>();
		for (auto i = 0; i < buffer.frameCount(); i++)
		{
			const qint16 val = data[i].average();

			if (val > _maxAmplitude)
				_maxAmplitude = val;
			else if (val < _minAmplitude)
				_minAmplitude = val;

            if (m_channels[0].m_blocks.back().mLen >= MAX_FRAMES)
				std::for_each(std::execution::par_unseq, m_channels.begin(), m_channels.end(),
				              [](WaveFormChannel& n)
				              {
					              n.m_blocks.back().initLuts();
					              n.m_blocks.emplace_back();
				              });

			m_channels[0].m_blocks.back().addSample(data[i].left);
			m_channels[1].m_blocks.back().addSample(data[i].right);
		}
	}
}

void AudioTrackRepresentation::decodeFinished()
{
    for( auto& x : m_channels )
    {
        x.m_blocks.back().initLuts();
        x.setMaxAmplitude( _maxAmplitude );
    }


    m_SampleSize = m_channels[0].getLength();
    qDebug() << m_SampleSize << m_channels[0].m_blocks.size() << "DECODE FINISHED";
    emit bufferCreated();
    QTimer::singleShot( 1000, this, SLOT( deleteAudioDecoder() ) );

    onTrackDownloaded();
}

void AudioTrackRepresentation::onTrackDownloaded()
{
    _trackDownloadingTimer.stop();

    emit trackDownloaded();
}