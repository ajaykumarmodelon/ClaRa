within ClaRa.Basics.ControlVolumes.Fundamentals.Geometry;
model PipeWithHotwell "Pipe bundle || Tube type || Hotwell"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.1.1                        //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright � 2013-2016, DYNCAP/DYNSTART research team.                     //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  //extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HotwellType;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry(
    final volume = pi/4*diameter^2*N_passes*N_tubes*length + height_hotwell*length_hotwell*width_hotwell,
    final N_heat = 1,
    final A_heat = {pi*diameter*N_tubes*length*N_passes},
    final A_cross = pi/4*diameter^2*N_tubes,
    final A_front = A_cross,
    final A_hor = width_hotwell*length_hotwell,
    final height_fill = height_hotwell,
    final shape = [0, 1; 1, 1]);

  parameter Units.Length diameter=1 "Diameter of the component" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Units.Length length=1 "Length of the component (one pass)" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Integer N_tubes=1 "Number of tubes in parallel" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"
                                                                       annotation(Dialog(group="Essential Geometry Definition", groupImage="modelica://ClaRa/figures/ParameterDialog/PipeWithHotwell.png"));

  parameter Units.Length height_hotwell=1
    "|Hotwell Geometry|Height of the hotwell";
  parameter Units.Length width_hotwell=1
    "|Hotwell Geometry|Width of the hotwell";
  parameter Units.Length length_hotwell=1
    "|Hotwell Geometry|Length of the hotwell";

equation
  assert(A_cross>0, "The cross section of the shell side must be > 0 but is "+String(A_cross, significantDigits=3) + " in instance" + getInstanceName() + ".");
  assert(volume>0, "The volume of the shell side must be > 0 but is "+String(volume, significantDigits=3) + " in instance" + getInstanceName() + ".");
  annotation (Icon(graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
            "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"
             +
            "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",
          fileName="modelica://ClaRa/figures/Components/PipeGeometryWithHotwell.png")}));
end PipeWithHotwell;
