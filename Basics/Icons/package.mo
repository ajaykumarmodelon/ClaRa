within ClaRa.Basics;
package Icons
//__________________________________________________________________________//
// Package of the ClaRa library, version: 1.7.0                             //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
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


  extends ClaRa.Basics.Icons.PackageIcons.Basics80;






































































































  model Characteristics
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-100,-100},{100,100}},
            imageSource=
                "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",
            fileName="modelica://ClaRa/Resources/Images/Components/CharBase.png")}), Diagram(coordinateSystem(preserveAspectRatio=false)));

  end Characteristics;
end Icons;
