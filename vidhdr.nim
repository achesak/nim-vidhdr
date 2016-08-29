# Nim module for determining the type of video files.

# Written by Adam Chesak.
# Released under the MIT open source license.


## nim-vidhdr is a Nim module for determining the type of video files.
##
## List of detectable formats:
##
## - MPEG4 - MPEG-4 video file - VideoType.MPEG4
## - MOV - QuickTime movie file - VideoType.MOV
## - M4V - MPEG-4 video/QuickTime file - VideoType.M4V
## - DVD - DVD Video Movie file - VideoType.DVD
## - IVR - RealPlayer video file (V11 and later) - VideoType.IVR
## - RM - RealMedia streaming media file - VideoType.RM
## - WMV - Microsoft Windows Media Audio/Video file - VideoType.WMV
## - FLV - Flash video file - VideoType.FLV
## - OGV - Ogg Vorbis video file - VideoType.OGV
## - AVI - Windows Audio/Video Interleave file - VideoType.AVI
## - DAT - Video CD MPEG or MPEG1 movie file - VideoType.DAT
## - THP - Wii/Gamecube video file - VideoType.THP
## - Unknown format - VideoType.Other
##
## Note that this should ONLY be used when you are certain that the file being testing is a video file.
## Some formats, in particular OGV, WMV, and DAT, have the same file signatures as other widely known formats
## that could cause issues if those are tested.


import os


proc int2ascii(i : seq[int8]): string = 
    ## Converts a sequence of integers into a string containing all of the characters.
    
    let h = high(uint8).int + 1
    
    var s : string = ""
    for j, value in i:
        s = s & chr(value %% h)
    return s


proc `==`(i : seq[int8], s : string): bool = 
    ## Operator for comparing a seq of ints with a string.
    
    return int2ascii(i) == s


type VideoType* {.pure.} = enum
    MPEG4, MOV, M4V, DVD, IVR, RM, WMV, FLV, OGV, AVI, DAT, THP, Other


proc testVideo*(data : seq[int8]): VideoType


proc testMPEG4(value : seq[int8]): bool = 
    ## Returns true if the video is a MPEG-4 video file.
    
    # tests: "ftypisom" OR "ftyp3gp5" OR "ftypMSNV"
    return value[4..11] == "ftypisom" or value[4..1] == "ftyp3gp5" or value[4..11] == "ftypMSNV"


proc testMOV(value : seq[int8]): bool = 
    ## Returns true if the video is a QuickTime movie file.
    
    # tests: "ftypqt  " OR "moov"
    return value[4..11] == "ftypqt  " or value[4..7] == "moov"


proc testM4V(value : seq[int8]): bool = 
    ## Returns true if the video is a MPEG-4 video/QuickTime file.
    
    # tests: "ftypmp42"
    return value[4..11] == "ftypmp42"


proc testDVD(value : seq[int8]): bool = 
    ## Returns true if the video is a DVD Video Movie file.
    
    # tests: 00 00 01 BA
    return value[0] == 0 and value[1] == 0 and value[2] == 1 and value[3] == 186


proc testIVR(value : seq[int8]): bool = 
    ## Returns true if the video is a RealPlayer video file (V11 and later).
    
    # tests: 2E AND "REC"
    return value[0] == 46 and value[1..3] == "REC"


proc testRM(value : seq[int8]): bool = 
    ## Returns true if the video is a RealMedia streaming media file.
    
    # tests: 2E AND "RMF"
    return value[0] == 46 and value[1..3] == "RMF"


proc testWMV(value : seq[int8]): bool = 
    ## Returns true if the video is a Microsoft Windows Media Audio/Video file.
    
    # tests: 30 26 B2 75 8E 66 CF 11 A6 D9 00 AA 00 62 CE 6C
    return value[0] == 48 and value[1] == 38 and value[2] == 178 and value[3] == 117 and value[4] == 142 and 
           value[5] == 102 and value[6] == 207 and value[7] == 17 and value[8] == 166 and value[9] == 217 and 
           value[10] == 0 and value[11] == 170 and value[12] == 0 and value[13] == 98 and value[14] == 206 and 
           value[15] == 108


proc testFLV(value : seq[int8]): bool = 
    ## Returns true if the video is a Flash video file.
    
    # tests: "FLV" AND 01
    return value[0..2] == "FLV" and value[3] == 1


proc testOGV(value : seq[int8]): bool = 
    ## Returns true if the video is an Ogg Vorbis video file
    
    # tests: "OggS"
    return value[0..3] == "OggS"


proc testAVI(value : seq[int8]): bool = 
    ## Returns true if the video is a Windows Audio/Video Interleave file.
    
    # tests: "RIFF" and "AVI LIST"
    return value[0..3] == "RIFF" and value[8..15] == "AVI LIST"


proc testDAT(value : seq[int8]): bool = 
    ## Returns true if the video is a Video CD MPEG or MPEG1 movie file.
    
    # tests: "RIFF"
    return value[0..3] == "RIFF"


proc testTHP(value : seq[int8]): bool = 
    ## Returns true if the video is a Wii/Gamecube video file.
    
    # tests: "THP" AND 00
    return value[0..2] == "THP" and value[3] == 0


proc testVideo*(file : File): VideoType =
    ## Determines the format of the video file given.
    
    var data = newSeq[int8](32)
    discard file.readBytes(data, 0, 32)
    return testVideo(data)


proc testVideo*(filename : string): VideoType = 
    ## Determines the format of the video with the specified filename.
    
    var file : File = open(filename)
    var format : VideoType = testVideo(file)
    file.close()
    return format


proc testVideo*(data : seq[int8]): VideoType = 
    ## Determines the format of the video from the bytes given.
    
    if testMPEG4(data):
        return VideoType.MPEG4
    elif testMOV(data):
        return VideoType.MOV
    elif testM4V(data):
        return VideoType.M4V
    elif testDVD(data):
        return VideoType.DVD
    elif testIVR(data):
        return VideoType.IVR
    elif testRM(data):
        return VideoType.RM
    elif testWMV(data):
        return VideoType.WMV
    elif testFLV(data):
        return VideoType.FLV
    elif testOGV(data):
        return VideoType.OGV
    elif testAVI(data):
        return VideoType.AVI
    elif testDAT(data):
        return VideoType.DAT
    elif testTHP(data):
        return VideoType.THP
    else:
        return VideoType.Other


# When run as it's own program, determine the type of the provided video file:
when isMainModule:
    
    if paramCount() < 2:
        echo("Invalid number of parameters. Usage:\nvidhdr [filename1] [filename2] ...")
    
    for i in 1..paramCount():
        echo("Detected file type for \"" & paramStr(i) & "\": " & $testVideo(paramStr(i)))