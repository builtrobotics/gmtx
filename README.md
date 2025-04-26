# GMTX

[![Docker Hub](https://img.shields.io/badge/docker-builtrobotics/gmtx-blue)](https://hub.docker.com/r/builtrobotics/gmtx)

GMTX enhances [MediaMTX](https://github.com/bluenviron/mediamtx) container images with the power and flexibility of [GStreamer](https://gstreamer.freedesktop.org).

## MediaMTX

_MediaMTX_ is a ready-to-use and zero-dependency real-time media server and media proxy that allows to publish, read, proxy, record and playback video and audio streams.

## GStreamer

GStreamer is a framework for streaming media.

## Why combine MediaMTX with GStreamer?

Combining GStreamer with MediaMTX enables running GStreamer pipelines from the MediaMTX `runOnInit`, `runOnReady`, and `runOnDemand` entrypoints. Although MediaMTX publishes Docker images that include `ffmpeg`, GStreamer is more powerful in some very important scenarios such as low latency transcoding of RTSP streams. If you have a sufficiently simple pipeline, you can even define it with `gst-launch-1.0` from the `mediamtx.yml` configuration file to create a powerful, low-latency relayed streaming application without writing code.

## Example

Let's say you would like to live stream from an IP camera that only streams MJPEG via RTSP, but you would like to relay a lower-bandwidth AV1 stream to clients. If your camera stream is at `rtsp://192.168.1.2/mjpeg`, you could accomplish this with the following configuration:

```
paths:
  camera:
    runOnInit: >
      gst-launch-1.0
        rtspsrc location="rtsp://192.168.1.2/mjpeg" latency=0 !
        decodebin !
        av1enc !
        rtspclientsink location="rtsp://localhost:$RTSP_PORT/$MTX_PATH"
    runOnInitRestart: true
```

## Licensing

Because of the prevalence of H.264 in streaming applications, GMTX builds and installs GStreamer with the x264 library and inherits its GPL license. In order to use this project with H.264 streams, additional licensing from Via-LA may be required.
