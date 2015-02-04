within ClaRa.Basics.ControlVolumes.SolidVolumes;
model NTU_L3 "Base heat exchanger wall model with liquid, vapour and 2ph zones"
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

  import SI = ClaRa.Basics.Units;
  import ClaRa.Basics.Functions.Stepsmoother;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

//_____________material definitions_________________________________________//

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium_shell=simCenter.fluid1 "Medium of shell side"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium_tubes=simCenter.fluid1 "Medium of tubes side"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                                                               annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model HeatExchangerType =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow_L3
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger_L3 "Type of HeatExchanger"
                            annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  inner parameter Boolean outerPhaseChange=true "True, if phase change may occur at outer side"
                                                    annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

//______________geometry definitions________________________________________//
  parameter Integer N_t=1 "Number of tubes in one pass" annotation(Dialog(group="Geometry"));
  parameter Integer N_p=1 "Number of passes" annotation(Dialog(group="Geometry"));
  parameter SI.Length length "Tube length (for one pass)" annotation(Dialog(group="Geometry"));
  parameter SI.Length radius_i "Inner radius of tube" annotation(Dialog(group="Geometry"));
  parameter SI.Length radius_o "Outer radius of tube" annotation(Dialog(group="Geometry"));
  parameter Real mass_struc = 0 "Mass of inner structure elements, additional to the tubes itself"                   annotation(Dialog(group="Geometry"));
  discrete SI.Mass mass "Total mass of HEX";
  parameter Real CF_geo=1 "Correction coefficient due to fins etc." annotation(Dialog(group="Geometry"));

//Area of Heat Transfer
  final parameter SI.Area A_heat_m = (A_heat_o-A_heat_i)/log(A_heat_o/A_heat_i) "Mean area of heat transfer (single tube)";
  final parameter SI.Area A_heat_i= 2*Modelica.Constants.pi*radius_i*length*N_t*N_p "Area of heat transfer at inner phase";
  final parameter SI.Area A_heat_o= 2*Modelica.Constants.pi*radius_o*length*N_t*N_p "Area of heat transfer at oter phase";

//______________Initialisation______________________________________________//
  parameter SI.Temperature T_w_i_start[3]= ones(3)*293.15 "|Initialisation||Initial temperature at inner phase";
  parameter SI.Temperature T_w_o_start[3] = ones(3)*293.15 "|Initialisation||Initial temperature at outer phase";
  parameter ClaRa.Basics.Choices.Init initChoice=ClaRa.Basics.Choices.Init.noInit "|Initialisation||Init Option"                    annotation(Dialog(group="Initialisation"));

protected
  final parameter Boolean smallShellFlow_start[3] = {not outerPhaseChange,not outerPhaseChange,not outerPhaseChange};

//______________Expert Settings____________________________________________//
public
  replaceable function HeatCapacityAveraging =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.ArithmeticMean
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Functions.GeneralMean "|Expert Settings||Method for Averaging of heat capacities"
                                                                annotation(choicesAllMatching);
  parameter Real gain_eff= 1 "|Expert Settings||Avoid effectiveness > 1, high gain_eff leads to stricter observation but may cause numeric errors";
  parameter SI.Time Tau_stab=0.1 "|Expert Settings||Time constant for state stabilisation";
//______________Inputs_____________________________________________________//

public
  input SI.Pressure p_o "Pressure at outer side" annotation (Dialog(group="Input"));
  input SI.Pressure p_i "Pressure at inner side" annotation (Dialog(group="Input"));
  input SI.EnthalpyMassSpecific h_i_inlet "Inlet temperature of inner flow"
    annotation (Dialog(group="Input"));
  input SI.EnthalpyMassSpecific h_o_inlet "Inlet temperature of outer flow"
    annotation (Dialog(group="Input"));

  input SI.MassFlowRate m_flow_i "Mass flow rate of inner side"      annotation (Dialog(group="Input"));
  input SI.MassFlowRate m_flow_o "Mass flow rate of outer side" annotation (Dialog(group="Input"));

  input SI.CoefficientOfHeatTransfer alpha_i[3] "Coefficient of heatTransfer for inner side for regions |1|2|3|"
                                                                     annotation (Dialog(group="Input"));
  input SI.CoefficientOfHeatTransfer alpha_o[3] "Coefficient of heatTransfer for outer side for regions |1|2|3|"
                                                                     annotation (Dialog(group="Input"));

  inner input SI.AreaFraction yps_1ph "Area fraction of zone A"
                                                               annotation (Dialog(group="Input"));
  inner input SI.AreaFraction yps_2ph "Area fraction of zone B"
                                                               annotation (Dialog(group="Input"));

//______________Summaries and Visualisation________________________________//
  parameter Boolean showExpertSummary = false "|Summaries and Visualisation||True,if expert summaries shall be shown";
//______________Variables__________________________________________________//
//
  Real kA[3](unit="W/K") "The product U*S for regions |1|2|3|";
  SI.HeatFlowRate Q_flow[3] "Heat flow rate of zones |1|2|3|";
  HeatExchangerType HEXtype(NTU_1=NTU_1, R_1=R_1);
  Real cp_error_[3] "Check: Deviation from constant cp in zones |1|2|3|";
  Real effectiveness_act[3] "Actual effectiveness of zones |1|2|3|";
  Real effectiveness[3] "Effectiveness of zones |1|2|3|";
  Real NTU_1[3] "Number of transfer units in zones |1|2|3|";
  Real C_flow_low[3] "Lower heat capacity flow in zones |1|2|3|";
  Real C_flow_high[3] "Higher heat capacity flow in zones |1|2|3|";
  SI.HeatCapacityMassSpecific cp_o[3](start=ones(3)*3000);
  SI.HeatCapacityMassSpecific cp_i[3](start=ones(3)*3000);
//   Real k=(0.5*mass*solid[3].cp)/100;
protected
  SI.Temperature T_w_i[3](start=T_w_i_start) "Wall temperature at inner phase";
  SI.Temperature T_w_o[3](start=T_w_o_start) "Wall temperature at outer phase";
  Boolean smallShellFlow[3](start=smallShellFlow_start);
  SI.HeatFlowRate Q_flow_s[3] "Stabilised heat flow rate of zones |1|2|3|";

  Real R_1[3] "Aspect ratio of heat capacity flows in zones |1|2|3|";
  Real yps[3] "Area fractions";

public
record Summary
extends ClaRa.Basics.Icons.RecordIcon;
ECom eCom;
  parameter Boolean showExpertSummary;
  SI.HeatFlowRate Q_flow[3] "Heat flow rate of zones |1|2|3|";
  SI.HeatFlowRate Q_flow_tot "Total heat flow rate";
  Real C_flow_low[3] if  showExpertSummary "Lower heat capacity flow in zones |1|2|3|";
  Real C_flow_high[3] if  showExpertSummary "Higher heat capacity flow in zones |1|2|3|";
  Real C_flow_i[3] if  showExpertSummary "Inner side heat capacity flow in zones |1|2|3|";
  Real C_flow_o[3] if  showExpertSummary "Outer side heat capacity flow in zones |1|2|3|";

  SI.Temperature T_i[6] "Temperatures (i/o) of outer flow zones |1|2|3|";
  SI.Temperature T_o[6] "Temperatures (i/o) of outer flow zones |1|2|3|";

  SI.Temperature T_i_sat "Inner side saturation temperature";
  SI.Temperature T_o_sat "Outer side saturation temperature";

  Real yps[3] "Area fractions";
  Real effectiveness[3];
  Real cp_error_[3] if showExpertSummary "Check: Deviation from constant cp in zones |1|2|3|";
  Real kA[3](unit="W/K") "The product U*A for regions |1|2|3|";
end Summary;

record ECom
extends ClaRa.Basics.Icons.RecordIcon;
  Real z_i[6] "Zone positions at the inner side of the heat exchanger";
  Real z_o[6] "Zone positions at the outer side of the heat exchanger";
  SI.EnthalpyMassSpecific h_i[6] "Specific enthalpies (i/o) of inner flow zones |1|2|3|";
  SI.EnthalpyMassSpecific h_o[6] "Specific enthalpies (i/o) of outer flow zones |1|2|3|";
end ECom;
public
inner TILMedia.VLEFluid_ph O1_in(
     vleFluidType=medium_shell,
    h=(iCom.h_o_in[1]),
    p=p_o)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

inner TILMedia.VLEFluid_ph   O3_out(
     vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_out[3])
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

inner TILMedia.VLEFluid_ph   I1_out(
     vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_out[1])
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

inner TILMedia.VLEFluid_ph O2_in(
    vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_in[2])
    annotation (Placement(transformation(extent={{-32,10},{-12,30}})));

inner TILMedia.VLEFluid_ph I2_out(
     vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_out[2])
    annotation (Placement(transformation(extent={{-34,-30},{-14,-10}})));
inner TILMedia.VLEFluid_ph I3_in(
   vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_in[3])
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
inner TILMedia.VLEFluid_ph O2_out(
    vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_out[2])
    annotation (Placement(transformation(extent={{14,10},{34,30}})));
inner TILMedia.VLEFluid_ph I2_in(
     vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_in[2])
    annotation (Placement(transformation(extent={{14,-30},{34,-10}})));

   TILMedia.Solid solid[3](redeclare replaceable model SolidType = Material, T=(
        T_w_i + T_w_o)/2)
     annotation (Placement(transformation(extent={{40,54},{60,74}})));
public
  Summary summary(eCom( z_o = HEXtype.z_o,
    z_i = HEXtype.z_i,
    h_i={iCom.h_i_in[1], iCom.h_i_out[1],iCom.h_i_in[2], iCom.h_i_out[2],iCom.h_i_in[3], iCom.h_i_out[3]},
    h_o={iCom.h_o_in[1], iCom.h_o_out[1],iCom.h_o_in[2], iCom.h_o_out[2],iCom.h_o_in[3], iCom.h_o_out[3]}),
    showExpertSummary = showExpertSummary,
    Q_flow=Q_flow,
    T_i_sat=I3_in.VLE.T_v,
    T_o_sat=O1_in.VLE.T_v,
    C_flow_low=C_flow_low,
    C_flow_high=C_flow_high,
    C_flow_i=cp_i*m_flow_i.*HEXtype.ff_i,
    C_flow_o=cp_o*m_flow_o.*HEXtype.ff_o,
    T_i= iCom.T_in2out_i,
    T_o= iCom.T_in2out_o,
    yps=HEXtype.yps,
    Q_flow_tot = sum(Q_flow_s),
    effectiveness=effectiveness_act,
    cp_error_=cp_error_,
    kA=kA)
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
    ClaRa.Basics.Interfaces.HeatPort_a
                                     outerPhase[3] "outer side of cylinder"
                                           annotation (Placement(transformation(
          extent={{-10,100},{10,120}},rotation=0), iconTransformation(extent={{-10,
            100},{10,120}})));
    ClaRa.Basics.Interfaces.HeatPort_a
                                     innerPhase[3] "inner side of cylinder"
                                           annotation (Placement(transformation(extent={{-10,
            -110},{10,-90}},                                                                                 rotation=0),
        iconTransformation(extent={{-10,-110},{10,-90}})));
public
  inner ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.ICom_NTU_L3
                                    iCom(
    h_o_inlet=h_o_inlet,
    h_i_inlet=h_i_inlet,
    h_i_in=HEXtype.h_i_in,
    h_o_in=HEXtype.h_o_in,
    h_o_vap=O1_in.VLE.h_v,
    h_o_bub=O1_in.VLE.h_l,
    h_i_vap=I1_in.VLE.h_v,
    h_i_bub=I1_in.VLE.h_l,
    T_in2out_o=HEXtype.T_in2out_o,
    T_in2out_i=HEXtype.T_in2out_i,
    T_123_o={O1_in.T,O1_out.T,O2_in.T,O2_out.T,O3_in.T,O3_out.T},
    T_123_i={I1_in.T,I1_out.T,I2_in.T,I2_out.T,I3_in.T,I3_out.T})
    annotation (Placement(transformation(extent={{60,-102},{80,-82}})));

protected
inner TILMedia.VLEFluid_ph O1_out(
     vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_out[1])
    annotation (Placement(transformation(extent={{-54,10},{-34,30}})));
inner TILMedia.VLEFluid_ph O3_in(
    vleFluidType=medium_shell,
    p=p_o,
    h=iCom.h_o_in[3])
    annotation (Placement(transformation(extent={{34,10},{54,30}})));
inner TILMedia.VLEFluid_ph I1_in(
    vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_in[1])
    annotation (Placement(transformation(extent={{-54,-30},{-34,-10}})));
inner TILMedia.VLEFluid_ph I3_out(
   vleFluidType=medium_tubes,
    p=p_i,
    h=iCom.h_i_out[3])
annotation (Placement(transformation(extent={{36,-30},{56,-10}})));

equation
  cp_o[1] = homotopy(HeatCapacityAveraging(O1_in.cp, O1_out.cp), 3000);
  cp_o[2] = if not outerPhaseChange then homotopy(HeatCapacityAveraging(O2_in.cp,O2_out.cp), 3000) else Modelica.Constants.inf;
  cp_o[3] = homotopy( HeatCapacityAveraging(O3_in.cp,  O3_out.cp), 3000);

  cp_i[1] = homotopy(HeatCapacityAveraging(I1_in.cp,  I1_out.cp), 3000); //case2:2085.84;//case1:4189.93;//
  cp_i[2] = if outerPhaseChange then homotopy(HeatCapacityAveraging(I2_in.cp,  I2_out.cp), 3000) else Modelica.Constants.inf;
  cp_i[3] = homotopy(HeatCapacityAveraging(I3_in.cp,  I3_out.cp), 3000);

  der(yps) = (HEXtype.yps-yps)/Tau_stab;

when initial() then
  mass = mass_struc + solid[1].d*N_t*N_p*length*Modelica.Constants.pi*(radius_o^2-radius_i^2);
end when;

//Heat transfer coefficient
  kA = {HEXtype.yps[1], HEXtype.yps[2], HEXtype.yps[3]}.*{2*Modelica.Constants.pi*length*N_p*N_t/(1/(alpha_i[i]*radius_i) + log(radius_o/radius_i)/solid[i].lambda + 1/(CF_geo * alpha_o[i]*radius_o)) for i in 1:3};

//Wall temperatures:
    innerPhase.T = T_w_i;
    outerPhase.T = T_w_o;

// innerPhase.T=k*(innerPhase.T-T_w_i);
// outerPhase.T=k*(outerPhase.T-T_w_o);

//Energy Balance:
  der(T_w_i[1])=(innerPhase[1].Q_flow+Q_flow_s[1] - solid[1].cp*solid[1].T * mass/2*der(yps[1]))/(max(1e-3,yps[1])*mass/2*solid[1].cp);
  der(T_w_o[1])=(outerPhase[1].Q_flow-Q_flow_s[1] - solid[1].cp*solid[1].T * mass/2*der(yps[1]))/(max(1e-3,yps[1])*mass/2*solid[1].cp);
  der(T_w_i[2])=(innerPhase[2].Q_flow+Q_flow_s[2] - solid[2].cp*solid[2].T * mass/2*der(yps[2]))/(max(1e-3,yps[2])*mass/2*solid[2].cp);
  der(T_w_o[2])=(outerPhase[2].Q_flow-Q_flow_s[2] - solid[2].cp*solid[2].T * mass/2*der(yps[2]))/(max(1e-3,yps[2])*mass/2*solid[2].cp);
  der(T_w_i[3])=(innerPhase[3].Q_flow+Q_flow_s[3] - solid[3].cp*solid[3].T * mass/2*der(yps[3]))/(max(1e-3,yps[3])*mass/2*solid[3].cp);
  der(T_w_o[3])=(outerPhase[3].Q_flow-Q_flow_s[3] - solid[3].cp*solid[3].T * mass/2*der(yps[3]))/(max(1e-3,yps[3])*mass/2*solid[3].cp);

//_____________calculation of actual effectivenesses__________________________________//
    effectiveness_act[1] = noEvent(if O1_in.T-I1_in.T > 1e-6 then if smallShellFlow[1] then abs((O1_in.T - O1_out.T)/(O1_in.T-I1_in.T)) else abs((I1_in.T - I1_out.T)/(O1_in.T-I1_in.T)) else 0);
    effectiveness_act[2] = noEvent(if O2_in.T-I2_in.T > 1e-6 then if smallShellFlow[2] then abs((O2_in.T - O2_out.T)/(O2_in.T-I2_in.T)) else abs((I2_in.T - I2_out.T)/(O2_in.T-I2_in.T)) else 0);
    effectiveness_act[3] = noEvent(if O3_in.T-I3_in.T > 1e-6 then if smallShellFlow[3] then abs((O3_in.T - O3_out.T)/(O3_in.T-I3_in.T)) else abs((I3_in.T - I3_out.T)/(O3_in.T-I3_in.T)) else 0);

//  assert(cp_i_B < 1e10 and cp_o_B < 1e10, "PHASE CHANGE ON BOTH SIDES not supported");

//____________Heat capacity flows_____________________________________________________//

    C_flow_low = {noEvent(min(cp_o[i]*abs(m_flow_o*HEXtype.ff_o[i]+1e-6), cp_i[i]*abs(m_flow_i*HEXtype.ff_i[i]+1e-6))) for i in 1:3};
//____The following formulation can be seen as an alternative to the line above avoiding discontinuities arising from the min evaluation___________________________
//   C_flow_low = {Stepsmoother(-1e-3, +1e-3, cp_o[i]*abs(m_flow_o*HEXtype.ff_o[i]) - cp_i[i]*abs(m_flow_i*HEXtype.ff_i[i]))*cp_o[i]*abs(m_flow_o*HEXtype.ff_o[i])
//               + Stepsmoother(+1e-3, -1e-3, cp_o[i]*abs(m_flow_o*HEXtype.ff_o[i]) - cp_i[i]*abs(m_flow_i*HEXtype.ff_i[i]))*cp_i[i]*abs(m_flow_i*HEXtype.ff_i[i]) for i in 1:3};
//_________________________________________________________________________________________________________________________________________________________________

  C_flow_high[1] = noEvent(max(cp_o[1]*abs(m_flow_o*HEXtype.ff_o[1]+1e-6), cp_i[1]*abs(m_flow_i*HEXtype.ff_i[1]+1e-6)));
  C_flow_high[2] = noEvent(if cp_i[2] > 1e10 and cp_o[2] > 1e10 then  Modelica.Constants.inf else noEvent(max(cp_o[2]*abs(m_flow_o*HEXtype.ff_o[2]+1e-6), cp_i[2]*abs(m_flow_i*HEXtype.ff_i[2]+1e-6))));
  C_flow_high[3] = noEvent(max(cp_o[3]*abs(m_flow_o*HEXtype.ff_o[3]+1e-6), cp_i[3]*abs(m_flow_i*HEXtype.ff_i[3]+1e-6)));

  R_1 = C_flow_low./(C_flow_high + ones(3)*Modelica.Constants.eps);

   smallShellFlow[1] = if (cp_o[1]*abs(m_flow_o*HEXtype.ff_o[1]+1e-6) - cp_i[1]*abs(m_flow_i*HEXtype.ff_i[2]+1e-6))<1e-3 then true else false;
   smallShellFlow[2] = not outerPhaseChange; //if (cp_o_B*abs(m_flow_o) - cp_i_B*abs(m_flow_i))<1e-3 then true else false;
   smallShellFlow[3] = if (cp_o[1]*abs(m_flow_o*HEXtype.ff_o[3]+1e-6) - cp_i[1]*abs(m_flow_i*HEXtype.ff_i[3]+1e-36))<1e-3 then true else false;

//____________Number of Transer Units_______________________________________________//

  NTU_1 = kA./(C_flow_low + ones(3)*Modelica.Constants.eps).*HEXtype.CF_NTU;

//____________effectivenesses of the three zones_____________________________________//
  effectiveness[1] =  noEvent(if R_1[1] <1  then (1 - exp(-NTU_1[1] *(1-R_1[1])))/(1 - R_1[1]*exp(-NTU_1[1]*(1-R_1[1]))) else NTU_1[1]/(1+NTU_1[1]));//vapour zone
  effectiveness[2] =  (1 - exp(-NTU_1[2]));//2phase  zone
  effectiveness[3] =  noEvent(if R_1[3] < 1 then (1 - exp(-NTU_1[3] *(1-R_1[3])))/(1 - R_1[3]*exp(-NTU_1[3]*(1-R_1[3]))) else NTU_1[3]/(1+NTU_1[3])); //liquid zone

//____________Specific enthalpies in each zone _____________________________________//
  iCom.h_o_out   =  - Q_flow_s./(m_flow_o*HEXtype.ff_o+ones(3)*1e-6) + iCom.h_o_in;

  iCom.h_i_out   = Q_flow_s./(m_flow_i*HEXtype.ff_i+ones(3)*1e-6) + iCom.h_i_in;

//____________Heat flow rate from effectivenesses__________________________________//
  Q_flow  = {effectiveness[i] * C_flow_low[i] * (iCom.T_123_o[i*2-1] - iCom.T_123_i[i*2-1])  * noEvent(max(0,homotopy(1-gain_eff*max(0,min(1,effectiveness[i]-1)),1))) for i in 1:3};

  der(Q_flow_s) = (Q_flow - Q_flow_s)/Tau_stab;

//   cp_error_[1] = 1-(abs(Q_flow[1])-noEvent(if smallShellFlow[1] then abs(O1_in.T - O1_out.T) else abs(I2_out.T-I1_out.T)) *C_flow_low[1])/abs(Q_flow[1]+1e-3);
//   cp_error_[2] = 1-(abs(Q_flow[2])-noEvent(if smallShellFlow[2] then abs(O2_in.T - O2_out.T) else abs(I2_in.T-I2_out.T)) *C_flow_low[2])/abs(Q_flow[2]+1e-3);
//   cp_error_[3] = 1-(abs(Q_flow[3])-noEvent(if smallShellFlow[3] then abs(O2_out.T - O3_out.T) else abs(I3_in.T-I2_in.T)) *C_flow_low[3])/abs(Q_flow[3]+1e-3);
  cp_error_ = {(abs(Q_flow[i])-noEvent(if smallShellFlow[i] then abs(iCom.T_123_o[2*i-1] - iCom.T_123_o[2*i]) else abs(iCom.T_123_i[i*2-1]-iCom.T_123_i[2*i])) *C_flow_low[i])/abs(Q_flow[i]+1e-3) for i in 1:3};
initial equation
  yps=HEXtype.yps;

  if initChoice == ClaRa.Basics.Choices.Init.steadyState then
    der(Q_flow_s)=zeros(3);
    der(T_w_i)=zeros(3);
    der(T_w_o)=zeros(3);
  elseif initChoice == ClaRa.Basics.Choices.Init.steadyTemperature then
    der(T_w_i)=zeros(3);
    der(T_w_o)=zeros(3);
  else
    Q_flow_s=Q_flow;

  end if;

  annotation (Icon(coordinateSystem(extent={{-140,-100},{140,100}},
          preserveAspectRatio=false),
                   graphics={Bitmap(
          extent={{-140,100},{140,-100}},
          imageSource=
              "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"
               +
              "b1SpUkWgzogcbN2RhOWfrkF5ebloPVCAUYiaNWtApwlEl04dxW6FECKCP2Zbyo1GrNuwGRu+2MI272JhgRnTPsaEsaMF6pDIQWlpKWLilmHvt/vFboUCjBI0b/oyIsOC4ezkJHYrXOP9Ct5cOwvEwvfReyI/vwC6qBgcP3mKqU7NGjWgDfLDK127CNQZkYN7ObkI0upwIeOi2K0AoACjCGNHvUfhhRCFKy4uhtscb+aHi7k0bwa9Vk3fKQpzPi0d6jA9cnJzxW7lT3w8gYo8V9Iu072LgvwV79fwnK/AcL6CdiPrFnN4GdDvLSTELaLwojAp/9kHz3l+kgovAK3AKMKFjItIS89A29atxG6Fa5yf/7jHe4BhGba0sLCAu+tUjBs9UsCOiNSVlZVh2crV2J60U+xWnopWYBRiW6I0fwCJfPA+A0Oerlatmli8MJzCi8I8ePAQPv5BzOGlvrPpVusowCjEwdTDyM3NE7sNrvF+Bc89Onz/0LJFc6xJiEfXzp3EboWY0eWr1+Dq4Y0zv/zKVKf3Gz0x12O2QF39EwUYhSg1GJCUQrMwpPJoAUZZBg3oh0/iFsGpXl2xWyFmdODQYczy8sWdu3crXUOlUmHKh5OgCw6Cra2NgN39Hc3AKEhSyh58MGEcrOmN0yahokt4WaPj9wQ98FKZyo1GrFm3AZu2fM1Up6qdHYL8fNHr9Z4CdfZsdCZTkNzcPBxMPYyB/fqK3QqRIZqB4Z+DvT1C1f7o3LGD2K0QMyooLERYZDTz84EaNmiAiFA1mjZpIlBnz0e3kBSGhnlNiGZgZE3pM0ytW7XEmk+WUnhRmBtZWZjhMZc5vHTv1hWrli8xW3gBaAVGcdLSM3Ah4yLatGopditEdvhegVFygBkyaCB8PWfTC14V5sQPpxAaGYOCggKmOuPGjIL79CmwsDDvmggFGAXauiMZGv95YrfBHQWf/4hMWVlZYY67G0YOGyp2K8TMNm/5BqvXrUc5w61hGxsb+Pl4ijaWQLeQFOhg6mHk5d0Xuw0iM9yPwCgsgDo6OiAuOoLCi8I8Li6GVh+FT9d+zhRe6tapg4QlMaLOVFKAUaBSgwGJ9HoBwSn5FgSRl3ZtWmNNQjw6tm8ndivEjO7c/R2zvefh+0OpTHU6tm+HNQlL0cqlhUCdVQ4FGIVKStkNg8EgdhtERnjfhaSUbdTDhgxGfGwU6tR2FLsVYkY/n/0Vrh5euHTlKlOd4UMGIy46Ag4O9gJ1Vnk0A6NQT7ZUH8GAfm+J3Qo3lHICJPKkUqng6+WB4UMGi90KMbMdybsQv2IVysrKKl3DysoKXrNmYMS7QwTsjA0FGAXbmphMAUZAvN9BMtIuJFlzdqpH4UVhSg0GLI5PQMrefUx1HOztoQsOlNwtR7qFpGBp6RlIz7godhtELji/hcQ7GxvTPdKdSE9ubh485/kxh5eWLZpjdUKc5MILQAFG8bYmJovdAj84v4LnHR0+wov0jItw9fDC+bR0pjoD+r2FhCWLUK+uNN+HRQFG4Q4coi3VpGL4X4DhO8HwPoRNntj77X54+Poh+15OpWtYqFRwd52KYP/5Jn0ZIysKMAr35C3Ve8Rugwu8z1AQQqSrvLwcy1euRkTMYpSUlFS6TvXq1RAVHooJY0cL2J1pUIAhSNpFW6rJv+P9Cp77AMr34VO0h48eYV6gBl9vT2Sq06TxS1i1LA49uncTqDPTogDzgi5kZIjdguBycnNx8PBRsduQPdpGTQgxt2vXM+Hm4Y0fT//MVOeNnj3w6bIlaNSwgUCdmR4FmBewc/de+GtCxW7DJLbRMC/5F7SNWt54P35KlHrkGGZ6+eL2b3cqXUOlUmHyxPGI0GpQ1c5OwO5Mj54DUwEGgwHxK1YhcWeK2K2YzPkL6UjPuIjW9JbqSuP8/EdkjvdbgEpiNBqxbuNmrN+8hem4VqlSBUHzfdCn1xsCdmc+tALzL/Lu34f3gkCuw8sftiXtFLsFImG8n/8ogBI5KCwqQlBoOD7f9CVTeKnv7ISVS2NlG14ACjDPlXHpMlxne+PsufNit2IW3x9MpS3VDDg/vysA3wmG9wCqBLdu38ZMTx8cOXaCqU63Lp2xevlSNGv6siB9iYUCzDN8+/0BePjMx+/Z2WK3YjalBgOSd9OW6sp4lJ+PZN63o9MZkBDR/PDjabh5zMX1zBtMdcaMHIHYSB1q1qwhUGfioRmY/1FeXo4Va9bhq63bxW5FFIk7d2PSuLGwsqIfjYq6dj0TgVodbt3+TexWCAPeh3hpjVC+tnyzHSs/W4fy8vJK17C2tsZ87zkYPLC/gJ2Ji85Sf/Hw0SNo9VH48fQZsVsRzR9bqgf07SN2K7Jw8PARRMQswePHj8VuxeRoCJQQ8youLkH0knh8+/0Bpjp1ajtCr9WgDWebNCjA/D+6iv6vbUnJFGD+RbnRiDXrNmDTlq/FboUIhPcFGAqg8uPhMx8Zly4z1WjXtjXCg4NQ29FRoK6kgwIMnuyl18csRlFRkditSML5tHSkX7yE1i1dxG5FkvLzCxAaGYWTp34SuxWzoueIEGJerOFl6KC34eM1G9acjgQoeojXaDTis/WboNFFUHj5H9tpS/VTXcvMhKuHt+LCixLwPgNDKzDKYWlpCe/ZM+Hn68VteAEUHGAKCgsRGKLD+s1se+l5tf9gKvLu05bqvzp0+Chmevri1u3bYrciCv7/mfAdYIgy1KpVE4sX6jFqxDCxWzE5RQaYm1m3MNPTB0dPnBS7FckqLS3lf1twBZUbjVi9bgOt1BFZ4z+AkhbNmmL18jh06dRB7FbMQnEB5sQPp+A2Zy4yb9wUuxXJo7dUP5l38VdrsfHLr8RuRXycnwF5v4VE26j51rdPL3yyNBbOTk5it2I2/N4ce4rNW77B6nXrUc7wRWxtZYVShZzU7+Xk4tCRY+j/Vm+xWxHFtcxMBIaEK/aWERjbMEEAABJMSURBVCFE+ixUKkyfMhkfjH9f7FbMThEB5nFxMSIXLcGBQ4eZ6tR2dETQfB/4BKgF6kz6tiUmKzLA0M60f+J9FxLvCzA8zvo5O9UTu4VKMRqB/Px8FBQWMtWpVq0agv3no2eP7gJ1Ji/cB5g7d+8iMESHy1evMdVp27oVwkPUqGJrK1Bn8nAu7QIyLl1GK5cWYrdiFuVGI9au34iNX37N5Rc+ITz5euM6sVt4Yfn5BdBGLMQPP55mqtO4USNEhGnQuFEjgTqTH65nYM78chbTZ3sxh5chgwZiWWwU6tTm70FAFbEtMVnsFswiP78A/ppQbPjiKwovT8H7X4mK811IvB8/ObieeQOuHt7M4eW1V7vj02WLFR1eAI5XYLbuSELCqs9QVlZW6RqWlpbwmOGK0e/xvx3tefYfTIW761Q42NuL3YrJXM+8gUCtDlm3aN7lWXgPdfwP8RIxHT1+ErqFMShkvC39wfj3MX3KZFjQzyt/Aaa0tBQxccuw99v9THVq1aqJMHUAunTqKFBn8lVaWoqdu/di8sTxYrdiEqlHj0MfHcs879KpfTv8cu68QF0RIizeA6hUGY1GbPhiC9Zu2Mx0DKrY2sJ/njf69VHeTOKzcBVgsu/lQB0ajgsZF5nquDRvBr1WI9sBMVNI3JmCSePGwtLSUuxWBPNk3mUTNn7JdsvI2soKXh7uUAF8BxjeT4B0QUsE9vjxY+hjFuPQ4aNMdZyd6kGv1cCleTOBOuMDNzMw59IuwNXDizm89OvTGwlxiyi8/I8nW6rZ/hFKSUFBAQKCQ7Hhiy1M4aW2oyPiF0Vh+JDBAnZHiClwHkAl5vZvdzDTy5c5vHTp1AGrly+l8PIUXKzA7Ny9F3HLVzA9n8VCpYLr1I8xadwYATvjy9YdyVwsX2beuIlArQ43s24x1fnft7zyPkPB++mP9+NHzOenMz8jJHwhHj56xFRn5PB34enuxtXKt5BkHWAMBgPiV6xC4s4UpjrVq1dDSIAfenTvJlBnfDqXdgEXL19ByxbNxW6l0g4fOw59VCzzIN2wIYPh7eHO9YvSCF9oBsY8vtmehIRVa1BeXl7pGtZWVvDxnI2hg98WsDP+yPbbN+/+fWjCInCWceagSeOXEBkajEYNGwjUGd+27khC4Hwfsdt4YUajEWs3bGa+ZWRtZQWv2TMxfOg7//h/vF/B83wCNBqN+GrbDrHbMCmOD58kCLWBxNHRAfpgNdq1bS1QZ/ySZYDJuHQZQdpw/J6dzVTnzddfg9pvHqra2QnUGf/2H0zFLLdpsK9VS+xWKqygoAC6hYtw7OQPTHUcHR0QHhyE9m3bCNQZkYLCoiLoo2Jx+NhxsVshMnUvJxdBWh3zDGabVi0RHqJG3Tq1BeqMb7ILMN9+fwDRS+JRXFxS6RoqlQofTRqPKR9O4v6qWWhP3lK9F5MnjhO7lQoRbN6lTWvogoOe/zBDzn+UeFyBuZGVhcAQHW7czBK7FZPj/VUQYjmflo6gsHDk5uYx1Rk8sD/me8+BtbW1QJ3xTzYBpry8HCvWrMNXW7cz1bGzs0PQAl/0fqOnQJ0pT9KuFEwaN0byg2VHjp1AeNQi5nmXd98ZhLlzZtG8C2eOHj+J8KhFzO+jIcqVsncfFscnsG0gsbDAbLfpGDtqhICdKYMsvpEfPnoErT4KP54+w1SnYYP6iAjVoGmTJgJ1pkzZ93KQeuQY+vbpJXYrT2U0GrFu42as38w272JlZQWvWTMw4t0hFfr1vD+KnpchCqF+PuRGSX9WUysrK8OylauxPWknU52aNWogVO2Pbl06C9SZskg+wFy7nomAkDDc/u0OU53u3bpCG+SHGtWrC9SZsm1NTJZkgCkoLET4wkU4euIkUx1HRwfoNIHo0K6tQJ0RKRBqHooo14MHDxEcHoEzv/zKVKdZ05cRodWgQX1nYRpTIEkHmNQjx6CPWcz8iPfxY0dh5rQpsLDg5rl9ovv1fJrktlTfuPn/8wxZbPMMf7x5/EVf3sn7PJXcr9+vZ95AUGg48zyUbMn9AErApStXEaTV4c7d35nq9H7zdQTN94EdbSBhIskAI9SWV1tbG/jN9cKAfm8J1hv5r22JyQiYN1fsNgAIN88wdPDb8Jkzq1KDdLwHGDlLPXIMETGLmeehiHIdOHQYkYuW4HFxcaVrqFQqTJ08CZMnjqfvCwFILsAIdQvAqV5d6LUaSa0Q8Oa7A4fg7jpV1C3VRqMRn2/6Ap9v+pJ53sXT3Q3vDRsqYHd8keMMRbnRiM8+34hNW76WZf9CUvqfv7LKjUasWbcBm7Z8zVSnqp0dNP7z8UbPHgJ1RiQVYG5m3UJASBjzlsZOHdpDFxwoq2eVyNEfb6n+cII4W6oLCgsRHrUIR4+zhV0HB3voNIHo2L6dQJ0RKcjPL0BYZDROnPpR7FaITBUUFCBsYQyOnzzFVKdhgwaIDNXg5SaNBeqMABJ6meOJH07Bbc5c5vAycvi7iIuOoPBiJok7U1BWVmb2z72RlYUZc+Yyh5c2rVpiTUI8hZcKkNMV/LXrmXD18KLw8hf0HJgX8+Q7xoc5vLz6SlesXh5H4cUEJLECs2nL11izbgPKGR/xTu+OMD8xtlQfPXES4QsFmHcZ9DZ8PCs37/I0dE9bGg6kHnkyq/D4sditSIqcAqjYjp88hbCFMSgoKGCqM2HsaMyYPgUW9N1gEqIGmMfFxYhctAQHDh1mqlPb0RHhwUH07giRbEvaaZYA82Te5Ut8vukL5nmXOe5uGEnzLi9G4ue/cqMRq9d+js1fbRW7FSJjQlxQ0wYS8xAtwNy5exeBITpcvnqNqU5lt7wS4Zw9dx6XLl+BiwkHpguLihAetQhHjp1gqmPKeRdagRHPw0ePEBoRjVM/nRa7FemSeAAVm1AX1PXq1oVeq0YrlxYCdUaeRZQZmNM//4Lps72Yw8uQQQOxLDaKwosEbGN8IuXz3MjKgpuHN3N4oXkXNlKdobh89RpcZ3sxh5cWzZoK1BGRmzt3f8ds73nM4aVj+3ZYnRBH4cVMzB5gtu5Igm+ABg8fPqp0DUtLS3jNmgl/X2968ZVEfHfgEB48eCh43WMnf8CMOT7Mw91DBg3E8sXRJn3LK+8LMFKcofjuwCHM8vLFb3fuMtUZPLA/lkRHCNSVNEnx+EnBmV9+hauHFy5ducpUZ/jQdxAXHQEHe3uBOiP/xmy3kEpLSxETtwx7v93PVKdWrZoIUweiS6cOAnVGhFBSUoLk3XsE21JtNBqx4YstWLthM/u8y0xXjBz+riB9EWkQ6uWulpaWmD1jOsa8N5yGfhVoe9JOLFu5mmknpZWVFbxnz8Twoe8I2BmpCLMEmOx7OVCHhuNCxkWmOi7Nm0Gv1cDZqZ5AnREhJe7cjYnvs7+lurCoCPqoWBw+dpypjoO9PXTB5nu+C+8vc5TKFfyDBw8Rol+I0z//wlTHwd4eYZoAdOrQ/sl/4HwJTaq3AMVQajBgcXwCUvbuY6pj7u8Y8ncmDzDn0i5AHaZHbm4eU53+b/WGn683qtjaCtQZEVr2vXtIPXocfXu/WekaN7NuIVCrQ+aNm0y9tG7VEvqQINStU4epzgvh/AQoBZcuX0FQaDjzu2hE+fkgkpCbm4egsHCcT0tnqtPKpQX0WjXq1a0rUGfkRZk0wOzcvRdxy1eg1GCodA0LlQquUz/GpHFjBOyMmMq2xORKBxihnr3wztsDMM/Lg+ajOLNv/wHExMWjuLiEqc6QQQPh6zn7Hz8f/K+gid2B+C5kXIQ6NBzZ93KY6gzs1xcL5nrC1tZGoM5IZZgswHyzPRFHjrPtGqlevRpCAvzQo3s3gboipnb23HlcunIVLs2bVfj3GI1GbPzyK3y2fhPTbQpLS0vMmemKUSOGVboGC9pGbRplZWVIWPUZtu5IYqpDz/9Rtr3f7kdM3DKUlpZWuoaFhQVmTpuC8WNHCdgZqSyTBRjW8PJyk8aI0GrQqGEDgToi5rItMRn+vt4V+rWFRUWIiI5F6lH2eZe/zTMQwYkxA3P/wQME6yLx89lfmeo4OjpApwlEh3Ztn/lruM+fCl2CKS8vR8KqNfhmO1sArlG9OkIC/fDqK10F6oywksy7kP7qzddfw8r4xRReZKqiW6qzbt3GTE8f5vDSuqUL1nyyVPTwwv0J0MzSL17C9FlezOGlXZvWWJMQ/9zwogRSGcI2p4ePHsE3QMMcXl5u0hirli+h8CIxkngX0h9UKhU+/mACPv5gIi3Hy1hJSQl27tmLD8a//8xfc+KHUwiNZJ93GTywP+Z5ecDGhu5Fm5o5T4B79n2H2PgElJSwzbsMGzIY3h7usLb69686+s7hy9Vr1xGo1eH2b3eY6rz5+mtQ+81DVTs7gTojQpFMgLGzs4Pazxe9Xu8pditEAIk7d2PC2NH/2FL9ZN7la6xdv5HpXSOWlpbwmOGK0e+JM+/yNLwPgZqDwWDAspWrsSN5F1MdaysreHm4Y/iQwQJ1Jn9KWn9JPXIM4dGxTM/2UalU+GjSeEz5cBKFW4mSRIBp2KABIkLVaNqkiditEIH8np2Nw8eO461e/92RVFRUBH3MYqQeOcZU28HeHqFqf3TuSA8zNCdTL8Dk5d2HRheBs+fOM9WpU9sROk0lXu5KJynZMxqNWLthMzZ8sYVpxdDOzg5B833Q+83XBeyOCE30APPqK10REuiHGtWri90KEdjWHcl/BpisW7cRpA3HtcxMppqtW7ogPCRIms9eoBNgpaWlZ0ATpmfe3tqhXVvoNIFwdHR44d/L+9HjfQamsKgIuoUxOHr8JFOdBvWdERkajKYv0wW11IkaYCaMHY0Z06fAgr74ufTHluqc3FyERUYjP5/mXeTMVE9y3bXnP1iyfAXT9lYAeG/YUHi6u8GqAvMuhC+3bt9GQIgO1zNvMNV5pWtnaIP8UbNGDYE6I6Ykyr90W1sb+Pl4Y0DfPmJ8PDGj6MVLcenyFeZ5lz/eVyNllMNfTKnBgKUJK5GcsoepjrW1NXw8Z2HooLeZ6nA/58DpCswPP56GNmIh8wXS+6Pewyy3abCwkOTmXPIUZg8wTvXqIkKrgUuL5ub+aCKCjEuXmX6/fa1aCNME0LyLFAh4AszJzYU6TM/8OPe6deogPCQIbVq1FKgzIidffrMNn65Zx3SBZGNjg3leHhg8sL+AnRFzMGuA6dyxA8I0AbCvVcucH0tkqpVLC4SHqOFUT4LzLk9Bu5Aq5lzaBWjCIpCTm8tUp1OH9ghTB8DBwV6QvnhfgeHpZY7FxSWIWrIU331/kKlO3Tq1oQ9RozUFYFkyW4AZOfxdeLq7Mb+pmCjDoAH9MN97jqzmXbg/AQqwApO0azfiP/mU6f1oADBqxDDMmelK3ycvgJc7SL9nZyMwRIeLl68w1Wnftg3Cg4MqNfBNpMHkAcbaygo+nrMxdDDb/WmiDJaWlpjtNg1jRo4QuxUioNLSUixe9glS9u5jqmPS5X7OAygPzp47D01YBPLu32eq8+47gzB3zqwKPeCQSJdJj15tR0eEhwShXZsXfB4DUST7WrUQqg5Al04ynXfh/ARY2Sv47Hs50ITpkZaewfT5TvXqIjxEjVYuLZjqPAvfR0/+26iTU/YgLmElDAyrd5aWlvB0d8PI4e8K2BkRi8kCTJPGL2FJVATq1HY01UcQjrRs0Rx6rUY28y6kYs6eOw+NLgJ5eWxXzF06dUComubnlMhgMCBOgN1qtCGAPyYLMJ7uMyi8kAp5u39fzPf2hK2tfOZdnobzBZgXHgLdnrQTyz9dw3TFDABjR43ALNdpJp934X2GSY5DMHn370MTxv50ZpfmzaDXauDsVE+gzogUmCzAFBUVITc3z1TlRVNQUCh2C9ywtLTEx5MmYNiQwSgoKGB+saPYCjn/2SgpLqnQv+mS0lKsXLMO3x9KZfo8GxsbzHabhj5vvlGht5sLQaVSyf5Wy7MYAVl9J1+5eg2RsXG4l8P2dOY3e76GOTPdYGNtLas/Py8ePXpkstqqhi3apgNoZbJPIIQQQggRVgY9cpAQQgghskMBhhBCCCGyQwGGEEIIIbJDAYYQQgghskMBhhBCCCGyQwGGEEIIIbJDAYYQQgghskMBhhBCCCGyQwGGEEIIIbJDAYYQQgghskMBhhBCCCGyQwGGEEIIIbJDAYYQQgghskMBhhBCCCGyQwGGEEIIIbJDAYYQQgghskMBhhBCCCGyQwGGEEIIIbJDAYYQQgghskMBhhBCCCGyQwGGEEIIIbLzf3bFYfDCOTJTAAAAAElFTkSuQmCC",
          fileName="modelica://ClaRa/figures/Components/WallNTU.png")}),
                           Diagram(coordinateSystem(extent={{-140,-100},{140,
            100}}, preserveAspectRatio=true),
                                   graphics={        Rectangle(
          extent={{-100,-4},{100,-30}},
          lineColor={127,0,0},
          fillColor={74,120,145},
          fillPattern=FillPattern.Backward),         Rectangle(
          extent={{-100,30},{100,4}},
          lineColor={127,0,0},
          fillColor={74,120,145},
          fillPattern=FillPattern.Backward),
        Line(
          points={{36,-4},{36,-30}},
          color={127,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-100,32},{-34,-2}},
          lineColor={127,0,0},
          textString="1"),
        Text(
          extent={{-34,32},{34,0}},
          lineColor={127,0,0},
          textString="2"),
        Text(
          extent={{34,34},{100,2}},
          lineColor={127,0,0},
          textString="3"),
        Text(
          extent={{-34,-4},{34,-36}},
          lineColor={127,0,0},
          textString="2"),
        Text(
          extent={{-100,-4},{-32,-34}},
          lineColor={127,0,0},
          textString="1"),
        Text(
          extent={{38,-4},{104,-36}},
          lineColor={127,0,0},
          textString="3"),
        Line(
          points={{36,30},{36,4}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-32,30},{-32,4}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-32,-4},{-32,-30}},
          color={127,0,0},
          smooth=Smooth.None)}));
end NTU_L3;
