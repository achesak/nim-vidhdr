About
=====

nim-vidhdr is a Nim module for determining the type of an video from a given file, filename, or sequence of bytes.
It can detect many common video formats.

Usage:
    
    testVideo(file : File)
    testVideo(filename : string)
    testVideo(data : seq[int8])

nim-vidhdr can also be used as a command line program:

    vidhdr [filename1] [filename2] ...

List of detectable formats:

* MPEG4 - MPEG-4 video file - `VideoType.MPEG4`
* MOV - QuickTime movie file - `VideoType.MOV`
* M4V - MPEG-4 video/QuickTime file - `VideoType.M4V`
* DVD - DVD Video Movie file - `VideoType.DVD`
* IVR - RealPlayer video file (V11 and later) - `VideoType.IVR`
* RM - RealMedia streaming media file - `VideoType.RM`
* WMV - Microsoft Windows Media Audio/Video file - `VideoType.WMV`
* FLV - Flash video file - `VideoType.FLV`
* OGV - Ogg Vorbis video file - `VideoType.OGV`
* AVI - Windows Audio/Video Interleave file - `VideoType.AVI`
* DAT - Video CD MPEG or MPEG1 movie file - `VideoType.DAT`
* THP - Wii/Gamecube video file - `VideoType.THP`
* Unknown format - `VideoType.Other`

Note that this should ONLY be used when you are certain that the file being testing is a video file.
Some formats, in particular OGV, WMV, and DAT, have the same file signatures as other widely known formats
that could cause issues if those are tested.

License
=======

nim-vidhdr is released under the MIT open source license.
