within ClaRa.Basics.Interfaces;
connector CoalSlagFlueGas_outlet "Port describing Coal,Slag and FlueGas flow"

 parameter ClaRa.Basics.Media.Fuel.PartialFuel coalType;
 parameter ClaRa.Basics.Media.Fuel.PartialSlag slagType;
  ClaRa.Basics.Interfaces.GasPortOut flueGas
    annotation (Placement(transformation(extent={{40,-30},{100,30}})));
  ClaRa.Basics.Interfaces.Coal_outlet coal(coalType=coalType)
    annotation (Placement(transformation(extent={{-100,-30},{-40,30}})));
  Slag_inlet slag(slagType = slagType) annotation (Placement(transformation(extent={{-30,-30},{30,30}})));

  annotation (Icon(graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={118,106,98},
          lineThickness=0.5,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,80},{80,-80}},
          lineColor={118,106,98},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-45,45},{45,-45}},
          lineColor={27,36,42},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-35,35},{35,-35}},
          lineColor={255,255,255},
          fillColor={234,171,0},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                    graphics));
end CoalSlagFlueGas_outlet;
