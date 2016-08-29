within ClaRa.Components.TurboMachines.Pumps.Check;
model TestPump_L1_WithEMotor "A speed controlled pump driven by an e-motor"

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  parameter String tableDeltap_mflow[5] = {"TableBase/Deltap_mflow_3100.mif",
                              "TableBase/Deltap_mflow_3600.mif",
                              "TableBase/Deltap_mflow_4100.mif",
                              "TableBase/Deltap_mflow_4600.mif",
                              "TableBase/Deltap_mflow_5100.mif"};
  parameter String   tableeta_mflow[5] = {"TableBase/Eta_mflow_3100.mif",
                              "TableBase/Eta_mflow_3600.mif",
                              "TableBase/Eta_mflow_4100.mif",
                              "TableBase/Eta_mflow_4600.mif",
                              "TableBase/Eta_mflow_5100.mif"};
  parameter String   tableP_mflow[5] = {"TableBase/Power_mflow_3100.mif",
                              "TableBase/Power_mflow_3600.mif",
                              "TableBase/Power_mflow_4100.mif",
                              "TableBase/Power_mflow_4600.mif",
                              "TableBase/Power_mflow_5100.mif"};
  inner ClaRa.SimCenter simCenter(redeclare
      TILMedia.VLEFluidTypes.TILMedia_SplineWater                                       fluid1) annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_affinity pump(
    useMechanicalPort=true,
    showExpertSummary=true,
    exp_hyd=0.40,
    exp_rpm=-0.01,
    exp_flow=2.45,
    V_flow_opt_=0.5,
    J=10,
    steadyStateTorque=false,
    rpm_stirrS=2500,
    rpm_stirrE=2000,
    Delta_p_eps=100,
    rpm_nom=5000,
    V_flow_max=1,
    Delta_p_max=380e5,
    drp_exp=-0.04/(5000 - 3000),
    eta_hyd_nom=0.85)
                     annotation (Placement(transformation(extent={{-24,-80},{-4,-60}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi inletBoundary(p_const=30e5, h_const=808.322e3) annotation (Placement(transformation(extent={{-62,-80},{-42,-60}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi outletBoundary(
    variable_p=true,
    p_const=1000000,
    h_const=108.323e3) annotation (Placement(transformation(extent={{68,-80},{48,-60}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor
    annotation (Placement(transformation(extent={{-6,-60},{14,-40}})));
  Modelica.Blocks.Math.Gain              realExpression(k=2*Modelica.Constants.pi
        /60)
    annotation (Placement(transformation(extent={{46,36},{38,44}})));
  Modelica.Blocks.Sources.TimeTable
                               ramp(                                    offset=
        inletBoundary.p_const, table=[0,0; 100,38671020; 101,0; 200,38671020; 201,0; 300,38671020; 301,0; 400,38671020; 401,0; 500,38671020])
    annotation (Placement(transformation(extent={{98,-74},{78,-54}})));
  Modelica.Blocks.Sources.TimeTable
                               ramp1(table=[0,5000; 100,5000; 101,4500; 200,4500; 201,4000; 303,4000; 310,3500; 400,3500; 401,3000; 500,3000])
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={76,40})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=1, initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(extent={{60,36},{52,44}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID(
    u_ref=500,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    sign=1,
    y_ref=38e3,
    k=10,
    Tau_i=0.5,
    Tau_d=500,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=100,
    y_max=10e3,
    y_start=4e3) annotation (Placement(transformation(extent={{26,30},{6,50}})));
  Modelica.Blocks.Sources.Constant const(k=50) annotation (Placement(transformation(extent={{-72,30},{-52,50}})));
  ClaRa.Components.Electrical.AsynchronousMotor_L2 motor(
    P_nom=15e6,
    N_pp=1,
    rpm_nom=2950,
    cosphi=0.9,
    eta_stator=0.95,
    I_rotor_nom=2,
    tau_bd_nom=50e3,
    showExpertSummary=true,
    activateHeatPort=false,
    initOption="fixed slip",
    U_term_nom=3e3,
    J=800)                              annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-14,10})));
  Modelica.Mechanics.Rotational.Components.IdealGear idealGear(useSupport=false, ratio=3000/5000)
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-14,-30})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{2,-81},{36,-71}})));
equation
  connect(pump.outlet, outletBoundary.steam_a)             annotation (Line(
      points={{-4,-70},{48,-70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inletBoundary.steam_a, pump.inlet)              annotation (Line(
      points={{-42,-70},{-24,-70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(firstOrder.y, realExpression.u) annotation (Line(
      points={{51.6,40},{46.8,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, outletBoundary.p) annotation (Line(
      points={{77,-64},{68,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, firstOrder.u) annotation (Line(
      points={{65,40},{60.8,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, PID.u_s) annotation (Line(
      points={{37.6,40},{28,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speedSensor.w, PID.u_m) annotation (Line(
      points={{15,-50},{15.9,-50},{15.9,28}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(speedSensor.flange, pump.shaft) annotation (Line(
      points={{-6,-50},{-14,-50},{-14,-60.1}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(idealGear.flange_b, pump.shaft) annotation (Line(
      points={{-14,-40},{-14,-60.1}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(quadruple.eye, pump.eye) annotation (Line(
      points={{2,-76},{-3,-76}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(PID.y, motor.U_term) annotation (Line(
      points={{5,40},{-14,40},{-14,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, motor.f_term) annotation (Line(
      points={{-51,40},{-18,40},{-18,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealGear.flange_a, motor.shaft) annotation (Line(points={{-14,-20},{-14,0}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,100},{100,60}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tested 29.03.2016 //FG
_________________________
Illustrate the influence of a realistic e-motor to a given centrifugal pump
_________________________
LOOK AT:
pump.summary.outline.Delta_p = f(pump.summary.outline.V_flow)
Note that the volume flow at very small pressure differences is limited by the max. torque available from the driving machine. In this particular case this is an asynchronous motor. 
The motor's characteristic results in a speed reduction at low pressure differences which strongly depends on rotor's bar design (see documentation for details)
Taking the driving machine of a pump is of interest if effects like starting and stopping of the defice is under investigation.
_________________________
NOTE:
ClaRa's rotating machines like the pump and motor can be coupled to the Modelica Standard Library's components from the package Mechanics.Rotational")}),
    experiment(StopTime=500, Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end TestPump_L1_WithEMotor;
