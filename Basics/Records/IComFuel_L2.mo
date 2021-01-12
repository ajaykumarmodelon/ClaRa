within ClaRa.Basics.Records;
record IComFuel_L2 "Basic internal communication record for heat transfer"
  extends ClaRa.Basics.Records.IComBase_L2;

//____Variables for system description__________________________________________________
 parameter ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel = ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1()  "Fuel type";
//____Inlet____________________________________________________________________________
  Units.MassFraction xi_c_in[fuelModel.N_c - 1] "Inlet medium composition" annotation (Dialog(tab="Inlet"));
  Units.MassFraction xi_e_in[fuelModel.N_e - 1] "Inlet elemental composition" annotation (Dialog(tab="Inlet"));

//____Outlet____________________________________________________________________________
  Units.MassFraction xi_c_out[fuelModel.N_c - 1] "Outlet medium composition" annotation (Dialog(tab="Outlet"));
  Units.MassFraction xi_e_out[fuelModel.N_e - 1] "Outlet medium composition" annotation (Dialog(tab="Outlet"));

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
</html>"),   defaultComponentName="iCom",
    defaultComponentPrefixes="inner");
end IComFuel_L2;
