-- for rtmp specs 1.0
-- winlin, 2012.5.16
-- for Version 1.6.0 (SVN Rev 37592 from /trunk-1.6)

-- about winlin
if (gui_enabled()) then 
    -- about
    function about_winlin()
        browser_open_url("http://blog.csdn.net/winlinvip");
    end
    
    register_menu("Lua/Winlin", about_winlin, MENU_TOOLS_UNSORTED);
end

-- parse my rtmp
do
    --[[
    ==============================================================================
    ========================global, consts and protocol===========================
    ==============================================================================
    ]]
    -- define the rtmp protocol
    local rtmp = Proto("AdobeRtmp", "Adobe RTMP(Real Time Messaging Protocol)");
    -- the logs displayed on the LuaConsole.
    debug(string.format("[global] protocol rtmp initialized."));
    -- consts and pool definition.
    -- const defines the server port.
    local rtmpServerPort = 1935;
    --[[
    defines a global objects table, to stores all packets.
    table(key=pkt.number, value=rtmpObject).
    rtmpObject defines as:
    {
        id: int, the pkt.number.
        src_port: int, the pkt.src_port.
        type: int, the pakcet type: -1.unknown, 1.C0+C1, 2.S0+S1+S2, 3.C2, 4.ChunkPakcet.
        show: bool, whether show in ui, false if analysis, otherwise true.
        pre: int, previous pkt.number if it's a fragment of tcp packet. -1, uninitialized; 0, no pre; positive, the previous packet id.
        refpos: int, the referenced position of previous packet. if 0, refer whole object(must refer to the pre of pre); if positive, refer to it only.
        next: int, next pkt.number if it's a fragment of tcp packet. -1, uninitialized; 0, no next; positive, the next packet id.
        bytes: ByteArray, the packet bytes.
        packet_names: a list that contains a list of parsed names. e.g "C0+C1", "connect", "#error"
    }
    ]]
    local rtmpObjectPool = {};
    -- packet decoded number, sometimes seems the wireshark will parse the packets again!
    -- for example, we parsed the #4,#5,#8 packets, then the next is #4,#5,#8 again!
    local rtmpTcpPacketNumber = 0;
    -- defines the next packets type: 1.C0+C1, 2.S0+S1+S2, 3.C2, 4.ChunkPakcet.
    -- TODO: must dynamically determinate the packet type.
    local rtmpNextPacketType = 1;
    -- record the parsed packet count.
    local rtmpParsedPacketCount = 0;
    -- record the parsed valid message length
    local rtmpParsedMessageLength = 0;
    -- define a global bytes pool, to reassemble the RTMP pakcets
    --[[
    there is a bug for ByteArray, see https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=4461
    TestCase:
        ba = ByteArray.new("02")
        ba:append(ByteArray.new("03"))
    wireshark will crash! This bug causes Wireshark 1.6.1 to crash on linux and Windows.
    A workaround is to use ByteArray.new(). For example, to prepend ByteArray B to ByteArray A: 
        A = ByteArray.new("02")
        B = ByteArray.new("03")
        local C = ByteArray.new( tostring(B)..tostring(A) )
    ]]
    local rtmpBytesPool = ByteArray.new();
    debug(string.format("[global] the rtmp initialized. bytes pool size=%d. server port=%d", rtmpBytesPool:len(), rtmpServerPort));
    -- defines the protocol structures.
    -- rtmp packet, it actually must be a rtmpHandShake or/and rtmpChunk packet.
    local rtmpPacket = {
        -- the handshake structure used during handshake.
        rtmpHandShake = {},
        -- the chunk structure is the actual packet after handshaked.
        rtmpChunk = {
            -- the chunk header.
            ChunkHeader = {
                -- basic header
                BasicHeader = {
                    ChunkType = {},
                    StreamIdLow = {},
                    StreamIdHigh = {}
                },
                -- chunk message header.
                ChunkMsgHeader = {
                    TimestampDelta = {},
                    MessageLength = {},
                    MessageTypeId = {},
                    MessageStreamId = {}
                },
                -- extended timestamp.
                ExtendedTimeStamp = {}
            },
            -- the chunk data.
            ChunkData = {}
        }
    };
    -- alias
    local rtmpChunkHeader = rtmpPacket.rtmpChunk.ChunkHeader;
    local rtmpBasicHeader = rtmpPacket.rtmpChunk.ChunkHeader.BasicHeader;
    local rtmpChunkType = rtmpPacket.rtmpChunk.ChunkHeader.BasicHeader.ChunkType;
    local rtmpStreamIdLow = rtmpPacket.rtmpChunk.ChunkHeader.BasicHeader.StreamIdLow;
    local rtmpStreamIdHigh = rtmpPacket.rtmpChunk.ChunkHeader.BasicHeader.StreamIdHigh;
    local rtmpTimestampDelta = rtmpPacket.rtmpChunk.ChunkHeader.ChunkMsgHeader.TimestampDelta;
    local rtmpMessageLength = rtmpPacket.rtmpChunk.ChunkHeader.ChunkMsgHeader.MessageLength;
    local rtmpMessageTypeId = rtmpPacket.rtmpChunk.ChunkHeader.ChunkMsgHeader.MessageTypeId;
    local rtmpMessageStreamId = rtmpPacket.rtmpChunk.ChunkHeader.ChunkMsgHeader.MessageStreamId;
    local rtmpExtendedTimeStamp = rtmpPacket.rtmpChunk.ChunkHeader.ExtendedTimeStamp;
    local rtmpChunkData= rtmpPacket.rtmpChunk.ChunkHeader.ChunkData;
    -- defines the frame based variables
    local rtmpCurrentPacket = {}; -- the current pakcet, set in the dissector, specifies the current packet.
    local rtmpCurrentBuffer = {}; -- the current buffer(TvbRange object) of current packet.
    local rtmpCurrentTree = {}; -- the display tree root of current pakcet.
    local rtmpCurrentObject = nil; -- the current object mapped to current packet.
    --[[:
    the parse status of current packet.
    ==0 success parsed.
    -1 bytes in buffer is not enouth, need more data.
    -2 parse error, must clear all data in buffer.
    -3 parse the chunk error, next packet must partially reference to this. see also: refpos(refence position).
    ]]
    local rtmpCurrentStatus = 0;
    debug(string.format("[global] global protocol variables and alias defined"));
    
    -- define the decoder.
    --[[
    the dissctor will be invoked many times. if we has 3 packets to dissect:
    1. on wireshark start: we get 6packets to dissect, in sequence of #1,#2,#3,#1,#2,#3.
        for the packet list will parse the packets for #1#2#3
        then the packet detail will parse the packets again for #1#2#3.
    2. if user click packet #2: we get #2 to dissect.
    so if #1 and #2 is one packet(separate in two tcp packet), we cannnot parse right if only click #2, but ok to click #1 then #2.
    ]]
    function rtmp.dissector(buf, pkt, tree)
        debug(string.format("[disscet] =============================================================================================="));
        debug(string.format("[dissect] get a pakcet to dissect: parsed=%d id=%d, len=%d, old pool=%d, sender=%s", rtmpParsedPacketCount, pkt.number, buf:len(), rtmpBytesPool:len(), utilityRtmpDiscoverySender(pkt)));
        local rtmpObject = utilityRtmpCreateOrGetObject(pkt, buf);
        local buffer = utilityRtmpAppendBytesPool(rtmpObject);
        -- invoke the handler when buf changed.
        onRtmpBeginDissect(rtmpObject, buffer, pkt, tree);
        
        -- set the columns info.
        uiRtmpColumnProtocolSet(string.format("RTMP"));
        -- the first time, must set the column text, then the append is available.
        uiRtmpColumnInfoSet(string.format("RTMP: ", buf:len(), buffer:len()));
        
        -- definese the parse offset.
        local offset = 0;
        local length = buffer:len();
        
        -- dessector the packets
        local root = uiRtmpTreeCreate(tree, buffer(0, buffer:len()), buffer:len());
        uiRtmpTreeSetText(root, string.format("AdobeRTMP: linkups=[%s]", utilityRtmpGetObjectLinkupString(rtmpObject)));
        offset = rtmpDissectAllPackets(root, buffer, offset);
        
        if(rtmpCurrentStatus == 0) then
            debug(string.format("[dissect] dissect packets success. consumed size:%d, new pool size:%d, bytes left:%d", offset, length, length - offset));
            onRtmpDiessectSuccess();
        elseif(rtmpCurrentStatus == -1) then
            debug(string.format("[dissect] dissect some packet finished, need more bytes. consumed size:%d, pool size:%d, bytes left:%d", offset, length, length - offset));
            onRtmpDiessectError(length, offset);
        elseif(rtmpCurrentStatus == -2)then
            critical(string.format("[dissect] dissect packet error, simply consumed all bytes in buffer!"));
            onRtmpDiessectError(length, offset);
        elseif(rtmpCurrentStatus == -3)then
            critical(string.format("[dissect] dissect the chunk data error, this packet %d partially provides %d bytes for next.", rtmpCurrentObject.id, length - offset));
            onRtmpDiessectError(length, offset);
        else
            critical(string.format("[dissect] unknown status=%d", rtmpCurrentStatus));
        end
        
        onRtmpDissectFinished(root, length, offset);
        
        -- invoke the handler.
        onRtmpEndDissect();
    end
    
    --[[
    ==============================================================================
    ========================defines the event handlers============================
    ==============================================================================
    ]]
    --[[
    when the diessector start to dissect packet, initialize the frame level variables.
    ]]
    function onRtmpBeginDissect(rtmpObject, buf, pkt, tree)
        rtmpCurrentPacket = pkt;
        rtmpCurrentBuffer = buf;
        rtmpCurrentTree = tree;
        rtmpCurrentStatus = 0;
        rtmpParsedPacketCount = rtmpParsedPacketCount + 1;
        rtmpCurrentObject = rtmpObject;
        -- clear the parsed packet names during every paring.
        rtmpCurrentObject.packet_names = {};
    end
    
    --[[
    when the diessector finish to dissect packet
    ]]
    function onRtmpDissectFinished(root, length, offset)
        -- add parsed packet names to protocol info column
        local i = table.maxn(rtmpCurrentObject.packet_names) + 1;
        while(i >= 0)do
            local item = rtmpCurrentObject.packet_names[i];
            if(item ~= nil)then
                uiRtmpColumnInfoAppend(item);
                
                if(i > 0)then
                    uiRtmpColumnInfoAppend(" | ");
                end
            end
            i = i - 1;
        end
        
        -- update final status
        local status = "Success";
        if(rtmpCurrentStatus == -1)then
            status = "#HasContinuePackets";
        elseif(rtmpCurrentStatus == -2)then
            status = "#ParseError";
        end
        uiRtmpTreeAppendText(root, string.format(" pool=%d consumed=%d available=%d status=%s", length, offset, length - offset, status));
    end
    
    --[[
    when the diessector exit to dissect packet
    ]]
    function onRtmpEndDissect()
        rtmpCurrentPacket = nil;
        rtmpCurrentBuffer = nil;
        rtmpCurrentTree = nil;
        rtmpCurrentStatus = 0;
        rtmpCurrentObject = nil;
    end
    
    --[[
    when the diessector dissect pakcet success.
    ]]
    function onRtmpDiessectSuccess()
        rtmpCurrentObject.show = true;
        rtmpCurrentObject.next = 0;
    end
    
    --[[
    when the diessector dissect pakcet error.
    ]]
    function onRtmpDiessectError(length, offset)
        -- if parsed error( for the AMF parsed error, must show it ).
        if(rtmpCurrentStatus == -2)then
            onRtmpDiessectSuccess();
        -- if need more, show it.
        elseif(rtmpCurrentStatus == -1)then
            utilityRtmpAddParsedPacketName("#Partial");
            rtmpCurrentObject.show = true;
            rtmpCurrentObject.next = -1;
        -- has a partial continue packet
        elseif(rtmpCurrentStatus == -3)then
            rtmpCurrentObject.show = true;
            rtmpCurrentObject.next = -1;
            -- the partial bytes for the next packet.
            local availableBytes = length - offset;
            local offsetForNextPacket = rtmpCurrentObject.bytes:len() - availableBytes; 
            rtmpCurrentObject.refpos = offsetForNextPacket;
        end
    end
    
    --[[
    ==============================================================================
    ========================defines the parse methods=============================
    ==============================================================================
    ]]
    --[[
    dissector the packets from buffer and append items to root.
    return the consumed bytes and set the global status rtmpCurrentStatus:
    ]]
    function rtmpDissectAllPackets(root, buffer, offset)
        rtmpCurrentStatus = 0;
        local continueLoop = true;
        local consumedSize = 0;
        local availableSize = buffer:len() - offset;
        
        debug(string.format("[dissect-all] start to dissect all packets. offset=%d, pool=%d, available=%d", offset, buffer:len(), availableSize));
        while(continueLoop) do
            local forcePacketType = -1;
            -- if C2(type3) parsed success, force to parse ChunkPacket(type4)
            if(rtmpCurrentObject.type == 3 and consumedSize > 0)then
                forcePacketType = 4;
            end
            
            local size = rtmpDissectSinglePacket(root, buffer, offset + consumedSize, forcePacketType);
            
            consumedSize = consumedSize + size;
            availableSize = availableSize - size;
            
            -- if error or consumed nothing, dissect packets in the next roudntrip.
            continueLoop = (rtmpCurrentStatus == 0 and size > 0 and availableSize > 0);
        end
        debug(string.format("[dissect-all] disssect finished. offset=%d, pool=%d, consumed bytes size=%d", offset, buffer:len(), consumedSize));
        
        return consumedSize;
    end
    
    --[[
    dissector a single packet from buffer and append items to root.
    return the consumed bytes and set the global status rtmpCurrentStatus.
    @param forcePacketType: int value indicates the current packet type.
        -1, ignore this type, the function will discovery the right type. such as 1,2,3,4.
        positive, use this type. for example, a packet contains C2|ChunkPacket, and its packet type is 3(C2),
        so first time, we pass -1, to parse the C2 packet.
        second time, we pass 4, to force to parse the bytes in type4(ChunkPacket).
    ]]
    function rtmpDissectSinglePacket(root, buffer, offset, forcePacketType)
        -- if object contains type, use it.
        -- otherwise, use the type in parse sequence.
        local packetType = rtmpCurrentObject.type;
        if(packetType == -1)then
            packetType = rtmpNextPacketType;
        end
        if(forcePacketType > 0)then
            packetType = forcePacketType;
        end
        
        debug(string.format(
            "[dissect-one] start dissect a single packet. %s, pool size:%d, offset:%d, available=%d", 
            string.format("actual type:%d (logical:%d, object:%d, force:%d)", packetType, rtmpNextPacketType, rtmpCurrentObject.type, forcePacketType), 
            buffer:len(), offset,  buffer:len() - offset
        ));
        
        local size = 0;
        -- 1.C0+C1
        if(packetType == 1)then
            size = rtmpDissectHandShakeC0C1(root, buffer, offset);
        -- 2.S0+S1+S2
        elseif(packetType == 2)then
            size = rtmpDissectHandShakeS0S1S2(root, buffer, offset);
        -- 3.C2
        elseif(packetType == 3)then
            size = rtmpDissectHandShakeC2(root, buffer, offset);
        -- 4.ChunkPakcet.
        elseif(packetType == 4)then
            size = rtmpDissectChunkPacket(root, buffer, offset);
        -- invalid packet.
        else
            rtmpCurrentStatus = -2;
            uiRtmpTreeCreate(root, buffer(offset, buffer:len()), "#Invalid Packet Type");
            critical(string.format("[dissect-one] invalid packet type %d, must be 1/2/3/4.", packetType));
        end
        
        debug(string.format("[dissect-one] finished to dissect a single packet. consumed:%d", size));
        
        return size;
    end
    
    --[[
    dissector the c0c1 handshake packets from buffer and append items to root.
    return the consumed bytes and set the global status rtmpCurrentStatus:
    ]]
    function rtmpDissectHandShakeC0C1(root, buffer, offset)
        local C0C1length = 1 + 1536;
        local C1length = 1536;
        debug(string.format("[dissect-c0c1] start to dissect the client handshake pakcet: C0C1. required %d bytes, pool size=%d", C0C1length, buffer:len()));
        
        rtmpCurrentObject.type = 1;
        if(buffer:len() < C0C1length)then
            uiRtmpTreeCreate(root, buffer(offset, buffer:len() - offset), "ClientHandshake(C0C1) #Not Enough");
            warn(string.format("[dissect-c0c1] failed to dissect the client handshake packet C0C1. required %d bytes, pool size=%d", C0C1length, buffer:len()));
            rtmpCurrentStatus = -1;
            return 0;
        else
            local size = 0;
            local c0c1 = uiRtmpTreeCreate(root, buffer(offset, C0C1length), "ClientHandshake: C0C1");
            
            -- C0: Version: 8 bits
            local version = buffer(offset + size, 1):uint();
            debug(string.format("[dissect-c0c1] c0 version decoded: version=%d", version));
            
            -- the C0C1 must start with 0x03.
            if(version ~= 0x03)then
                uiRtmpTreeSetText(c0c1, "ClientHandshake: #Corrupt Pakcet");
                critical(string.format("[dissect-c0c1] corrupt dissct, the C0C1 packet must startwith 0x03. actual:%d(0x%X)", version, version));
                rtmpCurrentStatus = -2;
                return 0;
            end
            
            uiRtmpTreeCreate(c0c1, buffer(offset + size, 1), string.format("C0(Version): %d(0x%X)", version, version));
            size = size + 1;
            
            -- C1: The C1 and S1 packets are 1536 octets long
            uiRtmpTreeCreate(c0c1, buffer(offset + size, C1length), string.format("C1(Signature): size=%d(0x%X)", C1length, C1length));
            size = size + C1length;
            
            -- auto change.
            utilityRtmpAddParsedPacketName("HandShake C0+C1");
            rtmpNextPacketType = 2;
            debug(string.format("[dissect-c0c1] C0C1 packet decoded. consumed size:%d, packet type change to:%d, object type:%d", size, rtmpNextPacketType, rtmpCurrentObject.type));
            
            return size;
        end
        
        return 0;
    end
    
    --[[
    dissector the S0S1S2 handshake packets from buffer and append items to root.
    return the consumed bytes and set the global status rtmpCurrentStatus:
    ]]
    function rtmpDissectHandShakeS0S1S2(root, buffer, offset)
        local S0S1S2length = 1 + 1536 + 1536;
        local S1OrS2length = 1536;
        debug(string.format("[dissect-s0s1s2] start to dissect the server handshake pakcet: S0S1S2. required %d bytes, pool size=%d", S0S1S2length, buffer:len()));
    
        rtmpCurrentObject.type = 2;
        if(buffer:len() < S0S1S2length)then
            uiRtmpTreeCreate(root, buffer(offset, buffer:len() - offset), "ServerHandshake(S0S1S2) #Not Enough");
            warn(string.format("[dissect-s0s1s2] failed to dissect the server handshake packet s0s1s2. required %d bytes, pool size=%d", S0S1S2length, buffer:len()));
            rtmpCurrentStatus = -1;
            return 0;
        else
            local size = 0;
            local s0s1s2 = uiRtmpTreeCreate(root, buffer(offset, S0S1S2length), "ServerHandshake: S0S1S2");
            
            -- S0: Version: 8 bits
            local version = buffer(offset + size, 1):uint();
            debug(string.format("[dissect-s0s1s2] S0 version decoded: version=%d", version));
            
            -- the S0S1S2 must start with 0x03.
            if(version ~= 0x03)then
                uiRtmpTreeSetText(s0s1s2, "ServerHandshake: #Corrupt Pakcet");
                critical(string.format("[dissect-s0s1s2] corrupt dissct, the S0S1S2 packet must startwith 0x03. actual:%d(0x%X)", version, version));
                rtmpCurrentStatus = -2;
                return 0;
            end
            
            uiRtmpTreeCreate(s0s1s2, buffer(offset + size, 1), string.format("S0(Version): %d(0x%X)", version, version));
            size = size + 1;
            
            -- S1: The C1 and S1 packets are 1536 octets long
            uiRtmpTreeCreate(s0s1s2, buffer(offset + size, S1OrS2length), string.format("C1(Signature): size=%d(0x%X)", S1OrS2length, S1OrS2length));
            size = size + S1OrS2length;
            
            -- S2: The C2 and S2 packets are 1536 octets long
            uiRtmpTreeCreate(s0s1s2, buffer(offset + size, S1OrS2length), string.format("C1(Signature): size=%d(0x%X)", S1OrS2length, S1OrS2length));
            size = size + S1OrS2length;
            
            -- auto change.
            utilityRtmpAddParsedPacketName("HandShake S0+S1+S2");
            rtmpNextPacketType = 3;
            debug(string.format("[dissect-s0s1s2] S0S1S2 packet decoded. consumed size:%d, packet type change to:%d, object type:%d", size, rtmpNextPacketType, rtmpCurrentObject.type));
            
            return size;
        end
        
        return 0;
    end
    
    --[[
    dissector the C2 handshake packets from buffer and append items to root.
    return the consumed bytes and set the global status rtmpCurrentStatus:
    ]]
    function rtmpDissectHandShakeC2(root, buffer, offset)
        local C2length = 1536;
        debug(string.format("[dissect-c2] start to dissect the client handshake pakcet: C2. required %d bytes, pool size=%d", C2length, buffer:len()));
    
        rtmpCurrentObject.type = 3;
        if(buffer:len() < C2length)then
            uiRtmpTreeCreate(root, buffer(offset, buffer:len() - offset), "ClientHandshake(C2) #Not Enough");
            warn(string.format("[dissect-c2] failed to dissect the server handshake packet c2. required %d bytes, pool size=%d", C2length, buffer:len()));
            rtmpCurrentStatus = -1;
            return 0;
        else
            local size = 0;
            local c2 = uiRtmpTreeCreate(root, buffer(offset, C2length), "ClientHandshake: C2");
            
            -- C2: The C2 and S2 packets are 1536 octets long
            uiRtmpTreeCreate(c2, buffer(offset + size, C2length), string.format("C2(Signature): size=%d(0x%X)", C2length, C2length));
            size = size + C2length;
            
            -- auto change.
            utilityRtmpAddParsedPacketName("HandShake C2");
            rtmpNextPacketType = 4;
            debug(string.format("[dissect-c2] C2 packet decoded. consumed size:%d, packet type change to:%d, object type:%d", size, rtmpNextPacketType, rtmpCurrentObject.type));
            
            return size;
        end
        
        return 0;
    end
    
    --[[
    dissector the chunk pakcet(common packet) from buffer and append items to tree.
    return the consumed bytes and set the global status rtmpCurrentStatus:
    ]]
    function rtmpDissectChunkPacket(tree, buffer, offset)
        local size = 0;
        
        debug(string.format("[dissect-chunk] start to dissect a chunk stream. pool size:%d, offset:%d, available:%d", buffer:len(), offset, buffer:len() - offset));
        local root = uiRtmpTreeCreate(tree, buffer(offset, buffer:len() - offset), nil);
            
        -- parse chunk header
        size = size + rtmpParseChunkHeader(root, buffer, offset + size);
        -- if parse chunk header success, parse chunk data.
        if(rtmpCurrentStatus == 0)then
            -- parse chunk data
            size = size + rtmpParseChunkData(root, buffer, offset + size);
            -- if packet parsed success, update desc
            if(rtmpCurrentStatus == 0)then
                warn(string.format("[dissect-chunk] parse chunk packet success. pool size=%d, offset=%d, consumed=%d, available=%d", buffer:len(), offset, size, buffer:len() - offset - size));
                uiRtmpTreeSetText(root, string.format("RTMP: size=%d(0x%X)", size, size));
                -- only after the packet is dissected success, set the name and size.
                utilityRtmpAddParsedPacketName(utilityRtmpMessageTypeIdDesc(rtmpMessageTypeId));
                uiRtmpTreeSetLength(root, size);
            else
                warn(string.format("[dissect-chunk] parse chunk data error. consumed size=%d(will reset to 0), status=%d", size, rtmpCurrentStatus));
                size = 0;
                uiRtmpTreeSetText(root, string.format("RTMP: #Partial"));
            end
        -- if not success, only consume 0bytes, the high-level function knows how to process it.
        else
            -- force to drop the corrupted datas.
            -- the header must not parsed failed: maybe some corrupt datas! I donot know why.
            -- TODO: fix the corrupt data.
            -- there are more 2bytes at the end of packet, it is from:
            -- the TCP data is 514bytes, which contains(AMF0objects) such sequence(0x0120): 74 63 55 72 6C 02 C3 00 1F 72 74 6D 70 3A
            -- the 02 is string type, C3 00 is string length, decoded as: (type)string (length)193 (value).rtmp:
            -- but in the parsed packets the C3 is removed! the parsed packet sequence is(0x0120): 74 63 55 72 6C 02 00 1F 72 74 6D 70 3A
            -- and decoded is: (type)string (length)31 (value)rtmp:
            -- so, must ensure the amf decode success.
            rtmpCurrentStatus = -2;
            utilityRtmpAddParsedPacketName("#Error");
            warn(string.format("[dissect-chunk] parse chunk header error. consumed size=%d(will reset to 0), status=%d", size, rtmpCurrentStatus));
            size = 0;
            uiRtmpTreeSetText(root, string.format("RTMP: #Parse ChunkHeader Error"));
        end
        
        if(rtmpCurrentObject.type == -1)then
            rtmpCurrentObject.type = 4;
        end
        debug(string.format("[dissect-chunk] chunk dissect finihsed. next type is:%d, object type:%d", rtmpNextPacketType, rtmpCurrentObject.type));
        
        return size;
    end
    
    --[[
    dissector the chunk header from buffer and append items to tree.
    return the consumed bytes and set the global status rtmpCurrentStatus:
    ]]
    --[[
    Chunk Format
        Each chunk consists of a header and data. The header itself is broken
        down into three parts:
        +-------------+----------------+-------------------+--------------+
        | Basic header|Chunk Msg Header|Extended Time Stamp| Chunk Data |
        +-------------+----------------+-------------------+--------------+
        Figure 5 Chunk Format.
    ]]
    function rtmpParseChunkHeader(root, buf, offset)
        local size = 0;
        local ChunkHeader = uiRtmpTreeCreate(root, buf(offset + size, 0), string.format("ChunkHeader"));
        
        -- parse basic header
        size = size + rtmpParseBasicHeader(ChunkHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        -- parse chunk message header
        size = size + rtmpParseChunkMsgHeader(ChunkHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        -- parse extended timestamp
        size = size + rtmpParseExtendedTimeStamp(ChunkHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        
        uiRtmpTreeSetLength(ChunkHeader, size);
        uiRtmpTreeSetText(ChunkHeader, string.format("ChunkHeader: size=%d(0x%X)", size, size));
        return size;
    end
    
    --[[
    Chunk basic header: 1 to 3 bytes
        This field encodes the chunk stream ID and the chunk type. Chunk
        type determines the format of the encoded message header. The
        length depends entirely on the chunk stream ID, which is a
        variable-length field.
    ]]
    function rtmpParseBasicHeader(ChunkHeader, buf, offset)
        local size = 0;
        local BasicHeader = uiRtmpTreeCreate(ChunkHeader, buf(offset + size, size), string.format("BasicHeader"));
        
        size =  size + rtmpParseChunkType(BasicHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        size =  size + rtmpParseStreamIdLow(BasicHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        size =  size + rtmpParseStreamIdHigh(BasicHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        
        uiRtmpTreeSetLength(BasicHeader, size);
        uiRtmpTreeSetText(BasicHeader, string.format("BasicHeader: size=%d(0x%X)", size, size));
        return size;
    end
    
    --[[
    the chunk type is represented by fmt field
    fmt: 2 bits
    This field identifies one of four format used by the ‘chunk message
    header’.The ‘chunk message header’ for each of the chunk types is
    explained in the next section.
    ]]
    function rtmpParseChunkType(BasicHeader, buf, offset)
        -- check the buffer overflow.
        if(offset + 1 > buf:len())then
            warn("[dissect-chunk] need more bytes by chunk type. buf:%d offset:%d reqired:%d", buf:len(), offset, 1);
            rtmpCurrentStatus = -1;
            return 0;
        end
        
        -- UINT8 ChunkType:2 // 2bits
        rtmpChunkType = buf(offset, 1):bitfield(0, 2);
        uiRtmpTreeCreate(BasicHeader, buf(offset, 1), string.format("ChunkType: %d (0x%x) %s", rtmpChunkType, rtmpChunkType, utilityRtmpChunkTypeDesc(rtmpChunkType)));
        return 0;
    end
    
    --[[
    [0, 63] The IDs 0, 1, and 2 are reserved.
        0: StreamIdHigh is 1bytes.
        1: StreamIdHigh is 2bytes.
        2-63: StreamIdHigh is 0bytes.
    Chunk stream IDs 2-63 can be encoded in the 1-byte version of this field.
        0 1 2 3 4 5 6 7
        +-+-+-+-+-+-+-+-+
        |fmt| cs id |
        +-+-+-+-+-+-+-+-+
        Figure 6 Chunk basic header 1
    ]]
    function rtmpParseStreamIdLow(BasicHeader, buf, offset)
        -- check the buffer overflow.
        if(offset + 1 > buf:len())then
            warn("[dissect-chunk] need more bytes by chunk stream id low. buf:%d offset:%d reqired:%d", buf:len(), offset, 1);
            rtmpCurrentStatus = -1;
            return 0;
        end
        
        -- UINT8 StreamIdLow:6 // 6bits
        rtmpStreamIdLow = buf(offset, 1):bitfield(2, 6);
        uiRtmpTreeCreate(BasicHeader, buf(offset, 1), string.format("StreamIdLow: %d (0x%x) %s", rtmpStreamIdLow, rtmpStreamIdLow, utilityRtmpStreamIdLowDescrition(rtmpStreamIdLow)));
        return 1;
    end
    
    --[[
    winlin: if StreamIdLow is not enough, use the high.
    ]]
    function rtmpParseStreamIdHigh(BasicHeader, buf, offset)
        local size = 0;
        
        -- UINT8 StreamIdHigh: 0, 1, 2 bytes
        if(rtmpStreamIdLow == 0) then
            --[[
            Value 0 indicates the ID in the range of 64–319 (the second byte + 64).
            Chunk stream IDs 64-319 can be encoded in the 2-byte version of this
            field. ID is computed as (the second byte + 64).
                0                   1
                0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
                +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                |fmt| 0       | cs id - 64      |
                +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                Figure 7 Chunk basic header 2
            This field contains the chunk stream ID minus 64.
            ]]
            -- UINT8 StreamIdHigh // 1bytes
            size = 1;
            -- check the buffer overflow.
            if(offset + size > buf:len())then
                warn("[dissect-chunk] need more bytes by chunk stream id high. buf:%d offset:%d reqired:%d", buf:len(), offset, size);
                rtmpCurrentStatus = -1;
                return 0;
            end
            rtmpStreamIdHigh = buf(offset, size):uint();
            uiRtmpTreeCreate(BasicHeader, buf(offset, size), string.format("StreamIdHigh: %d (%x)", rtmpStreamIdHigh, rtmpStreamIdHigh));
        elseif(rtmpStreamIdLow == 1) then
            --[[
            Value 1 indicates the ID in the range of 64–65599 ((the third byte)*256 + the second byte + 64).
            Chunk stream IDs 64-65599 can be encoded in the 3-byte version of
            this field. ID is computed as ((the third byte)*256 + the second byte + 64).
                0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3
                +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                |fmt| 1 | cs id - 64 |
                +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                Figure 8 Chunk basic header 3
            This field contains the chunk stream ID minus 64.
            ]]
            -- UINT16 StreamIdHigh // 2bytes
            size = 2;
            -- check the buffer overflow.
            if(offset + size > buf:len())then
                warn("[dissect-chunk] need more bytes by chunk stream id high. buf:%d offset:%d reqired:%d", buf:len(), offset, size);
                rtmpCurrentStatus = -1;
                return 0;
            end
            rtmpStreamIdHigh = buf(offset, size):uint();
            uiRtmpTreeCreate(BasicHeader, buf(offset, size), string.format("StreamIdHigh: %d (%x)", rtmpStreamIdHigh, rtmpStreamIdHigh));
        else
            -- RtmpNone StreamIdHigh; // 0bytes
            rtmpStreamIdHigh = -1;
            uiRtmpTreeCreate(BasicHeader, buf(offset, size), string.format("StreamIdHigh: None"));
        end
        
        return size;
    end
    
    --[[
    There are four different formats for the chunk message header,
    selected by the "fmt" field in the chunk basic header.
    ]]
    function rtmpParseChunkMsgHeader(ChunkHeader, buf, offset)
        local size = 0;
        local ChunkMsgHeader = uiRtmpTreeCreate(ChunkHeader, buf(offset + size, size), string.format("ChunkMsgHeader"));
        
        size =  size + rtmpParseTimestampDelta(ChunkMsgHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        size =  size + rtmpParseMessageLength(ChunkMsgHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        size =  size + rtmpParseMessageTypeId(ChunkMsgHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        size =  size + rtmpParseMessageStreamId(ChunkMsgHeader, buf, offset + size);
        if(rtmpCurrentStatus ~= 0)then
            return 0;
        end
        
        uiRtmpTreeSetLength(ChunkMsgHeader, size);
        uiRtmpTreeSetText(ChunkMsgHeader, string.format("ChunkMsgHeader: size=%d(0x%X)", size, size));
        return size;
    end
    
    --[[
    timestamp delta: 3 bytes
    For a type-1 or type-2 chunk, the difference between the previous
    chunk's timestamp and the current chunk's timestamp is sent here.
    If the delta is greater than or equal to 16777215 (hexadecimal
    0x00ffffff), this value MUST be 16777215, and the ‘extended
    timestamp header’ MUST be present. Otherwise, this value SHOULD be
    the entire delta.
    ]]
    function rtmpParseTimestampDelta(ChunkMsgHeader, buf, offset)
        local size = 0;
        
        if(rtmpChunkType == 0 or rtmpChunkType == 1 or rtmpChunkType == 2) then
            -- UINT24 TimestampDelta; // 3bytes
            size = 3;
            -- check the buffer overflow.
            if(offset + size > buf:len())then
                warn("[dissect-chunk] need more bytes by timestamp delta. buf:%d offset:%d reqired:%d", buf:len(), offset, size);
                rtmpCurrentStatus = -1;
                return 0;
            end
            rtmpTimestampDelta = buf(offset, size):uint();
            uiRtmpTreeCreate(ChunkMsgHeader, buf(offset, size), string.format("TimestampDelta: %d (0x%x)", rtmpTimestampDelta, rtmpTimestampDelta));
        else
            -- RtmpNone TimestampDelta; // 0bytes
            rtmpTimestampDelta = -1;
            uiRtmpTreeCreate(ChunkMsgHeader, buf(offset, size), string.format("TimestampDelta: None"));
        end
        
        return size;
    end
    
    --[[
    message length: 3 bytes
    For a type-0 or type-1 chunk, the length of the message is sent
    here.
    Note that this is generally not the same as the length of the chunk
    payload. The chunk payload length is the maximum chunk size for all
    but the last chunk, and the remainder (which may be the entire
    length, for small messages) for the last chunk.
    ]]
    function rtmpParseMessageLength(ChunkMsgHeader, buf, offset)
        local size = 0;
        
        if(rtmpChunkType == 0 or rtmpChunkType == 1) then
            -- UINT24 MessageLength; // 3bytes
            size = 3;
            -- check the buffer overflow.
            if(offset + size > buf:len())then
                warn("[dissect-chunk] need more bytes by message length. buf:%d offset:%d reqired:%d", buf:len(), offset, size);
                rtmpCurrentStatus = -1;
                return 0;
            end
            rtmpMessageLength = buf(offset, size):uint();
            debug(string.format("[dissect-chunk] the message length parsed. len=%d, previous=%d", rtmpMessageLength, rtmpParsedMessageLength));
            rtmpParsedMessageLength = rtmpMessageLength;
            uiRtmpTreeCreate(ChunkMsgHeader, buf(offset, size), string.format("MessageLength: %d (0x%x)", rtmpMessageLength, rtmpMessageLength));
        else
            -- RtmpNone MessageLength; // 0bytes
            rtmpMessageLength = -1;
            warn(string.format("[dissect-chunk] the message length parse failed, use previous=%d", rtmpParsedMessageLength));
            uiRtmpTreeCreate(ChunkMsgHeader, buf(offset, size), string.format("MessageLength: None"));
        end
        
        return size;
    end
    
    --[[
    message type id: 1 byte
    For a type-0 or type-1 chunk, type of the message is sent here.
    ]]
    function rtmpParseMessageTypeId(ChunkMsgHeader, buf, offset)
        local size = 0;
        
        if(rtmpChunkType == 0 or rtmpChunkType == 1) then
            -- UINT8 MessageTypeId; // 1bytes
            size = 1;
            -- check the buffer overflow.
            if(offset + size > buf:len())then
                warn("[dissect-chunk] need more bytes by message type id. buf:%d offset:%d reqired:%d", buf:len(), offset, size);
                rtmpCurrentStatus = -1;
                return 0;
            end
            rtmpMessageTypeId = buf(offset, size):uint();
            uiRtmpTreeCreate(ChunkMsgHeader, buf(offset, size), string.format("MessageTypeId: %d (0x%x) %s", rtmpMessageTypeId, rtmpMessageTypeId, utilityRtmpMessageTypeIdDesc(rtmpMessageTypeId)));
        else
            -- RtmpNone MessageTypeId; // 0bytes
            rtmpMessageTypeId = -1;
            uiRtmpTreeCreate(ChunkMsgHeader, buf(offset, size), string.format("MessageTypeId: None"));
        end
        
        return size;
    end
    
    --[[
    message stream id: 4 bytes
    For a type-0 chunk, the message stream ID is stored. Message stream
    ID is stored in little-endian format. Typically, all messages in
    the same chunk stream will come from the same message stream. While
    it is possible to multiplex separate message streams into the same
    chunk stream, this defeats all of the header compression. However,
    if one message stream is closed and another one subsequently
    opened, there is no reason an existing chunk stream cannot be
    reused by sending a new type-0 chunk.
    ]]
    function rtmpParseMessageStreamId(ChunkMsgHeader, buf, offset)
        local size = 0;
        
        if(rtmpChunkType == 0) then
            -- UINT32 MessageStreamId; // 4bytes
            size = 4;
            -- check the buffer overflow.
            if(offset + size > buf:len())then
                warn("[dissect-chunk] need more bytes by message stream id. buf:%d offset:%d reqired:%d", buf:len(), offset, size);
                rtmpCurrentStatus = -1;
                return 0;
            end
            -- WINLIN: in little-endian format.
            rtmpMessageStreamId = buf(offset, size):le_uint();
            uiRtmpTreeCreate(ChunkMsgHeader, buf(offset, size), string.format("MessageStreamId: %d (0x%x)", rtmpMessageStreamId, rtmpMessageStreamId));
        else
            -- RtmpNone MessageStreamId; // 0bytes
            rtmpMessageStreamId = -1;
            uiRtmpTreeCreate(ChunkMsgHeader, buf(offset, size), string.format("MessageStreamId: None"));
        end
        
        return size;
    end
    
    --[[
    ExtendedTimeStamp
    This field is transmitted only when the normal time stamp in the
    chunk message header is set to 0x00ffffff. If normal time stamp is
    set to any value less than 0x00ffffff, this field MUST NOT be
    present. This field MUST NOT be present if the timestamp field is not
    present. Type 3 chunks MUST NOT have this field.
    0 or 4 bytes
    ]]
    function rtmpParseExtendedTimeStamp(ChunkHeader, buf, offset)
        local size = 0;
        
        if(rtmpTimestampDelta == 0x00ffffff) then
            -- UINT32 ExtendedTimeStamp; // 4bytes
            size = 4;
            -- check the buffer overflow.
            if(offset + size > buf:len())then
                warn("[dissect-chunk] need more bytes by extended timestamp. buf:%d offset:%d reqired:%d", buf:len(), offset, size);
                rtmpCurrentStatus = -1;
                return 0;
            end
            rtmpExtendedTimeStamp = buf(offset, size):uint();
            uiRtmpTreeCreate(ChunkHeader, buf(offset, size), string.format("ExtendedTimeStamp: %d(0x%X) (size=%d)", rtmpExtendedTimeStamp, rtmpExtendedTimeStamp, size));
        else
            -- RtmpNone ExtendedTimeStamp; // 0bytes
            rtmpExtendedTimeStamp = -1;
            uiRtmpTreeCreate(ChunkHeader, buf(offset, 0), string.format("ExtendedTimeStamp: None (size=%d)", size));
        end
        
        return size;
    end
    
    --[[
    ]]
    function rtmpParseChunkData(root, buf, offset)
        local size = 0;
        
        -- if require more message, consumed 0.
        if(buf:len() < offset + rtmpParsedMessageLength)then
            warn(string.format("[dissect-chunk] the chunk data need more bytes to parse. pool size=%d, offset=%d, available=%d, required=%d", buf:len(), offset, buf:len() - offset, rtmpParsedMessageLength));
            -- we think if chunk data cannot parse, it's error: a TCP packet must contains a whole chunk.
            rtmpCurrentStatus = -3;
            utilityRtmpAddParsedPacketName("#Partial");
            
            return size;
        end
        
        -- consume the message data
        size = rtmpParsedMessageLength;
        
        local ChunkData = uiRtmpTreeCreate(root, buf(offset, size), string.format("ChunkData: size=%d(0x%x)", size, size));
        debug(string.format("[dissect-chunk] the chunk data dissect success. pool size=%d, consumed size=%d", buf:len(), size));
        
        return size;
    end
    
    --[[
    ==============================================================================
    ========================defines the ui methods================================
    ==============================================================================
    ]]
    -- set the PacketList protocol column text
    function uiRtmpColumnProtocolSet(msg)
        if(rtmpCurrentObject.show)then
            rtmpCurrentPacket.cols.protocol:set(msg);
        end
    end
    -- set the PacketList info column text
    function uiRtmpColumnInfoSet(msg)
        if(rtmpCurrentObject.show)then
            rtmpCurrentPacket.cols.info:set(msg);
        end
    end
    -- append the PacketList info column text
    function uiRtmpColumnInfoAppend(msg)
        if(rtmpCurrentObject.show)then
            rtmpCurrentPacket.cols.info:append(msg);
        end
    end
    -- set the PacketDetail tree item size.
    function uiRtmpTreeSetLength(root, size)
        if(rtmpCurrentObject.show and root ~= nil)then
            root:set_len(size);
        end
    end
    -- set the PacketDetail tree item text.
    function uiRtmpTreeSetText(root, msg)
        if(rtmpCurrentObject.show and root ~= nil)then
            root:set_text(msg);
        end
    end
    -- append the PacketDetail tree item text.
    function uiRtmpTreeAppendText(root, msg)
        if(rtmpCurrentObject.show and root ~= nil)then
            root:append_text(msg);
        end
    end
    -- create the PacketDetail sub tree item.
    function uiRtmpTreeCreate(tree, buf, msg)
        if(rtmpCurrentObject.show and tree ~= nil)then
            if(buf ~= nil)then
                if(msg ~= nil)then
                    return tree:add(rtmp, buf, msg);
                else
                    return tree:add(rtmp, buf);
                end
            else
                return tree:add(rtmp);
            end
        else
            return nil;
        end
    end
    
    --[[
    ==============================================================================
    ========================defines the utility methods===========================
    ==============================================================================
    ]]
    --[[
    value: rtmpChunkType (BasicHeader.ChunkType)
    ]]
    function utilityRtmpChunkTypeDesc(rtmpChunkType)
        local value = rtmpChunkType;
        
        if(value == 0x00) then
            return "NewChunkAndMessage: start of a new chunk stream for new message.";
        elseif(value == 0x01) then
            return "SameMessageStream: same stream ID, variable-sized message streams.";
        elseif(value == 0x02) then
            return "RegisterTimeDelta: only timestamp delta, constant-sized message streams.";
        elseif(value == 0x03) then
            return "SameAsPreviousChunk: no header, take values from the preceding chunk.";
        else
            return "UnknownChunkType";
        end
    end
    --[[
    value: rtmpStreamIdLow (BasicHeader.StreamIdLow)
    ]]
    function utilityRtmpStreamIdLowDescrition(rtmpStreamIdLow)
        local value = rtmpStreamIdLow;
        
        if(value == 0x02) then
            return "(low-level message)"; -- 2: low-level message; otherwise, normal message.
        else
            return "";
        end
    end
    --[[
    value: rtmpMessageTypeId (ChunkMsgHeader.MessageTypeId)
    ]]
    function utilityRtmpMessageTypeIdDesc(rtmpMessageTypeId)
        local value = rtmpMessageTypeId;
        
        --[[
        5. Protocol Control Messages
        RTMP reserves message type IDs 1-7 for protocol control messages.
        These messages contain information needed by the RTM Chunk Stream
        protocol or RTMP itself. Protocol messages with IDs 1 & 2 are
        reserved for usage with RTM Chunk Stream protocol. Protocol messages
        with IDs 3-6 are reserved for usage of RTMP. Protocol message with ID
        7 is used between edge server and origin server.
        ]]
        if(value == 0x01) then
            return "Set Chunk Size";
        elseif(value == 0x02) then
            return "Abort Message";
        elseif(value == 0x03) then
            return "Acknowledgement";
        elseif(value == 0x04) then
            return "User Control Message";
        elseif(value == 0x05) then
            return "Window Acknowledgement Size";
        elseif(value == 0x06) then
            return "Set Peer Bandwidth";
        elseif(value == 0x07) then
            return "Edge And Origin Server Command";
        --[[
        3. Types of messages
        The server and the client send messages over the network to
        communicate with each other. The messages can be of any type which
        includes audio messages, video messages, command messages, shared
        object messages, data messages, and user control messages.
        ]]
        --[[
        3.1. Command message
        Command messages carry the AMF-encoded commands between the client
        and the server. These messages have been assigned message type value
        of 20 for AMF0 encoding and message type value of 17 for AMF3
        encoding. These messages are sent to perform some operations like
        connect, createStream, publish, play, pause on the peer. Command
        messages like onstatus, result etc. are used to inform the sender
        about the status of the requested commands. A command message
        consists of command name, transaction ID, and command object that
        contains related parameters. A client or a server can request Remote
        Procedure Calls (RPC) over streams that are communicated using the
        command messages to the peer.
        ]]
        elseif(value == 17) then
            return "AMF3 Command Message.";
        elseif(value == 20) then
            return "AMF0 Command Message.";
        --[[
        3.2. Data message
        The client or the server sends this message to send Metadata or any
        user data to the peer. Metadata includes details about the
        data(audio, video etc.) like creation time, duration, theme and so
        on. These messages have been assigned message type value of 18 for
        AMF0 and message type value of 15 for AMF3.        
        ]]
        elseif(value == 18) then
            return "AMF3 Data Message.";
        elseif(value == 15) then
            return "AMF0 Data Message.";
        --[[
        3.3. Shared object message
        A shared object is a Flash object (a collection of name value pairs)
        that are in synchronization across multiple clients, instances, and
        so on. The message types kMsgContainer=19 for AMF0 and
        kMsgContainerEx=16 for AMF3 are reserved for shared object events.
        Each message can contain multiple events.
        ]]
        --[[
        3.4. Audio message
        The client or the server sends this message to send audio data to the
        peer. The message type value of 8 is reserved for audio messages.
        ]]
        elseif(value == 8) then
            return "Audio message";
        --[[
        3.5. Video message
        The client or the server sends this message to send video data to the
        peer. The message type value of 9 is reserved for video messages.
        These messages are large and can delay the sending of other type of
        messages. To avoid such a situation, the video message is assigned
        the lowest priority.
        ]]
        elseif(value == 9) then
            return "Video message";
        --[[
        3.6. Aggregate message
        An aggregate message is a single message that contains a list of submessages.
        The message type value of 22 is reserved for aggregate
        messages.
        ]]
        elseif(value == 22) then
            return "Aggregate message";
        --[[
        3.7. User Control message
        The client or the server sends this message to notify the peer about
        the user control events. For information about the message format,
        refer to the User Control Messages section in the RTMP Message
        Foramts draft.
        ]]
        else
            return "Unknown Message Type";
        end
    end
    
    --[[
    print all linkups.
    ]]
    function utilityRtmpGetObjectLinkupString(rtmpObject)
        if(rtmpObject == nil or rtmpObject.pre == 0)then
            return string.format("%d", rtmpObject.id);
        end
        
        -- get the whole link.
        local previousLinks = string.format("%d(%d)", rtmpObject.id, rtmpObject.bytes:len()); 
        local ppreviousObj = rtmpObject;
        while(ppreviousObj.pre > 0)do
            ppreviousObj = rtmpObjectPool[ppreviousObj.pre];
            previousLinks = string.format("%d(%d)=>%s", ppreviousObj.id, ppreviousObj.bytes:len() - ppreviousObj.refpos, previousLinks);
            
            -- break the partial refer
            if(ppreviousObj.refpos > 0)then
                break;
            end
        end
        
        return previousLinks;
    end
    
    --[[
    setup the linkups.
    ]]
    function utilityRtmpSetupObjectLinkups(rtmpObject)
        -- then setup the link of objects.
        local previousObject = nil;
        local currentId = rtmpObject.id - 1;
        while(currentId >= 0)do
            local obj = rtmpObjectPool[currentId];
            
            if(obj ~= nil)then
                -- if the next of obj is uninitialized, it must has a next packet.
                if(obj.next == -1)then
                    previousObject = obj;
                    -- set the link.
                    previousObject.next = rtmpObject.id;
                    rtmpObject.pre = previousObject.id;
                    debug(string.format("[oopool] setup the linkup: %s", utilityRtmpGetObjectLinkupString(rtmpObject)));
                end
            end
            
            currentId = currentId -1;
        end
        if(previousObject == nil)then
            rtmpObject.pre = 0;
            debug(string.format("[oopool] no previous pakcet found, set packet %d to single packet.", rtmpObject.id));
        end
    end
    
    --[[
    if object specified by pktNumber exists, get it, otherwise create a new object and push to pool
    ]]
    function utilityRtmpCreateOrGetObject(pkt, buf)
        local rtmpObject = rtmpObjectPool[pkt.number];
        
        if(rtmpObject == nil) then
            -- create a new rtmp object
            rtmpObject = {
                id = pkt.number, 
                src_port = pkt.src_port,
                type = -1, 
                show = false, 
                pre = -1, 
                refpos = 0,
                next = -1, 
                bytes = nil,
                packet_names = {}
            };
            
            -- convert buf(Tvb) to ByteArray.
            local bufByteArray = buf(0, buf:len()):bytes();
            rtmpObject.bytes = ByteArray.new(tostring(bufByteArray));
            debug(string.format("[oopool] nil found, create a new object."));
            
            utilityRtmpSetupObjectLinkups(rtmpObject);
            
            rtmpObjectPool[pkt.number] = rtmpObject;
            debug(string.format("[oopool] create a new rtmp object in oo pool. id=%d, buf=%d", rtmpObject.id, rtmpObject.bytes:len()));
        else
            debug(string.format("[oopool] get a exists object in oo pool. id=%d, buf=%d", rtmpObject.id, rtmpObject.bytes:len()));
        end
        
        return rtmpObject;
    end
    
    --[[
    insert a packet name to the current object.
    ]]
    function utilityRtmpAddParsedPacketName(parsedPacketName)
        info(string.format("[utility] add parsed packet name to object(%d): %s", rtmpCurrentObject.id, parsedPacketName));
        
        -- insert to the head.
        table.insert(rtmpCurrentObject.packet_names, 0, parsedPacketName);
    end

    --[[
    append the buffer to the pool.
    ]]
    function utilityRtmpAppendBytesPool(rtmpObject)
        debug(string.format("[pool] start to initialize bytes pool. object.bytes=%d", rtmpObject.bytes:len()));
        if(rtmpObject.bytes:len() <=  0)then
            critical(string.format("[pool] the pakcet buffer must not be empty, actual size=%d", 0));
            return;
        end
        
        -- clear the bytes pool and push all link bytes to pool
        rtmpBytesPool = ByteArray.new();
        local currentObject = rtmpObject;
        while(currentObject ~= nil)do
            -- must insert the object bytes in the front of pool.
            rtmpBytesPool = ByteArray.new(tostring(currentObject.bytes) .. tostring(rtmpBytesPool));
            
            currentObject = rtmpObjectPool[currentObject.pre];
            -- append the partially bytes.
            if(currentObject ~= nil)then
                local refpos = currentObject.refpos;
                
                -- refer to the only previous object.
                if(refpos > 0)then
                    -- append the partial bytes.
                    local length = currentObject.bytes:len();
                    warn(string.format("[pool] get the partiical bytes from previous object: id=%d offset=%d length=%d part-bytes=%d", currentObject.id, refpos, length, length-refpos));
                    local partBytes = currentObject.bytes:subset(refpos, length - refpos);
                    rtmpBytesPool = ByteArray.new(tostring(partBytes) .. tostring(rtmpBytesPool));
                    
                    -- break the loop.
                    currentObject = nil;
                end
            end
        end
        debug(string.format("[pool] linkup of object(%d) is %s. pool size=%d", rtmpObject.id, utilityRtmpGetObjectLinkupString(rtmpObject), rtmpBytesPool:len()));
        
        -- return the TvbRange
        return rtmpBytesPool:tvb("");
    end
    
    --[[
    whether the pakcet is from server.
    ]]
    function utilityRtmpIsFromServer(pkt)
        return pkt.src_port == rtmpServerPort;
    end
    
    --[[
    discovery the sender name. return "server" if from server, otherwise "client".
    ]]
    function utilityRtmpDiscoverySender(pkt)
        if(utilityRtmpIsFromServer(pkt)) then
            return "server";
        else
            return "client";
        end
    end
    
    --[[
    ==============================================================================
    ========================register protocol parser==============================
    ==============================================================================
    ]]
    --[[
    ]]
    -- register to dissector table
    if(true) then
        local tcp_port_table = DissectorTable.get("tcp.port");
        tcp_port_table:add(1935, rtmp);
        tcp_port_table:add(1985, rtmp);
    end
end

