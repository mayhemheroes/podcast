package podcast

import "testing"

func FuzzPodcastEncodeNative(f *testing.F) {
	f.Add([]byte("hello"))
	f.Fuzz(func(t *testing.T, data []byte) {
		FuzzPodcastEncode(data)
	})
}
