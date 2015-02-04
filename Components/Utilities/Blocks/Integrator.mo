within ClaRa.Components.Utilities.Blocks;
block Integrator "Output the integral of the input signal - variable Integrator time constant"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                            //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright � 2013-2015, DYNCAP research team.                              //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  import Modelica.Blocks.Types.Init;
  import SI = ClaRa.Basics.Units;
  extends Modelica.Blocks.Interfaces.SISO(y(start=y_start_const));

  parameter Boolean variable_Tau_i=false "True, if integrator time is set by variable input";
  parameter Boolean y_startInputIsActive=false "True, if integrator initial output shall be set by variable input";

  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState "Type of initialization (1: no init, 2: steady state, 3,4: initial output)"
                                                                                    annotation(Evaluate=true,
      Dialog(group="Initialization"));

  parameter SI.Time Tau_i_const=1 "Constant integrator time"
     annotation (Dialog(group="Initialization",enable= not variable_Tau_i));

  parameter Real y_start_const=0 "Initial or guess value of output (= state)"
     annotation (Dialog(group="Initialization",enable= not y_startInputIsActive));

protected
  SI.Time Tau_i_in;
  Real y_start_in;
public
  Modelica.Blocks.Interfaces.RealInput Tau_i(value=Tau_i_in) if (variable_Tau_i) annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-50,120})));

  Modelica.Blocks.Interfaces.RealInput y_start(value=y_start_in) if
                                                           (y_startInputIsActive) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
initial equation
//   if initType == Init.SteadyState then
//      der(y) = 0;
//   elseif initType == Init.InitialState or
//          initType == Init.InitialOutput then
//     y = y_start_in;
//   end if;

  if initType == Init.SteadyState or initType == Init.InitialState or
         initType == Init.InitialOutput then
    y = y_start_in;
  end if;

equation
  if not variable_Tau_i then
    Tau_i_in=Tau_i_const;
  end if;
  if not y_startInputIsActive then
    y_start_in=y_start_const;
  end if;

  der(y) = u/Tau_i_in;
  annotation (
    Documentation(info="<html>
<p>
This blocks computes output <b>y</b> (element-wise) as
<i>integral</i> of the input <b>u</b> multiplied with
the gain <i>k</i>:
</p>
<pre>
         k
     y = - u
         s
</pre>

<p>
It might be difficult to initialize the integrator in steady state.
This is discussed in the description of package
<a href=\"modelica://Modelica.Blocks.Continuous#info\">Continuous</a>.
</p>

</html>
"), Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{0,-10},{60,-70}},
          lineColor={192,192,192},
          textString="I"),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="Ti=%Ti_in"),
        Line(points={{-80,-80},{80,80}}, color={0,0,127})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{-36,60},{32,2}},
          lineColor={0,0,0},
          textString="k"),
        Text(
          extent={{-32,0},{36,-58}},
          lineColor={0,0,0},
          textString="s"),
        Line(points={{-46,0},{46,0}}, color={0,0,0})}));
end Integrator;
