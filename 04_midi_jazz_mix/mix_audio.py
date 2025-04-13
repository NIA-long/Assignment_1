from pydub import AudioSegment

# Load file WAV
voice = AudioSegment.from_wav("Introduction.wav")
music = AudioSegment.from_wav("jazz_music.wav")

# Cắt hoặc lặp nhạc sao cho dài bằng lời nói
if len(music) > len(voice):
    music = music[:len(voice)]
else:
    music = music * (len(voice) // len(music) + 1)
    music = music[:len(voice)]

# Giảm âm lượng nhạc nền
music = music - 10  # giảm 10 dB để giọng nói nổi bật

# Trộn 2 file lại
mixed = voice.overlay(music)

# Xuất ra file
mixed.export("final_mix.wav", format="wav")
print("✅ Mix hoàn tất: final_mix.wav")
