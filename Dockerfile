# Use the ffmpeg MediaMTX image because it is based on alpine linux.
FROM bluenviron/mediamtx:1.12.0-ffmpeg

# In testing, gst-rtsp-server was unable to be installed from APK on the MediaMTX image.
# Build GStreamer & plugins from source according to https://gitlab.freedesktop.org/gstreamer/gstreamer
RUN apk update && apk add --no-cache \
    bison \
    build-base \
    flex \
    git \
    linux-headers \
    meson \
    py3-setuptools \
    python3 \
    python3-dev \
    # Installing as a meson subproject of GStreamer is borked.
    x264-dev

RUN git clone https://gitlab.freedesktop.org/gstreamer/gstreamer.git \
    && cd gstreamer \
    && meson setup \
        # Needed in order to build the x264 plugin.
        -Dgpl=enabled \
        # Needed in order to build the ugly plugins.
        -Dugly=enabled \
        # x264 is part of the ugly plugins.
        -Dgst-plugins-ugly:x264=enabled \
        # Encountered build issues with avtp enabled.
        -Dgst-plugins-bad:avtp=disabled \
        build \
    && cd build \
    && ninja \
    && ninja install \
    && cd ../.. \
    # Remove the source code to keep the image layer small.
    && rm -r gstreamer
