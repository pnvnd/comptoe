package brave.formats;
import nme.utils.ByteArray;

/**
 * ...
 * @author soywiz
 */

class Decrypt 
{

	private function new() 
	{
		
	}
	
	static public var key23:Array<Int> = [
		0x23, 0xA0, 0x99, 0x50, 0x3B, 0xA7, 0xB9, 0xB6, 0xE1, 0x8E, 0x92, 0xF9, 0xF4, 0xFC, 0x3D, 0xE8,
		0x71, 0xF9, 0xF4, 0x28, 0xE6, 0xE7, 0xE8, 0x38, 0x33, 0x06, 0x0B, 0x04, 0x0B, 0x03
	];

	static public var key47:Array<Int> = [
		0x47, 0xCE, 0x11, 0x29, 0x3E, 0x8A, 0x8B, 0x84 , 0xD2, 0xD1, 0x62, 0x88, 0x2D, 0xA7, 0x47, 0x19,
		0x08, 0x8A, 0x18, 0x7A, 0xE7, 0x60, 0xE8, 0x08 , 0x37, 0x32, 0x05, 0x0A, 0x48, 0x55
	];

	static public var key82:Array<Int> = [
		0x82, 0x74, 0x7D, 0x7D, 0x76, 0x6F, 0x7F, 0x7D, 0x7B, 0x75, 0x28, 0x6F, 0x18, 0x6B, 0x82, 0x00,
		0x65, 0xE4, 0xE4, 0x7B, 0xE6, 0xE7, 0xE8, 0x08, 0x0D, 0x06, 0x35, 0x2B, 0xC3, 0x05,
	];

	/**
	 * 
	 * @param	cl
	 * @param	dl
	 * @return
	 */
	static inline public function decryptPrimitive(cl:Int, dl:Int):Int
	{
		return (~(cl & dl) & (cl | dl)) & 0xFF;
	}
	
	/**
	 * 
	 * @param	data
	 * @param	key
	 * @return
	 */
	@:noStack static public function decryptDataWithKey(data:ByteArray, key:Array<Int>):ByteArray
	{
		var out:ByteArray = new ByteArray();
		
		var bl = 0;
		var dt = 0;
		
		data.position = 0;

		for (n in 0 ... data.length)
		{
			var keyOffset = ((n + bl) % key.length);
			//var dataByte = data[n];
			var dataByte = data.readByte();
			var cryptByte = (key[keyOffset] | (bl & dt)) & 0xFF;

			out.writeByte(decryptPrimitive(dataByte, cryptByte));

			if (keyOffset == 0)
			{
				bl = key[(bl + dt) % key.length];
				dt++;
			}
		}
		
		out.position = 0;
		
		return out;
	}
}