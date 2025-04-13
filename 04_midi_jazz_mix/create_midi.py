from mido import Message, MidiFile, MidiTrack, MetaMessage, bpm2tempo

# Giả sử bạn đã có duration_seconds từ bước trên
duration_seconds = 140  # ví dụ: đoạn âm thanh dài 10 giây

# Tạo MIDI file mới
mid = MidiFile()
track = MidiTrack()
mid.tracks.append(track)

# Cấu hình tempo: 120 BPM (beats per minute)
bpm = 120
tempo = bpm2tempo(bpm)
track.append(MetaMessage('set_tempo', tempo=tempo))

# Chuyển đổi thời gian từ giây sang ticks
# Giả sử 480 ticks/beat, 2 beats/giây => 960 ticks/giây
ticks_per_second = 960
tick_interval = 480  # mỗi nốt kéo dài nửa giây (1 beat)
total_ticks = int(duration_seconds * ticks_per_second)

# Thêm các nốt vào track
for i in range(0, total_ticks, tick_interval):
    note = 60 + (i // tick_interval) % 12  # Vòng quanh các nốt trong 1 quãng tám
    track.append(Message('note_on', note=note, velocity=64, time=0))
    track.append(Message('note_off', note=note, velocity=64, time=tick_interval))

# Lưu file MIDI
mid.save('generated_jazz.mid')
print("✅ Đã tạo file MIDI: generated_jazz.mid")
