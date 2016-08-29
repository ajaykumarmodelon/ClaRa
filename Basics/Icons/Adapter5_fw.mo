within ClaRa.Basics.Icons;
model Adapter5_fw

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
              "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"
               +
              "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",
          fileName="modelica://ClaRa/figures/Components/Adapter.png")}));

end Adapter5_fw;
