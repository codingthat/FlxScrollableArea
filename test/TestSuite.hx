import massive.munit.TestSuite;

import OffScrollbarClickTest;
import MouseWheelScrollTest;
import CorrectScrollbarsShownTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(OffScrollbarClickTest);
		add(MouseWheelScrollTest);
		add(CorrectScrollbarsShownTest);
	}
}
