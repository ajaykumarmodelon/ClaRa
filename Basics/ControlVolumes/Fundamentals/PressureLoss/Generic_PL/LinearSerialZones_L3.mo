within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model LinearSerialZones_L3 "All geo || L3 || Linear pressure loss || constant pressure loss coefficient"
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

 extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeType_L3;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellType_L3;
//
//   parameter SI.Pressure Delta_p_nom[iCom.N_inlet]=ones(iCom.N_inlet)*1000
//     "Nominal ressure loss";
//
// equation
//   Delta_p = ones(iCom.N_inlet)*sum(Delta_p_nom./iCom.m_flow_nom*iCom.m_flow_in);

  parameter SI.Pressure Delta_p_nom[iCom.N_cv]=ones(iCom.N_cv)*1000 "Nominal ressure loss";

equation
  Delta_p = sum(Delta_p_nom./iCom.m_flow_nom)*iCom.m_flow_in;

end LinearSerialZones_L3;