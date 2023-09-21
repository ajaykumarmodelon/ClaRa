within ClaRa.StaticCycles.Check;
model TestStacy2

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


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  StaticCycleExamples.StaCy_5Components_Spray staCy(triple2(decimalSpaces(m_flow=2)))
                                                    annotation (Placement(transformation(extent={{-80,-60},{60,80}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));

  annotation(experiment(StopTime=2, method="dassl"));
end TestStacy2;