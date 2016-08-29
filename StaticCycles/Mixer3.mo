within ClaRa.StaticCycles;
model Mixer3 "Mixer || blue | red | red"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.1                            //
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
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
  // Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
  // Red output:   Values of p and m_flow are unknown and provided BY neighbor component, value of h is known and provided FOR neighbor component.
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false)
    "|Internals|Internally set values - do not edit!|Specific enthalpy of flow 1";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h2(fixed=false)
    "|Internals|Internally set values - do not edit!|Specific enthalpy of flow 2";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false)
    "|Internals|Internally set values - do not edit!|Mass flow rate of flow 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_2=(m_flow_3-m_flow_1)
    "|Internals|Internally set values - do not edit!|Mass flow rate of flow 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h3=(h1*m_flow_1 + h2*
      m_flow_2)/m_flow_3
    "|Internals|Internally set values - do not edit!|Mixer outlet enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_3(fixed=false)
    "|Internals|Internally set values - do not edit!|Mixer outlet mass flow rate";
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false)
    "|Internals|Internally set values - do not edit!|Mixer pressure";

  Fundamentals.SteamSignal_blue inlet_1(p=p) annotation (Placement(transformation(extent={{-50,10},{-40,30}}), iconTransformation(extent={{-50,10},{-40,30}})));
  Fundamentals.SteamSignal_red inlet_2(p=p, m_flow=m_flow_2) annotation (
      Placement(transformation(
        extent={{-10,-30},{10,-20}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,-30},{10,-20}},
        rotation=0,
        origin={0,0})));
  Fundamentals.SteamSignal_red outlet(h=h3)
    annotation (Placement(transformation(extent={{40,10},{50,30}}), iconTransformation(extent={{40,10},{50,30}})));
initial equation
  inlet_1.h=h1;
  inlet_1.m_flow=m_flow_1;
  inlet_2.h=h2;
  outlet.p=p;
  outlet.m_flow=m_flow_3;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-30},{50,30}}),
                         graphics={Polygon(
          points={{-50,30},{50,30},{50,10},{10,10},{10,-30},{-10,-30},{-10,10},{-50,10},{-50,30}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=true,  extent={{-60,-25},{60,25}}),     graphics));
end Mixer3;
