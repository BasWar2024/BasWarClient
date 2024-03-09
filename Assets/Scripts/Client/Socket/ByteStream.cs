using System;
using System.IO;
using System.Collections.Generic;

namespace GG.Net {
    // 
    public class ByteStream {

        private static Queue<ByteStream> pool = new Queue<ByteStream>();
        public static ByteStream Allocate () {
            ByteStream stream = null;
            lock(pool) {
                if (pool.Count == 0) {
                    stream = new ByteStream();
                } else {
                    stream = pool.Dequeue();
                }
            }
            return stream;
        }

        public static void Free(ByteStream stream) {
            lock(pool) {
                stream.Clear();
                pool.Enqueue(stream);
            }
        }

        public const int SEEK_BEGIN = 0;
        public const int SEEK_CUR = 1;
        public const int SEEK_END = 2;

        private byte[] buffer;
        private int pos;

        public ByteStream () {
            this.buffer = new byte[256];
            this.pos = 0;
        }

        public byte[] Buffer {
            get {return this.buffer;}
            set {this.buffer = value;}
        }
        public int Position {
            get {return this.pos;}
        }
        public int Capcity {
            get {return this.buffer.Length;}
        }

        public void Expand (int size) {
            if (this.Capcity - this.pos < size) {
                int oldCapacity = this.Capcity;
                int capcity = this.Capcity;
                while (capcity - this.pos < size) {
                    capcity = capcity * 2;
                }
                byte [] newBuffer = new byte[capcity];
                Array.Copy(newBuffer,0,this.buffer,0,oldCapacity);
                this.buffer = newBuffer;
            }
        }

        public void WriteByte (byte b) {
            this.Expand(sizeof(byte));
            this.buffer[this.pos++] = b;
        }

        public void WriteUInt16(UInt16 value) {
            int len = sizeof(UInt16);
            for (int i = 0; i < len; i++) {
                this.WriteByte((byte)((value >> i*8) & 0xff));
            }
        }

        public void WriteUInt32(UInt32 value) {
            int len = sizeof(UInt32);
            for (int i = 0; i < len; i++) {
                this.WriteByte((byte)((value >> i*8) & 0xff));
            }
        }

        public void WriteUInt64(UInt64 value) {
            int len = sizeof(UInt64);
            for (int i = 0; i < len; i++) {
                this.WriteByte((byte)((value >> i*8) & 0xff));
            }
        }

        public void Write(byte[] bytes,int start,int length) {
            for (int i = 0; i < length; i++) {
                byte b = bytes[start + i];
                this.WriteByte(b);
            }
        }
        public byte ReadByte () {
            return this.buffer[this.pos++];
        }

        public UInt16 ReadUInt16() {
            int number = 0;
            int len = sizeof(UInt16);
            for (int i = 0; i < len; i++) {
                byte b = this.ReadByte();
                number += (b << i * 8);
            }
            return (UInt16)number;
        }

        public UInt32 ReadUInt32() {
            int number = 0;
            int len = sizeof(UInt32);
            for (int i = 0; i < len; i++) {
                byte b = this.ReadByte();
                number += (b << i * 8);
            }
            return (UInt32)number;
        }

        public UInt64 ReadUInt64() {
            UInt64 number = 0;
            int len = sizeof(UInt64);
            for (int i = 0; i < len; i++) {
                byte b = this.ReadByte();
                number += (UInt64)(b << i * 8);
            }
            return number;
        }

        public int Read (byte[] bytes,int start,int length) {
            int canReadBytes = this.Capcity - this.pos;
            if (canReadBytes < length) {
                length = canReadBytes;
            }
            if (canReadBytes > 0 ) {
                Array.Copy(bytes,start,this.buffer,this.pos,canReadBytes);
            }
            this.pos += canReadBytes;
            return length;
        }

        public int Seek (int offset,int whence) {
            switch (whence) {
                case ByteStream.SEEK_BEGIN:
                    this.pos = 0 + offset;
                    break;
                case ByteStream.SEEK_CUR:
                    this.pos = this.pos + offset;
                    break;
                case ByteStream.SEEK_END:
                    this.pos = this.Capcity + offset;
                    break;
                default:
                    throw new Exception(string.Format("[ByteStream.Seek] invalid whence:{0}",whence));
            }
            this.Expand(0);
            return this.pos;
        }

        public void Clear() {
            this.pos = 0;
        }
    }
}