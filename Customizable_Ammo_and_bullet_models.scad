// Customizable_Ammo_and_bullet_models.scad
// October, 2016
// Albert Phan
// This scad library makes models of entire cartridges or just bullets.
// You can use it to make dummy rounds or dummy bullets or use as models in other openscad projects.
// Dimensions for ammo can be found from wikipedia.
// Dimensions are in mm.
// 

$fn = 100;


// Customizable stuff
/* [Global] */

// Choose the cartridge
cartridge = "30-06 Springfield";	// [30-06 Springfield, .357 magnum, custom]
// Type of bullet
bulletType = "rifleroundnose";		// [roundnose, pistolroundnose rifleroundnose, pointed, roundflat,semiwadcutter, wadcutter, pistolhollowpoint, riflehollowpoint]
// boatTail if making bullet only
boatTail = true;				//
// Make the cartridge or just the bullet
part = "cartridge";					// [cartridge, bullet]

/* [Custom] */

// TO DO: add customizer options to make customized cartridge
// From wikipedia images of cartridges dimensions
/*
// Rifle or Pistol (bottle neck or straight case)
cartridgeType = "rifle"	// [rifle,pistol] 
rimThickness 	// R
rimDiameter	// R1
extractorGrooveDiameter	// E1
extractorGrooveThickness	// e
extractorTaperHeight		// E
baseDiameter			// P1
shoulderDiameter 		// P2
neckDiameter			// H1
shoulderBaseHeight 	// L1
neckBaseHeight 		// L2
caseLength 			// L3
overallLength			// L6
bulletDiameter			// G1
bulletType = "2roundnose")				// roundnose, 2roundnose, pointed, roundflat, wadcutter, hollowpoint
*/


// Testing model
//makeCartridge("30-06 Springfield", "2roundnose", true);

if(part == "cartridge")
{
	if(cartridge == "custom")
		makeCustomCartridge();
	else
		makeCartridge(cartridge, bulletType, boatTail);
}
else if(part == "bullet")
{
	// make only bullet
	makeCartridge(cartridge, bulletType, boatTail, true);
}

		

module makeCartridge(cartridge, bulletType, boatTail, bulletOnly)
{
		
	if (cartridge == "30-06 Springfield")
	{
		makeCustomCartridge("rifle", 1.24,12.01,10.39,0.84,3.16,11.96,11.2,8.63,49.49,53.56,63.35,84.84,7.85, bulletType);
		//makeBullet(7.85, 84.84 - 63.35, bulletType, boatTail);	// bullet only for making dummy rounds with real cases
	}
	else if (cartridge == ".357 magnum")
	{
		makeCustomCartridge("pistol", 1.5,11.2,0,0,0,9.6,0,0,0,0,33,40,9.1, bulletType);
	}
}
		

module makeCustomCartridge(
// From wikipedia images of cartridges dimensions
cartridgeType,	// rifle or pistol (bottle neck or straight case)
rimThickness, 	// R
rimDiameter,	// R1
extractorGrooveDiameter,	// E1
extractorGrooveThickness,	// e
extractorTaperHeight, 		// E
baseDiameter, 			// P1
shoulderDiameter, 		// P2
neckDiameter,			// H1
shoulderBaseHeight, 	// L1
neckBaseHeight, 		// L2
caseLength, 			// L3
overallLength, 			// L6
bulletDiameter,			// G1
bulletType = "2roundnose")				// roundnose, 2roundnose, pointed, roundflat, wadcutter, hollowpoint
{
	if(bulletOnly == true)
	{
		color("chocolate")
			makeCustomBullet(bulletDiameter, overallLength - caseLength, bulletType);
	}
	// Sanity check for overall length
	//%cylinder(d = rimDiameter, h = overallLength);
	// Rim
	cylinder(d = rimDiameter, h = rimThickness); 
	translate([0,0,rimThickness])
	{
		// Extractor Groove
		cylinder(d = extractorGrooveDiameter, h = extractorGrooveThickness);
		translate([0,0,extractorGrooveThickness])
		{
			// Extractor Groove taper
			cylinder(d1 = extractorGrooveDiameter, d2 = baseDiameter, h = extractorTaperHeight - (rimThickness + extractorGrooveThickness)); 
			translate([0,0,extractorTaperHeight - (rimThickness + extractorGrooveThickness)])
			{
				if(cartridgeType == "rifle")
				{
					// Rifle Case 
					cylinder(d1 = baseDiameter, d2 = shoulderDiameter, h = shoulderBaseHeight - extractorTaperHeight);
					translate([0,0,shoulderBaseHeight - extractorTaperHeight])
					{
						// Shoulder
						cylinder(d1 = shoulderDiameter, d2 = neckDiameter, h = neckBaseHeight - shoulderBaseHeight);
						translate([0,0,neckBaseHeight - shoulderBaseHeight])
						{
							// Neck
							cylinder(d = neckDiameter, h = caseLength - neckBaseHeight);
							translate([0,0,caseLength - neckBaseHeight])
								color("chocolate")
									makeCustomBullet(bulletDiameter, overallLength - caseLength, bulletType);
						}
					}
				}
				else
				{
					// Pistol Case 
					cylinder(d = baseDiameter, h = caseLength - extractorTaperHeight);
					translate([0,0,caseLength - extractorTaperHeight])
						color("chocolate")
							makeCustomBullet(bulletDiameter, overallLength - caseLength, bulletType);
				}
				
			}
		}
	}
}

module makeCustomBullet(bulletDiameter, bulletHeight, bulletType = "rifleroundnose", boatTail = false)
{
	boatTailLength = bulletDiameter*(1-tan(10));
	
	// Bullettype
	if (bulletType == "rifleroundnose")
	{
		makeRoundnose(4);	
	}
	else if (bulletType == "pistolroundnose")
	{
		makeRoundnose(1.5);
		
	}
	else if (bulletType == "roundnose")
	{
		makeRoundnose(1);
		
	}
	else if (bulletType == "pointed")
	{
		makeRoundnose(6);
		
	}
	else if (bulletType == "roundflat")
	{
		difference()
		{
			makeRoundnose(2);
			translate([0,0, bulletHeight - bulletDiameter * 0.2])
				cylinder(d = bulletDiameter, h = bulletDiameter);
		}
		
	}
	else if(bulletType == "wadcutter")
	{
		cylinder(d = bulletDiameter, h = bulletHeight);
		
	}
	else if(bulletType == "semiwadcutter")
	{
		cylinder(d = bulletDiameter, h = bulletHeight - bulletHeight* 0.9);
		translate([0,0,(bulletHeight) * 0.1])
			cylinder(d1 = bulletDiameter * 0.9, d2 = bulletDiameter * 0.8, h = bulletHeight * 0.9);
	}
	else if(bulletType == "pistolhollowpoint")
	{
		hollowPointOgive = 2;
		hollowPointDepth = 3;
		difference()
		{
			union()
				{
				translate([0,0, hollowPointOgive])
					makeRoundnose(1.5);
				cylinder(d = bulletDiameter, h = hollowPointOgive);
				}
			// hollowpoint cutout
			translate([0,0, bulletHeight-hollowPointDepth])
				cylinder(d1 = bulletDiameter * 0.1, d2 = bulletDiameter * 0.6, h = hollowPointDepth + 0.1);
			// flatten bullet tip
			translate([0,0, bulletHeight]) 
				cylinder(d = bulletDiameter, h = bulletHeight);
		}
	}
	
	// Add bottom length of bullet (going inside cartridge)
	// When making bullet only, this will make a proper length bullet to be seated into an empty casing
	// Make boattail or just cylinder
	
	if(boatTail)
	{
		boatTailLength = bulletDiameter * (1 - tan(10));
		rotate([180,0,0])
		{
			cylinder(d = bulletDiameter, h = bulletDiameter * tan(10));
			translate([0,0,bulletDiameter * tan(10)])
				cylinder(d1 = bulletDiameter, d2 = bulletDiameter * 0.8, h = boatTailLength);
			
		}
	}
	else
	{
		rotate([180,0,0])
			cylinder(d = bulletDiameter, h = bulletDiameter);
	}
	
	// Creates basic bullet shape, cylinder and roundnose
	module makeRoundnose(bulletOgiveScale)
	{
		// Sanity check for bullet overall length
		//%cylinder(d = bulletDiameter, h = bulletHeight);
		
		cylinder(d = bulletDiameter, h = bulletHeight - bulletDiameter * bulletOgiveScale/2);
		translate([0,0, bulletHeight - bulletDiameter * bulletOgiveScale/2])
		{
				// Round nose of bullet
				difference()
				{	
					scale([1,1,bulletOgiveScale])
						sphere(d = bulletDiameter);	
					// remove bottom of sphere
					rotate([0,180, 0]) 
						cylinder(d = bulletDiameter*1.01, h = bulletOgiveScale * bulletDiameter);
				}
		}		
	}
	
}