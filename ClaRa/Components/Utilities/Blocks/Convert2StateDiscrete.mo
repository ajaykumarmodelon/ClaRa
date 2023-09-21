within ClaRa.Components.Utilities.Blocks;
model Convert2StateDiscrete "Converts a flaoting value to a discrete one. Value is changed when a certain threshold is violated"
  //__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2022, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//
    extends Modelica.Blocks.Interfaces.SISO;
  parameter Real threshold = 0.1 "Threshold of identification of changes";
  parameter Boolean smoothValue = true "True, if output value should be smoothed using a firstOrder";
  parameter ClaRa.Basics.Units.Time Tau=0.1 "Time constant for smoothing" annotation (Dialog(enable=smoothValue));
  discrete Real y_;
  discrete Real py_;
equation

  when abs(pre(y_)-u)>threshold then
    y_=u;
    py_=pre(y_);
  end when;

  if smoothValue then
    der(y) = (y_-y)/Tau;
  else
    y=y_;
  end if;
initial equation
  y_=u;
  if smoothValue then
    y=u;
  end if;


equation
  connect(y, y) annotation (Line(
      points={{110,0},{106,0},{106,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2022.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
 Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
                             Line(
          points={{-100,0},{-50,60},{30,-60},{100,20}},
          color={221,222,223},
          smooth=Smooth.Bezier), Line(
          points={{-100,0},{-80,0},{-80,22},{-12,22},{-12,0},{10,0},{10,-26},{
              82,-26},{82,0},{100,0}},
          color={27,36,42},
          smooth=Smooth.None)}));
end Convert2StateDiscrete;