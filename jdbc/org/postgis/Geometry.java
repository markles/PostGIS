package org.postgis;

public class Geometry 
{

	/**
	 * The dimensionality of this feature (2,3)
	 */
	public int dimension;
	
	/**
	 * The OGIS geometry type of this feature.
	 */
	public int type;

	/**
	 * The OGIS geometry type number for points.
	 */
	public static int POINT = 1;

	/**
	 * The OGIS geometry type number for lines.
	 */
	public static int LINESTRING = 2;

	/**
	 * The OGIS geometry type number for polygons.
	 */
	public static int POLYGON = 3;

	/**
	 * The OGIS geometry type number for aggregate points.
	 */
	public static int MULTIPOINT = 4;

	/**
	 * The OGIS geometry type number for aggregate lines.
	 */
	public static int MULTILINESTRING = 5;

	/**
	 * The OGIS geometry type number for aggregate polygons.
	 */
	public static int MULTIPOLYGON = 6;
	
	/**
	 * The OGIS geometry type number for feature collections.
	 * Feature collections are not currently supported by the
	 * backend.
	 */
	public static int GEOMETRYCOLLECTION = 7;
	
	/**
	 * @return The OGIS geometry type number of this geometry.
	 */
	public int getType() {
		return type;
	}
	
	/**
	 * @return The dimensionality (eg, 2D or 3D) of this geometry.
	 */
	public int getDimension() {
		return dimension;
	}

}
