within ClaRa.Components.VolumesValvesFittings.Pipes;
model PipeFlowGas_L4_Simple "A 1D tube-shaped control volume considering heat transfer in a straight pipe with static momentum balance and simple energy balance."
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.6.0                           //
//                                                                          //
// Licensed by the ClaRa development team under Modelica License 2.         //
// Copyright  2013-2021, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L4(
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv (
        N_tubes=N_tubes,
        N_cv=N_cv,
        diameter=diameter_i,
        length=length,
        Delta_x=Delta_x));

  extends ClaRa.Basics.Icons.Pipe_L4;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=noEvent(if sum(heat.Q_flow) > 0 then sum(heat.Q_flow) else 0),
    powerOut_th=if not heatFlowIsLoss then -sum(heat.Q_flow) else 0,
    powerOut_elMech=0,
    powerAux=0) if  contributeToCycleSummary;

//## P A R A M E T E R S #######################################################################################

//____Geometric data_____________________________________________________________________________________
  parameter Basics.Units.Length length=1 "|Geometry|Length of the pipe";
  parameter Basics.Units.Length diameter_i=0.1 "|Geometry|Inner diameter of the pipe";

  parameter Integer N_tubes= 1 "|Geometry|Number Of parallel pipes";

//____Discretisation_____________________________________________________________________________________
    parameter Integer N_cv(min=3)=3 "|Discretisation|Number of finite volumes";
public
  inner parameter Basics.Units.Length Delta_x[N_cv]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N_cv) "|Discretisation|Discretisation scheme";

//________Summary_________________
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if negative heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));

protected
  Basics.Interfaces.EyeInGas
                          eye_int[1](each medium=medium)
    annotation (Placement(transformation(extent={{85,-41},{87,-39}})));
public
  Basics.Interfaces.EyeOutGas
                           eye(each medium=medium) if showData
 annotation (Placement(transformation(extent={{130,-50},{150,-30}}),
        iconTransformation(extent={{136,-44},{156,-24}})));

//### E Q U A T I O N P A R T #######################################################################################
//-------------------------------------------
equation

  eye_int[1].m_flow=-outlet.m_flow;
  eye_int[1].T= fluidOutlet.T-273.15;
  eye_int[1].s=fluidOutlet.s/1e3;
  eye_int[1].p=outlet.p/1e5;
  eye_int[1].h=fluidOutlet.h/1e3;
  eye_int[1].xi=fluidOutlet.xi;
         //fillColor={0,131,169};//DynamicSelect(if time > 0 then (if not FlowModel==FlowModelStructure.inlet_innerPipe_outlet and not FlowModel==FlowModelStructure.inlet_innerPipe_dp_outlet then {0,131,169} else {255,255,255}) else {255,255,255}),
  connect(eye_int[1],eye)  annotation (Line(
      points={{86,-40},{140,-40}},
      color={255,204,51},
      smooth=Smooth.None,
      thickness=0.5));
  annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false,extent={{-140,-50},
            {140,50}}),        graphics={
        Polygon(
          points={{-132,34},{-114,34},{-114,-34},{-132,-34}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {118,106,98},
          fillPattern=FillPattern.Solid,
          visible=frictionAtInlet),
        Polygon(
          points={{132,34},{114,34},{114,-34},{132,-34}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {118,106,98},
          fillPattern=FillPattern.Solid,
          visible=frictionAtOutlet)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-50},{140,50}})),
    Documentation(info="<html>
</html>"));
end PipeFlowGas_L4_Simple;
