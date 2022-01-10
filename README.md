# Void Switch OpenSCAD Files
Parametric 3D printable magnetic separation contactless key switch and stabilizers (OpenSCAD files).  For the Kicad files see the [void_switch_kicad](https://github.com/riskable/void_switch_kicad) repo.

![OpenSCAD Customizer](/assets/images/assembled_switch.gif)

For a detailed overview of how Void Switches work see Chyrosran22's Teardown video:

[![Void Switch Teardown Video](/assets/images/chyrosran22_teardown.jpg)](https://youtu.be/H_Ym9528awM)

## BOM
Each switch needs three 4x2mm magnets (Note: Most cheap N35 magnets are actually 4x1.7mm *which is fine*) and the stabilizers require two 4x2mm magnets and some 18 gauge stainless steel wire (make sure it's magnetic; use the cheap stuff).  *Both of these are configurable*, however.  So if you want to make a switch that uses 3x2mm magnets you can do that (with a bit of work changing settings around).

For reference, there's two magnets in the switch itself (one in the sheath and one in the stem) and the levitator needs its own magnet.

## Prerendered files
Prerendered (4mm travel) void switch files are provided in .stl and .3mf format for 4x1.7mm (most common) and 4x2mm magnets with a `MAGNET_VOID` of 0.6mm.  This should make for an all-around decent set of parameters for doing quick tests and demos (to see how the switch feels).  For your own keyboard make sure you try out many different `MAGNET_VOID` values and also try changing the `STEM_TOLERANCE` value to see how you like tighter-fitting or looser-fitting switches.

## Parameters

![OpenSCAD Customizer](/assets/images/tunable_switch_parameters.jpg)

Descriptions of what each parameter does are included in the .scad file and are easily referenced in the OpenSCAD customizer:

![OpenSCAD Customizer](/assets/images/openscad_customizer.png)

## Figuring out your switch force/strength
I've added several tables of switch strengths to the `utils.scad` and *pretty good* estimation of how strong your switch will be will show up in the OpenSCAD console.  Here's what it should look like (text enlarged and highlighted for effect):

![OpenSCAD Console Output](/assets/images/void_switch_console_strength.png)

## Print settings
Print the switches and stabilizers at 0.16mm layer height.  This will ensure that the topmost layer of the interior of the sheath ends up with a "close enough" tolerance to your `STEM_TOLERANCE` setting.

The levitator can be printed at just about any layer height but 0.2mm is recommended.

**Note:** It is recommended that the switches be printed in PETG because it has the lowest coefficient of friction of all 3D printable filaments (0.22).  However, PLA also works just fine.  If you use the liquid/oil type of Super Lube w/Syncolon (PTFE) just about *any* filament will work great regardless.  Also note that *you can always just sand the stem* to your perfect level of polished smoothness (don't be lazy).

For reference, even terrible printers seem to do a fine job printined Void Switches.  Because of how the tactility works any bumps or scratchiness in the stems won't be easily felt.  Also, if you print in PETG it has self-lubricating properties when rubbing against itself (it sheds hydrogen atoms which causes a sort of thin molecular collapse at the surface, removing rough/uneven bits).

## Switch assembly
1. Place a magnet in the sheath (using groove jointed pliers makes this super quick and easy).
2. Snap the sheath into the body, pressing the magnet side in first (goes easier that way).
3. Place a magnet in the stem/slider, making sure it's in the correct orientation so as to be attracted to the magnet in the sheath.
4. Slide the stem/slider into the sheath from the underside of the switch.
5. Place a magnet in the levitator, ensuring that *it repels* the magnet in the sheath/body.
6. Place the levitator on the switch stem and then it's ready for a keycap.

**Note:** If you screw up the orientation of the magnets there's little holes so you can pop them out (and reverse them).

**Tip:** Once the sheath is snapped into the body I find it's best to give it a gentle squeeze with some pliers:

![Using pliers on sheath and body together](/assets/images/switch_assembly2.jpg)

**Tip:** If you find your magnets aren't staying put (and you don't want to fix the tolerances/print new ones) *you can always just use some glue*.  I find that CA glue (superglue) works great for this.  Just make sure to use the accelerator stuff or it might not stick as well.

## Video tutorials/gifs on how to aseemble Void Switches and stabilizers are coming soon!

I'll also be taking a series of photos and detailing the process here.

## What a keyboard using Void Switches looks like
Here's the keyboard I've been typing on every day for several months:

![OpenSCAD Customizer](/assets/images/riskeyboard_70_top_removal.gif)

This is my Riskeyboard 70.  Since Void Switches are entirely contactless I made the case so that the entire top plate could be easily removed (it's magnetically attached with the same 4x2mm magnets used in the switches/stabs).  It makes it *super* easy to clean: Just take the top plate to your kitchen sink and give it a good scrub with soap and water!

## What keycaps to use with Void Switches

Void Switches (currently) use Cherry MX-compatible cross (+) stems so you can use any Cherry-MX compatible keycaps.  Having said that, it is highly recommended that you 3D print your own keycaps for Void Switches!  Try making your own with my [Keycap Playground](https://github.com/riskable/keycap_playground).  3D printed keycaps are superior to injection moulded keycaps in many ways:

 * PETG keycaps _feel_ fantastic!  They also have a very deep sound profile.  PETG is also a fantastic light pipe (that's what it was invented for!) which means multi-material prints with clear legends have the best clarity/brightness.  If you "just use white" PETG you can get very crisp, clear legends and the keycap will light up the same color as your LEDs.
 * PLA keycaps can be made using all sorts of interesting and amazing filaments (_they can have sparkles!_).  They have a sound profile similar to PBT keycaps (high pitch).
 * TPU keycaps are very easy on your fingers and very quiet.  Any 92A or harder TPU can be used for keycaps without any special modifications (yes, the stems will still work fine and won't be "floppy" or whatever).

**NOTE:** Void Switches currently only support the Cherry MX-style cross (+) but support for other stem types can be added (places in the code were carved out for this).  If someone wants to add support for other types feel free to submit a PR.  It might be a better idea to make a stem/slider that simlply accepts a "topper" that lets you attach/support an adapter that lets you put whatever stem type you want on there.
