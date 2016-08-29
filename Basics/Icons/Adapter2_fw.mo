within ClaRa.Basics.Icons;
model Adapter2_fw

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/figures/Components/Adapter2_forward.png")}));

end Adapter2_fw;
