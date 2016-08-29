within ClaRa.Basics.Icons;
model IdealSeparation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/figures/Components/IdealSeparation.png")}));

end IdealSeparation;
