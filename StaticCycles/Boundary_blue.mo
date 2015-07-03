within ClaRa.StaticCycles;
model Boundary_blue "Blue boundary"
  // Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.

  parameter Boolean source = true;
  parameter ClaRa.Basics.Units.MassFlowRate  m_flow(fixed = source) annotation(Dialog(enable = source));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h(fixed = source) annotation(Dialog(enable = source));
  parameter ClaRa.Basics.Units.Pressure p(fixed = not source) annotation(Dialog(enable = not source));

  Fundamentals.SteamSignal_blue inlet(p=p)  annotation (Placement(transformation(extent={{-104,-10},{-96,10}})));
  Fundamentals.SteamSignal_blue outlet(h=h, m_flow=m_flow) annotation (Placement(transformation(extent={{96,-10},{104,10}})));
initial equation
  if source then
    p=outlet.p;
  else
    m_flow= inlet.m_flow;
    h=inlet.h;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-60,0},{-96,0}},
          color={0,131,169},
          smooth=Smooth.None, visible= not source),
          Line(
          points={{60,0},{96,0}},
          color={0,131,169},
          smooth=Smooth.None, visible= source),
        Polygon(
          points={{-60,60},{60,60},{60,-60},{-60,-60},{-60,60}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,60},{60,20}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%p",
          visible=not source),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow",
          visible=source),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%h",
          visible= source)}),               Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end Boundary_blue;