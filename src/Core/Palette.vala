/***
    Copyright (C) 2013-2014 Draw Developers

    This program or library is free software; you can redistribute it
    and/or modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 3 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General
    Public License along with this library; if not, write to the
    Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
    Boston, MA 02110-1301 USA.

    Authored by: KJ Lawrence <kjtehprogrammer@gmail.com>
***/

using Granite.Drawing;
using GLib;
using Gee;


namespace Draw
{
	// Could probably be handled by a generic error but couldn't find documentation on it
	public errordomain PaletteError
	{
		NotFound,
		InvalidFormat
	}

	/**
	 * Palettes for drawing
	 */
	public class Palette
	{
		public ArrayList<Color> Colors = new ArrayList<Color>();
		public string Name { get; set; }

		/**
		 * Loads a palette from a file
		 * @param filename Palette name
		 */
		public Palette.from_file(string filename)
		{
			Colors = Palette.load_colors_from_file(filename);
			Name = filename.substring(0, filename.length - 4);
		}
		
		/**
		 * Instantiate a new palette from a list of colors
		 */
		public Palette.from_array(ArrayList<Color> colors)
		{
			Colors = colors;
		}
		
		/**
		 * Loads all palettes from the default palette directory
		 * @return Loaded palettes
		 */
		public static ArrayList<Palette> load_palettes()
		{
			var palettes = new ArrayList<Palette>();
			var PaletteDirectory = GLib.Environment.get_current_dir() + "/.draw/palettes";
			
			try
			{
				var directory = File.new_for_path(PaletteDirectory);
				var enumerator = directory.enumerate_children(FileAttribute.STANDARD_NAME, 0);
			
				FileInfo info;
				while ((info = enumerator.next_file()) != null)
					palettes.add(new Palette.from_file(PaletteDirectory +"/"+ info.get_name()));
			}
			catch (Error error)
			{
				stdout.printf("Unable to load palettes from directory, error: " + error.message);
			}
				
			return palettes;
		}

		/**
		 * Loads all of the colors from a given system file
		 *
		 * Format (based on Paint.NET):
		 * - Lines that start with a semi-color are comments
		 * - Colors are HEX, RRGGBBAA
		 * - The alpha ('AA') is FF for fully opaque, 00 fully transparent
		 * - Each palette constists of 96 colors. If there are more
		 *   they are ignored, less are white.
		 */
		public static ArrayList<Color> load_colors_from_file(string filename)
		{
			var Colors = new ArrayList<Color>();
			
			try
			{
				var file = File.new_for_path(filename);
				if (!file.query_exists())
					throw new PaletteError.NotFound("File not found.");

				var inputStream = new DataInputStream(file.read());
				string line;

				// Read each line until the end of file (null) is reached
				while ((line = inputStream.read_line(null)) != null)
				{			
					// If the first character is a semi-colon, skip this line
					if (line[0] == ';')
						continue;

					// Not a comment, so either a blank line or a color - if variable length, throw parse exception
					if (line.length == 8)
						Colors.add(convert_hex_to_color(line));
					else if (line.length == 0)
						continue;
					else
						stdout.printf("Warning: Unable to read line from palette.");
				}
			}
			catch (IOError error)
			{
				stdout.printf("Unable to load palette, error: " + error.message);
			}
			catch (Error error)
			{
				stdout.printf("Unable to load palette, error: " + error.message);
			}

			return Colors;
		}

		/**
		 * Converts a hex color to a byte (I'm sure there's a better way out there for this...)
		 * @param hex Hex color to convert (format: RRGGBBAA)
		 */
		private static Color convert_hex_to_color(string hex)
		{
			int[] bits = new int[8];
			for(int i = 0; i < hex.up().length; i++)
			{
				switch (hex[i])
				{
					case 'A':
						bits[i] = 10;
						break;
					case 'B':
						bits[i] = 11;
						break;
					case 'C':
						bits[i] = 12;
						break;
					case 'D':
						bits[i] = 13;
						break;
					case 'E':
						bits[i] = 14;
						break;
					case 'F':
						bits[i] = 15;
						break;
					default:
						bits[i] = int.parse(hex[i].to_string());
						break;
				}
			}

			double A = ((bits[0] * 16) + bits[1]) / 255.0;
			double R = ((bits[2] * 16) + bits[3]) / 255.0;
			double G = ((bits[4] * 16) + bits[5]) / 255.0;
			double B = ((bits[6] * 16) + bits[7]) / 255.0;
			return new Color(R, G, B, A);
		}
	}
}
