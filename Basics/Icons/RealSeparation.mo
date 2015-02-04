within ClaRa.Basics.Icons;
model RealSeparation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Bitmap(
          extent={{-100,100},{100,-100}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/figures/Components/RealSeparation.png")}));

end RealSeparation;
