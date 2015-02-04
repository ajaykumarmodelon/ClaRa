within ClaRa.Basics.ControlVolumes.Fundamentals.Geometry;
model HollowBlockWithTubesAndCarrierTubes "Block shape || Shell with tubes || Carrier tubes"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.BlockShape;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.ShellWithTubes;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry(
    final volume=if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.horizontal
         then if parallelTubes then width*height*length - N_tubes*N_passes*Modelica.Constants.pi/4*diameter_t^2
        *length else width*height*length - N_tubes*N_passes*Modelica.Constants.pi/4*diameter_t^2*width else if
        parallelTubes then width*height*length - Modelica.Constants.pi/4*diameter_t^2*height*N_tubes*N_passes else width
        *height*length - Modelica.Constants.pi/4*diameter_t^2*length*N_tubes*N_passes,
    final N_heat=3,
    final A_heat={
      if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical
           then if parallelTubes then 2*(width + length)*height else 2*(width + length)*height - 2* N_tubes * Modelica.Constants.pi * diameter_t^2/4
        else if parallelTubes then 2*(width + height)*length else 2*(width + height)*length-2* N_tubes * Modelica.Constants.pi * diameter_t^2/4,
      if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.horizontal
           then if parallelTubes then N_tubes*N_passes*Modelica.Constants.pi*diameter_t*length else N_tubes*N_passes*Modelica.Constants.pi*diameter_t*width
        else if parallelTubes then Modelica.Constants.pi*diameter_t*height*N_tubes*N_passes else Modelica.Constants.pi*diameter_t*length*N_tubes*N_passes,
      N_ct*Modelica.Constants.pi*d_ct*height},
    final A_cross=if parallelTubes then A_front - Modelica.Constants.pi/4*diameter_t^2*N_tubes
        *N_passes else A_front*psi,
    final A_front=if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.horizontal
         then height*width else width*length,
    final A_hor=width*length*interior,
    final height_fill=height,
    final shape=[0,1; 1,1]);                                                  // A_heat[1]=Lateral surface
                                                                                // A_heat[2]=Inner HT area
                                                 // A_heat[3]= HT area of carrier tubes

  parameter Units.Length height=1 "|Essential Geometry Definition|Height of the component; Fixed flow direction in case of vertical flow orientation";
  parameter Units.Length width=1 "|Essential Geometry Definition|Width of the component";
  parameter Units.Length length=1 "Length of the component; Fixed flow direction in case of horizontal flow orientation"
  annotation(Dialog( tab = "General",
                group = "Essential Geometry Definition",
                showStartAttribute = false,
                groupImage="modelica://ClaRa/figures/ParameterDialog/HollowBlockWithTubes_1.png",
                 connectorSizing = false));

  parameter ClaRa.Basics.Choices.GeometryOrientation flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal "|Essential Geometry Definition|Orientation of shell side flow";

  final parameter Real interior = volume/(height*width*length) "Part of solid material in the shell";

  parameter Units.Length diameter_t=0.1 "|Interior Equipment|Outer diameter of internal tubes"
                                                           annotation(Dialog( tab = "General",
                group = "Shell Definition",
                showStartAttribute = false,
                groupImage="modelica://ClaRa/figures/ParameterDialog/HollowBlockWithTubes_2.png",
                 connectorSizing = false));
  parameter Integer N_tubes=1 "|Interior Equipment|Number of internal tubes for one pass";
  parameter Integer N_passes=1 "|Interior Equipment|Number of passes of the internal tubes";
  parameter Boolean parallelTubes= false "|Interior Equipment|True, if tubes are parallel to shell flow flowOrientation, else false";
  parameter Integer N_ct=16 "|Carrier tTubes| Number of carrier tubes";
  parameter Units.Length d_ct=0.04 "|Carrier Tubes| Diameter of carrier tubes";
  parameter Units.Length Delta_z_par= 2*diameter_t "|Interior Equipment|Distance between tubes parallel to flow direction";
  parameter Units.Length Delta_z_ort = 2*diameter_t "|Interior Equipment|Distance between tubes orthogonal to flow direction";
  final parameter Real a = Delta_z_ort/diameter_t "|Interior Equipment|Lateral alignment ratio";
  final parameter Real  b = Delta_z_par/diameter_t "|Interior Equipment|Vertical alignment ratio";
  final parameter Real psi = if b >= 1 then 1 - Modelica.Constants.pi/4/a else 1 - Modelica.Constants.pi/4/a/b "Void ratio";
   parameter Boolean staggeredAlignment=true "|Interior Equipment|True, if the tubes are aligned staggeredly, false otherwise";
   parameter Integer N_rows(min=N_passes, max=N_tubes*N_passes) = integer(ceil(sqrt(N_tubes))*N_passes) "|Interior Equipment|Number of pipe rows in flow direction"
                                            annotation (Dialog(group="Geometry"));

                                                                                        annotation(Dialog(enable = not parallelTubes),
              Icon(graphics={Bitmap(
          extent={{-100,100},{100,-100}},
          imageSource="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ggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAwhw63AAAHP0lEQVQAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKgmKAAAgGqCAgAAqCYoAACAaoICAACoJigAAIBqggIAAKjWalCUqck2jwcAAN5Gy4/JS1+SsbZOnxza29bRAADAKWj5MflYX5I9bZ0+sW+graMBAIBTMNnuY/I9fUl2tnV6y8sDAAAnU0omhwbbnLCj1aCYGT+Y6bHRto4HAABOYurAUMr0VJsj+lsNiiQZ276lzeMBAIATGN3W+mPx9oNi3/Pr2zweAAA4gaH2H4t3ICh+8XSbxwMAACew7/ln2h7R35ekv80J47v6M9a/tc0RAADAMUa3vpKJvbvbHrO9L8kLbU8Z+N8ftD0CAAA4wsDTT7Q9oiTZ2FdK2ZZkV5uTdq9bm4nB1j7uAgAAOMLEnt9l948fbXvMK6WUob5DP6xrc9LM5ER2rv23NkcAAACH9D/8nZSpVt8uNjnUEG8GxcNtTxt4+okcdC0FAAC0amzblgz89H86Merh5PdB8ViSyTanlZmZbPnXv8v0wbE2xwAAwFlramR/Nt/7taSUtkcdSPJkcigoSilDSZ5qe+rYjtfz+n33dOIfBACAs0qZmc6We+/O+K5W38T1TY+XUsaT3z9DkXTgZU/J7Afd7Xjo250YBQAAZ41t938j+zc936lxh9uhKYeeLWiaZnWSjl3kcMmnvpj3fP6rSdN0aiQAAJxxysx0tt3/jexe9/1OjZxKsrKUMpgcERRJ0jTNM0lu7NQmy675SNbc+bdZcO6STo0EAIAzxtTI/my59+5OPjORzL7c6dNv/nBsUHwpyX90cptzLl2dNXfelSWrr+zkWAAAmNdGtryU1+77eqeumTjS50opb33JU5I0TfOuJK8mubyjKzVNLrzh5qz68y9n8YpLOzoaAADmk/Hf7ciOB7+VwWd/0o3xm5P8QSll+s0bjgqKJGma5o4k3+rwYrOzFyzMRX/ymaz4+G0597I13VgBAAB60tj2Ldn91GPZ8+PHUqZb/9C6E/lSKeX+I284XlD0JXkhydUdXOwtFq9YleUfuinLP3RTzrnk8iw8f6kLuAEAODuUkqkDQxnr/22Gnn8m+55fn/HdO7u91XNJri/HBMRbgiJJmqb5bJK1HVrslDR9C7Jw6fIsWnZhFi29IM2Chd1eCQAA5kyZnszk8GAmhwYzNTyYMjPT7ZWOdWsp5YfH3njcoEiSpml+kuRjbW8FAAD0vB+VUm453i9OFhQ3JXm6za0AAICeV5LcUEp59ni/7DvejUlSSnkmyXfa2goAAJgXvnmimEhO8gxFkjRNsyzJi+n028gCAAC9YEuSa0spB070Byd8hiJJSilDSW5PMj7HiwEAAL1tNMntJ4uJ5G2CIklKKf+X5M652goAAJgX7iilPPd2f/S2QZEkpZR/T/IP73glAABgPri7lPLAqfzhSa+hOOoPZz/w7vtJPvMOFgMAAHrbQ0k+f+wH2J3IKQdFkjRNszTJT5NcVbcbAADQw15IclMpZeRU73BKL3l6UyllOMmtSV49zcUAAIDetinJJ08nJpLTDIokKaVsT/KJJL863fsCAAA96ZdJPlFKeeN073jaQZEcjoobkzxSc38AAKBnPJjkozUxkVQGRZKUUvYn+bMk99SeAQAAdE1J8rUkXzjdlzkd6bQuyj7hIU3zl0nuS3LOOz4MAABo22iSL5dS/uudHjQnQZEkTdPckOSBJO+dkwMBAIA2vJrki6WUX8zFYdUveTpWKWVDkmsy+0zF3FQKAAAwV2aS/GOSa+cqJpI5fIbiqEOb5vokX0/yp3N+OAAAcLoeTXJXKWXjXB/cSlAcPrxpPpXZi7avbW0IAABwIj9L8jellKfaGjBnL3k6nlLK40k+nOSvkrze5iwAAOCw3yS5vZTykTZjImn5GYqjBjXNwsy+zexfJ7k5LccMAACcZaaTPJnkn5M8UkqZ6cTQjgXFUUObZkWSz2Y2MG5Jcm7HlwAAgPlvJMkTSR7ObEQMdHqBrgTFUQs0zZIkt2Y2Lj6eZE1XFwIAgN5VkmxOsi7J2iQ/KqUc7OZCXQ+KYzVN8+4kVyd5T5JVx/m6KLMfoNd0a0cAAGhBSTKWZE+S/mO+dhz62lhK2de1DY/j/wEvix/mEed1QAAAAABJRU5ErkJggg==",
          fileName="modelica://ClaRa/figures/Components/HollowBlockWithTubes.png")}));
end HollowBlockWithTubesAndCarrierTubes;
