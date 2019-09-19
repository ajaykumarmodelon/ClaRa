within ClaRa.Components.TurboMachines.Fundamentals;
package PumpEnergetics "Characteristic field representations for pump losses and efficiency"
    extends ClaRa.Basics.Icons.PackageIcons.Components60;
  model BaseEnergetics
    extends ClaRa.Basics.Icons.Efficiency;

    outer ClaRa.Components.TurboMachines.Fundamentals.IComPump_L1 iCom;

    ClaRa.Basics.Units.Power P_loss "Power transferred to fluid";
    ClaRa.Basics.Units.Torque tau_loss "Loss torque";
    ClaRa.Basics.Units.Efficiency eta "Total efficiency";
    ClaRa.Basics.Units.Torque tau_fluid "Current fluid torque";
    ClaRa.Basics.Units.Power P_fluid "Current fluid power";
    ClaRa.Basics.Units.Power P_iso "Isentropic power";
  end BaseEnergetics;

  model EfficiencyCurves_Q1 "Losses by efficiency | normal operation | "
    extends ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics.BaseEnergetics;

    import SM = ClaRa.Basics.Functions.Stepsmoother;
    import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
    import Modelica.Constants.pi;
    import density = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi;

    parameter Real eta_hyd_nom=0.8 "Max. hydraulic efficiency at nominal speed" annotation(Dialog(group = "Characteristic Field - refer to documentation for details", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/EfficiencyCurvesParameterDialogue.png"));
    parameter Real V_flow_opt_(min=0.0, max=1) = 0.6 "Relative position of best point at V_flow axis in p.u." annotation(Dialog(group="Characteristic Field - refer to documentation for details"));
    parameter Real exp_rpm=0 "Exponent for rpm dependency of max. efficiency" annotation(Dialog(group="Characteristic Field - refer to documentation for details"));

    parameter Real exp_flow=2 "Exponent for volume flow dependency of efficiency" annotation(Dialog(group="Characteristic Field - refer to documentation for details"));

    parameter Basics.Units.VolumeFlowRate V_flow_leak=0.00002 "Leakage mass flow" annotation (Dialog(tab="Expert Settings", group="Non-Design Operation - refer to documentation for details"));

    parameter Basics.Units.Pressure Delta_p_eps=100 "Small pressure difference for linearisation around zero mass flow" annotation (Dialog(tab="Expert Settings", group="Numerical Robustness"));

    parameter Boolean stabiliseDelta_p=false "Avoid chattering due to small pressure differences between inlet and outlet at small mass flows"
                                                                                              annotation(Dialog(tab = "Expert Settings", group="Numerical Robustness"));
    parameter Basics.Units.Time Tau_stab=1 "Stabiliser state time constant - refer to documentation for details." annotation (Dialog(
        tab="Expert Settings",
        group="Numerical Robustness",
        enable=stabiliseDelta_p));

    Basics.Units.Pressure Delta_p_zeroflowrpm "Maximum pressure difference at current speed";

  protected
    Basics.Units.Pressure Delta_p_ps "Pressure pseudo state prevents chattering";
    constant Basics.Units.RPM rpm_eps=1e-5 "Rotational speed";
    ClaRa.Basics.Units.Power P_diss "Dissipation power";
    ClaRa.Basics.Units.DensityMassSpecific rho_upstream "Upstream density";
    ClaRa.Basics.Units.VolumeFlowRate V_flow_zeroheadrpm;

  initial equation
   if stabiliseDelta_p then
    Delta_p_ps = iCom.Delta_p;
   end if;

  equation
    if stabiliseDelta_p then
     der(Delta_p_ps) = (iCom.Delta_p-Delta_p_ps)/Tau_stab;
    else
      Delta_p_ps = iCom.Delta_p;
    end if;
    rho_upstream = noEvent(if iCom.V_flow > 0 then density(iCom.p_in, iCom.h_in, iCom.xi_in, iCom.fluidPointer_in) else density(iCom.p_out, iCom.h_out, iCom.xi_out, iCom.fluidPointer_out));
    P_iso = noEvent(if sign(iCom.rpm/iCom.rpm_nom)* sign(iCom.Delta_p/iCom.Delta_p_zeroflow)* sign(iCom.V_flow/iCom.V_flow_zerohead) > 0 then (iCom.h_out_iso -  iCom.h_in_iso)*iCom.m_flow else 0);
    Delta_p_zeroflowrpm = iCom.Delta_p_zeroflow*(iCom.rpm/iCom.rpm_nom)^2;
    V_flow_zeroheadrpm = iCom.V_flow_zerohead*iCom.rpm/iCom.rpm_nom;
    P_diss = noEvent(if sign(iCom.rpm/iCom.rpm_nom* iCom.Delta_p/iCom.Delta_p_zeroflow* iCom.V_flow/iCom.V_flow_zerohead* tau_fluid) < 0 then (iCom.h_out_iso -  iCom.h_in_iso)*iCom.V_flow*rho_upstream else 0);
    P_loss = SM(-Delta_p_eps,Delta_p_eps, Delta_p_ps)  *(-iCom.P_iso*(1-eta))
            + SM(+Delta_p_eps,-Delta_p_eps, Delta_p_ps)  * SM(Delta_p_zeroflowrpm-Delta_p_eps,Delta_p_zeroflowrpm, Delta_p_ps)  * iCom.P_iso*(1-eta)/eta
            + SM(Delta_p_zeroflowrpm,Delta_p_zeroflowrpm-Delta_p_eps, Delta_p_ps)*(-2*P_diss + P_diss*(iCom.rpm_nom-iCom.rpm)/iCom.rpm_nom) "reverse turbine | normal pumping | dissipation";
    P_fluid = tau_fluid*2* pi*iCom.rpm/60;
    tau_loss = P_loss / (1e-3 + 2*pi*iCom.rpm/60);
    tau_fluid = if noEvent(iCom.rpm<rpm_eps) then 0 else (P_iso+P_loss)/(2*pi*iCom.rpm/60);

  //____________________ Affinity Laws _______________________
    eta = noEvent(max(0.001,SM(Delta_p_zeroflowrpm-Delta_p_eps,Delta_p_zeroflowrpm, Delta_p_ps)*(eta_hyd_nom*(abs(iCom.rpm)/iCom.rpm_nom)^(-exp_rpm)) *SM(V_flow_opt_, 1, iCom.V_flow/V_flow_zeroheadrpm)*(1-abs(pow( max(V_flow_leak,iCom.V_flow)/(max(V_flow_leak,V_flow_zeroheadrpm)*V_flow_opt_) - 1, 0.01, exp_flow)))));

  end EfficiencyCurves_Q1;
end PumpEnergetics;