# Use the ffmpeg MediaMTX image because it is based on alpine linux.
FROM bluenviron/mediamtx:1.12.2-ffmpeg

# In testing, gst-rtsp-server was unable to be installed from APK on the MediaMTX image.
# Build GStreamer & plugins from source according to https://gitlab.freedesktop.org/gstreamer/gstreamer
RUN apk update && apk add --no-cache \
    bison \
    build-base \
    flex \
    git \
    linux-headers \
    meson \
    rtmpdump-dev \
    libxml2 \
    libxml2-dev \
    # Installing as a meson subproject of GStreamer is borked.
    x264-dev

RUN git clone https://gitlab.freedesktop.org/gstreamer/gstreamer.git \
    && cd gstreamer \
    && git checkout 1.26.1 \
    && meson setup \
        # Enables the x264 plugin, among others.
        -Dgpl=enabled \
        # Encountered build issues with avtp enabled.
        -Dgst-plugins-bad:avtp=disabled \
        build \
    && cd build \
    && ninja \
    && ninja install \
    && cd ../.. \
    # Remove the source code to keep the image layer small.
    && rm -r gstreamer
