within ClaRa.Basics.Functions.TestCases;
model TestMaxAbs
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  Real x1=time;
  Real x2=time-1;
  Real maxx=ClaRa.Basics.Functions.maxAbs(x1,x2,0.1);
  Real minn=ClaRa.Basics.Functions.minAbs(x1,x2,0.1);
equation

end TestMaxAbs;
