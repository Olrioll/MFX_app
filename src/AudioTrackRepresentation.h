#ifndef AUDIOTRACKREPRESENTATION_H
#define AUDIOTRACKREPRESENTATION_H

#include <QObject>
#include <QAudioDecoder>
#include <QTimer>
#include <QColor>
#include <array>
#include <execution>
#include <cstring>


constexpr size_t MAX_FRAMES = 131072;
constexpr size_t FRAMES_PER_LUT = 256;
constexpr size_t LUT_SIZE = MAX_FRAMES / FRAMES_PER_LUT;

struct FrameBlock
{
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

    explicit FrameBlock( const size_t len );

    void addSample( const qint16 val );
    void initLuts();
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
	FramePos getFramePosFromSampleIdx(size_t sampleIdx) const;
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
    void decodeError();
	void onTrackDownloaded();

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
