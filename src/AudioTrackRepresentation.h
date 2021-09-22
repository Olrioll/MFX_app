#ifndef AUDIOTRACKREPRESENTATION_H
#define AUDIOTRACKREPRESENTATION_H

#include <QObject>
#include <QAudioDecoder>
#include <QTimer>
#include <QColor>
#include <array>
#include <execution>


#define FRAMES_MIN(a,b) ((a) < (b) ? (a) : (b))
#define FRAMES_MAX(a,b) ((a) > (b) ? (a) : (b))

struct FrameBlock
{
    enum { MAX_FRAMES = 131072 };

    enum { FRAMES_PER_LUT = 256 };

    enum { LUT_SIZE = MAX_FRAMES / FRAMES_PER_LUT };

    qint16 mSamples[MAX_FRAMES]{};
	qint16 mMaxLut[LUT_SIZE]{};
	qint16 mMinLut[LUT_SIZE]{};
	float mRms[LUT_SIZE]{};
	size_t mLen = 0;

	FrameBlock() = default;
	FrameBlock(const FrameBlock&) = delete;
	void operator=(const FrameBlock&) = delete;
	FrameBlock(FrameBlock&& sb) noexcept = default;
	FrameBlock& operator=(FrameBlock&& other) noexcept = default;

	explicit FrameBlock(const size_t len)
	{
		std::memset(mSamples, 0, sizeof mSamples);
		std::memset(mMaxLut, 0, sizeof mMaxLut);
		std::memset(mMinLut, 0, sizeof mMinLut);
		std::memset(mRms, 0, sizeof mRms);
		mLen = len;
	}


	void addSample(const qint16 val) { mSamples[mLen++] = val; }

	void initLuts()
	{
        if (mLen == MAX_FRAMES)
		{
			std::iota(std::begin(mMaxLut), std::end(mMaxLut), 0);
			std::for_each(std::execution::par, std::cbegin(mMaxLut), std::cend(mMaxLut),
			              [&](const qint16& n)
			              {
				              const auto i = n;
                              const auto it = i * FRAMES_PER_LUT;
				              qint16* currentSample = mSamples + it;
				              qint16 _min = INT16_MAX;
				              qint16 _max = INT16_MIN;
				              float _rms = 0.f;
                              for (unsigned j = 0; j < FRAMES_PER_LUT; j++)
				              {
					              _rms += static_cast<float>(*currentSample) * static_cast<float>(*currentSample);
					              _min = FRAMES_MIN(*currentSample, _min);
					              _max = FRAMES_MAX(*currentSample, _max);
					              currentSample++;
				              }
				              mRms[i] = _rms;
				              mMaxLut[i] = _max;
				              mMinLut[i] = _min;
			              });
		}
		else
		{
			qint16* currentSample = mSamples;
			qint16* lastSample = mSamples + mLen;
			for (unsigned i = 0; i < LUT_SIZE; i++)
			{
				qint16 _min = INT16_MAX;
				qint16 _max = INT16_MIN;
				float _rms = 0.f;
                for (unsigned j = 0; j < FRAMES_PER_LUT; j++)
				{
					if (currentSample >= lastSample)
						break;

					_rms += static_cast<float>(*currentSample) * static_cast<float>(*currentSample);
					_min = FRAMES_MIN(*currentSample, _min);
					_max = FRAMES_MAX(*currentSample, _max);
					currentSample++;
				}
				mRms[i] = _rms;
				mMaxLut[i] = _max;
				mMinLut[i] = _min;
			}
		}
	}
};


class WaveFormChannel
{
public:
	struct FramePos
	{
		size_t mBlockIdx;
		size_t mSampleIdx;

		FramePos()
		{
			mBlockIdx = 0;
			mSampleIdx = 0;
		}

		FramePos(const size_t blockIdx, const size_t sampleIdx)
		{
			mBlockIdx = blockIdx;
			mSampleIdx = sampleIdx;
		}
	};

private:
	void calculateLuts(FramePos* pos, size_t numSamples, qint16* resultMin, qint16* resultMax, float* rms);
	qint16 maxAmplitude = 0;

public:
	FramePos getFramePosFromSampleIdx(size_t sampleIdx);
	FrameBlock* incrementFramePos(FramePos* pos, size_t numSamples);
	void insertSilent(const size_t size);
	std::vector<FrameBlock> m_blocks;
	[[nodiscard]] size_t getLength() const;
	void setMaxAmplitude(qint16 max);
	void calculateWaveForm(size_t startSampleIdx, qint16* mins, qint16* maxes,
	                       const size_t widthInPixels, const double samplesPerPixel, float* rms);
};


class AudioTrackRepresentation final : public QObject
{
	Q_OBJECT

public:
	explicit AudioTrackRepresentation(QObject* parent = nullptr);
	[[nodiscard]] qint16 maxAmplitude() const noexcept;
	[[nodiscard]] qint16 minAmplitude() const;
	[[nodiscard]] bool isStereo() const { return m_numChannels > 1; }
	std::vector<WaveFormChannel> m_channels;
	[[nodiscard]] double getSampleRate() const { return m_sampleRate; }
	void addSilent(const size_t addSample);

public slots:
	void loadFile(const QString& fileName);
	void createBuffer();
	[[nodiscard]] size_t samplesCount() const { return m_SampleSize; }
	void decodeFinished();
	void deleteAudioDecoder();
signals:
	void bufferCreated();
	void trackDownloaded();
	void isHourTime(bool isMoreThanHour);

private:
	QAudioDecoder* _decoder = nullptr;
	qint16 _maxAmplitude = 0;
	qint16 _minAmplitude = 0;
	bool m_first = true;
	size_t m_SampleSize = 0;
	QTimer _trackDownloadingTimer;
	void initAudioDecoder();
	int m_numChannels = 0;
	double m_sampleRate = 1;
};

#endif // AUDIOTRACKREPRESENTATION_H
