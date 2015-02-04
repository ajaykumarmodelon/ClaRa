within ClaRa.Components.Furnace.Check;
model Test_CombustionChamber_vs_Burner_control
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright � 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  import ClaRa;
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  SimpleCombustionChamber combustionChamber(
    calculate_LHV=false,
    xi_slag=0,
    xi_NOx=0,
    flueGas_outlet(xi_outflow(start={0.01,0,0.1,0,0.74,0.13,0,0.02,0})))
              annotation (Placement(transformation(extent={{12,-98},{32,-78}})));
  inner ClaRa.SimCenter simCenter(redeclare ClaRa.Basics.Media.Fuel.Coal_v2
      fuelModel1)
    annotation (Placement(transformation(extent={{-140,-320},{-120,-300}})));
  ClaRa.Components.BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource(
    m_flow_const=1,
    variable_m_flow=true,
    coalType=simCenter.fuelModel1,
    xi_const=simCenter.fuelModel1.defaultComposition) annotation (Placement(transformation(extent={{-64,-92},{-44,-72}})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT coalSink annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={26,-130})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource(
    m_flow_const=2.2*6.7362,
    variable_m_flow=true,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})
                          annotation (Placement(transformation(extent={{-64,-98},{-44,-118}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink(p_const=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={22,-56})));
  Modelica.Blocks.Sources.Ramp setPoint_Q_boiler(
    duration=60,
    startTime=60,
    height=-70e6,
    offset=-30e6)
    annotation (Placement(transformation(extent={{-2,-36},{-22,-56}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_lambda(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Tau_i=1,
    k=1,
    y_max=1000,
    t_activation=20000,
    Tau_lag_I=5,
    y_inactive=15,
    y_ref=100,
    y_min=0,
    initType=Modelica.Blocks.Types.InitPID.NoInit)
    annotation (Placement(transformation(extent={{-46,-134},{-66,-154}})));
  Modelica.Blocks.Sources.RealExpression setPoint_lambda(y=1.10) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-14,-144})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_Q_boiler(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0.1,
    k=1,
    y_max=10,
    t_activation=30000,
    Tau_lag_I=5,
    y_inactive=1,
    sign=-1,
    y_ref=1/30e6,
    Tau_i=1) annotation (Placement(transformation(extent={{-44,-36},{-64,-56}})));
  ClaRa.Components.Adapters.CoalGas_join             coalGas_join
    annotation (Placement(transformation(extent={{-28,-98},{-8,-78}})));
  ClaRa.Components.Furnace.Burner.Burner_L2_Static
                                            burner(
    redeclare model Burning_time =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (
         Tau_burn_const =      2),
    redeclare model ParticleMigration =
        ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (
         w_fixed=1),
    redeclare model HeatTransfer_Wall =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_L2,
    redeclare model HeatTransfer_Top =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_L2,
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        width=
          10,
        length=
          10,
        height=
          100,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical),
    xi_start_flueGas_out={0.01,0,0.1,0,0.74,0.13,0,0.02,0})
    annotation (Placement(transformation(extent={{14,-252},{74,-232}})));

  ClaRa.Components.BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource1(
    m_flow_const=1,
    variable_m_flow=true,
    coalType=simCenter.fuelModel1,
    xi_const=simCenter.fuelModel1.defaultComposition) annotation (Placement(transformation(extent={{-64,-246},{-44,-226}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource1(
    m_flow_const=2.2*6.7362,
    variable_m_flow=true,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})
                          annotation (Placement(transformation(extent={{-64,-242},{-44,-262}})));
  ClaRa.Components.Adapters.CoalGas_join             coalGas_join1
    annotation (Placement(transformation(extent={{-26,-252},{-6,-232}})));
  ClaRa.Components.Adapters.CoalSlagFlueGas_join
    coalSlagFlueGas_join
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,-272})));
  ClaRa.Components.BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource2(
    xi_const={0.86,0.035,0.025,0.014,0.007,0.0505},
    variable_m_flow=false,
    m_flow_const=0,
    T_const=simCenter.T_amb) annotation (Placement(transformation(extent={{-66,-302},{-46,-282}})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT slagSink(T_const=373.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,-300})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource2(
    variable_m_flow=false,
    m_flow_const=0,
    T_const=773.15,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})
                    annotation (Placement(transformation(extent={{-66,-298},{-46,-318}})));
  ClaRa.Components.Adapters.CoalSlagFlueGas_split
    coalSlagFlueGas_split
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,-206})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_Tm_flow slagFlowSource(m_flow_const=0, T_const=873.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={84,-178})));
  ClaRa.Components.BoundaryConditions.BoundaryCoal_pTxi coalSink1(xi_const={0.81,0.035,0.025,0.014,0.007,0.0005}, T_const=373.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={108,-166})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink1(p_const=100000, T_const=373.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={64,-190})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=423.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={98,-242})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T=423.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={98,-210})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_Q_boiler1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Tau_lag_I=5,
    y_inactive=1,
    k=1,
    y_min=0.1,
    y_ref=1/30e6,
    sign=-1,
    Tau_i=2,
    y_max=10,
    t_activation=32000)
    annotation (Placement(transformation(extent={{-46,-188},{-66,-208}})));
  Modelica.Blocks.Sources.Ramp setPoint_Q_boiler1(
    duration=60,
    startTime=60,
    height=-50e6,
    offset=-20e6)
    annotation (Placement(transformation(extent={{-12,-188},{-32,-208}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=burner.Q_flow_wall +
        burner.Q_flow_top)
    annotation (Placement(transformation(extent={{-92,-190},{-72,-170}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=100)
             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,-274})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature3(T=423.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={98,-274})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_lambda1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Tau_i=1,
    k=1,
    y_max=1000,
    Tau_lag_I=5,
    y_inactive=15,
    y_min=0.1,
    y_ref=100,
    t_activation=31000)
    annotation (Placement(transformation(extent={{-122,-248},{-102,-268}})));
  Modelica.Blocks.Sources.RealExpression setPoint_lambda1(
                                                         y=1.10) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-94,-202})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=burner.lambdaComb_primary) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-94,-218})));
equation
  connect(combustionChamber.lambda, PID_lambda.u_m) annotation (Line(
      points={{11,-96},{-2,-96},{-2,-126},{-56,-126},{-56,-132}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setPoint_lambda.y, PID_lambda.u_s) annotation (Line(
      points={{-25,-144},{-44,-144}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_lambda.y, flueGasFlowSource.m_flow) annotation (Line(
      points={{-66.9,-144},{-72,-144},{-72,-114},{-64,-114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setPoint_Q_boiler.y, PID_Q_boiler.u_s) annotation (Line(
      points={{-23,-46},{-42,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combustionChamber.Q_flow_boiler, PID_Q_boiler.u_m) annotation (Line(
      points={{33,-88},{56,-88},{56,-18},{-54,-18},{-54,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_Q_boiler.y, coalFlowSource.m_flow) annotation (Line(
      points={{-64.9,-46},{-80,-46},{-80,-76},{-64,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setPoint_Q_boiler1.y, PID_Q_boiler1.u_s) annotation (Line(
      points={{-33,-198},{-44,-198}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_Q_boiler1.y, coalFlowSource1.m_flow) annotation (Line(
      points={{-66.9,-198},{-76,-198},{-76,-230},{-64,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, PID_Q_boiler1.u_m) annotation (Line(
      points={{-71,-180},{-56,-180},{-56,-186}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermalConductor.port_a, fixedTemperature3.port) annotation (Line(
      points={{76,-274},{80,-274},{80,-272},{82,-272},{82,-274},{88,-274}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(setPoint_lambda1.y, PID_lambda1.u_s) annotation (Line(
      points={{-105,-202},{-128,-202},{-128,-258},{-124,-258}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_lambda1.y, flueGasFlowSource1.m_flow) annotation (Line(
      points={{-101.1,-258},{-64,-258}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression1.y, PID_lambda1.u_m) annotation (Line(
      points={{-105,-218},{-112,-218},{-112,-246}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combustionChamber.slag_outlet, coalSink.slag_inlet) annotation (Line(
      points={{22,-97.8},{24,-97.8},{24,-120},{26.2,-120}},
      color={234,171,0},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join.coalDust_outlet, combustionChamber.inlet) annotation (
      Line(
      points={{-8,-88},{12,-88}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource.coal_a, coalGas_join.coal_inlet) annotation (Line(
      points={{-44,-82},{-28,-82}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource.gas_a, coalGas_join.flueGas_inlet) annotation (Line(
      points={{-44,-108},{-38,-108},{-38,-94},{-28,-94}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink.gas_a, combustionChamber.flueGas_outlet)
    annotation (Line(
      points={{22,-66},{22,-78}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSink1.coal_a, coalSlagFlueGas_split.coal_inlet) annotation (Line(
      points={{98,-166},{22,-166},{22,-196}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split.slag_outlet, slagFlowSource.slag_outlet)
    annotation (Line(
      points={{28,-196},{28,-178},{74,-178}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink1.gas_a, coalSlagFlueGas_split.flueGas_inlet)
    annotation (Line(
      points={{54,-190},{34,-190},{34,-196}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource1.coal_a, coalGas_join1.coal_inlet) annotation (Line(
      points={{-44,-236},{-26,-236}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource1.gas_a, coalGas_join1.flueGas_inlet) annotation (
      Line(
      points={{-44,-252},{-36,-252},{-36,-248},{-26,-248}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join1.coalDust_outlet, burner.coalDust_inlet) annotation (
      Line(
      points={{-6,-242},{14,-242}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split.coalSlagFlueGas_outlet, burner.outlet)
    annotation (Line(
      points={{28,-216},{28,-232}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.inlet, coalSlagFlueGas_join.coalSlagFlueGas_outlet)
    annotation (Line(
      points={{28,-252},{28,-262}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.heat_top, fixedTemperature2.port) annotation (Line(
      points={{46,-232},{46,-210},{88,-210}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.heat_wall, fixedTemperature1.port) annotation (Line(
      points={{74,-242},{88,-242}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.heat_bottom, thermalConductor.port_b) annotation (Line(
      points={{46,-252},{46,-274},{56,-274}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource2.coal_a, coalSlagFlueGas_join.coal_inlet) annotation (
      Line(
      points={{-46,-292},{22,-292},{22,-282}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.slag_outlet, slagSink.slag_inlet) annotation (
      Line(
      points={{28,-282},{28,-300},{-46,-300},{-46,-300.2}},
      color={234,171,0},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource2.gas_a, coalSlagFlueGas_join.flueGas_inlet)
    annotation (Line(
      points={{-46,-308},{34,-308},{34,-282}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-320},{120,40}}),
                      graphics={
                       Text(
          extent={{-140,40},{82,20}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2015-01-27 //LN"),
                                  Text(
          extent={{-136,18},{104,-10}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________
PURPOSE:
>> Comparison between different combustion chamber models
______________________________________________________________________________
")}),
    experiment(StopTime=180),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})));
end Test_CombustionChamber_vs_Burner_control;
