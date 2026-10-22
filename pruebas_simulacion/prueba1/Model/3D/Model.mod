'# MWS Version: Version 2025.1 - Oct 28 2024 - ACIS 34.0.1 -

'# length = mm
'# frequency = MHz
'# time = ns
'# frequency range: fmin = 120 fmax = 141
'# created = '[VERSION]2025.1|34.0.1|20241028[/VERSION]


'@ use template: Antenna - Wire.cfg

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mm"
    .SetUnit "Frequency", "MHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "120", "141"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

Mesh.FPBAAvoidNonRegUnite "True"
Mesh.ConsiderSpaceForLowerMeshLimit "False"
Mesh.MinimumStepNumber "5"
Mesh.RatioLimit "20"
Mesh.AutomeshRefineAtPecLines "True", "10"

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "10"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With MeshSettings
     .SetMeshType "Srf"
     .Set "Version", 1
End With
IESolver.SetCFIEAlpha "1.000000"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "120;130.5;141"
Dim sDefineAtName As String
sDefineAtName = "120;130.5;141"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ activate local coordinates

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
WCS.ActivateWCS "local"

'@ define curve circle: curve1:circle1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Circle
     .Reset 
     .Name "circle1" 
     .Curve "curve1" 
     .Radius "wire_diameter/2" 
     .Xcenter "0.0" 
     .Ycenter "0.0" 
     .Segments "0" 
     .Create
End With

'@ define material: Copper (pure)

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Material
     .Reset
     .Name "Copper (pure)"
     .Folder ""
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Mu "1.0"
     .Sigma "5.96e+007"
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "5.96e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .DispersiveFittingSchemeMu "Nth Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ define material: Copper (annealed)

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "5.8e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .DispersiveFittingSchemeMu "Nth Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .FrqType "all"
     .Type "Lossy metal"
     .SetMaterialUnit "GHz", "mm"
     .Mu "1.0"
     .Kappa "5.8e+007"
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ new component: component1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Component.New "component1"

'@ define coverprofile: component1:coil_1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With CoverCurve
     .Reset 
     .Name "coil_1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Curve "curve1:circle1" 
     .DeleteCurve "True" 
     .Create
End With

'@ define curve line: curve1:line1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "D1/2" 
     .Y1 "dif" 
     .X2 "D1/2" 
     .Y2 "H2" 
     .Create
End With


'@ pick face

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickFaceFromId "component1:coil_1", "1"

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeOnCurveFromId "curve1:line1", "1", "1"

'@ define rotate: component1:coil_curve_1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Rotate 
     .Reset 
     .Name "coil_curve_1" 
     .Component "component1" 
     .NumberOfPickedFaces "1" 
     .Material "Copper (annealed)" 
     .Mode "Picks" 
     .Angle "-180" 
     .Height "H1" 
     .RadiusRatio "1.0" 
     .TaperAngle "0.0" 
     .NSteps "15" 
     .SplitClosedEdges "True" 
     .SegmentedProfile "True" 
     .DeleteBaseFaceSolid "False" 
     .ClearPickedFace "True" 
     .SimplifySolid "True" 
     .UseAdvancedSegmentedRotation "True" 
     .CutEndOff "False" 
     .Create 
End With

'@ define curve circle: curve1:circle1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Circle
     .Reset 
     .Name "circle1" 
     .Curve "curve1" 
     .Radius "wire_diameter/2" 
     .Xcenter "0.0" 
     .Ycenter "0.0" 
     .Segments "0" 
     .Create
End With

'@ transform curve: translate curve1:circle1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:circle1" 
     .Vector "D1/2", "0", "D2/2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ define coverprofile: component1:coil_2

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With CoverCurve
     .Reset 
     .Name "coil_2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Curve "curve1:circle1" 
     .DeleteCurve "True" 
     .Create
End With

'@ transform: translate component1:coil_2

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Transform 
     .Reset 
     .Name "component1:coil_2" 
     .Vector "0", "dif", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ delete curve item: curve1:line1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Curve.DeleteCurveItem "curve1", "line1"

'@ define curve line: curve1:line2

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Line
     .Reset 
     .Name "line2" 
     .Curve "curve1" 
     .X1 "D1/2" 
     .Y1 "dif" 
     .X2 "D1/2" 
     .Y2 "H2" 
     .Create
End With

'@ transform: rotate component1:coil_2

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Transform 
     .Reset 
     .Name "component1:coil_2" 
     .Origin "Free" 
     .Center "D1/2", "dif", "D2/2" 
     .Angle "0", "90", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ pick face

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickFaceFromId "component1:coil_2", "1"

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeOnCurveFromId "curve1:line2", "1", "1"

'@ define rotate: component1:coil_curve_2

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Rotate 
     .Reset 
     .Name "coil_curve_2" 
     .Component "component1" 
     .NumberOfPickedFaces "1" 
     .Material "Copper (annealed)" 
     .Mode "Picks" 
     .Angle "-180" 
     .Height "H2" 
     .RadiusRatio "1.0" 
     .TaperAngle "0.0" 
     .NSteps "15" 
     .SplitClosedEdges "True" 
     .SegmentedProfile "True" 
     .DeleteBaseFaceSolid "False" 
     .ClearPickedFace "True" 
     .SimplifySolid "True" 
     .UseAdvancedSegmentedRotation "True" 
     .CutEndOff "False" 
     .Create 
End With

'@ define curve circle: curve1:circle1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Circle
     .Reset 
     .Name "circle1" 
     .Curve "curve1" 
     .Radius "wire_diameter/2" 
     .Xcenter "D1" 
     .Ycenter "0.0" 
     .Segments "0" 
     .Create
End With

'@ define coverprofile: component1:coil_11

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With CoverCurve
     .Reset 
     .Name "coil_11" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Curve "curve1:circle1" 
     .DeleteCurve "True" 
     .Create
End With

'@ pick face

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickFaceFromId "component1:coil_11", "1"

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeOnCurveFromId "curve1:line2", "1", "1"

'@ define rotate: component1:coil_curve_11

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Rotate 
     .Reset 
     .Name "coil_curve_11" 
     .Component "component1" 
     .NumberOfPickedFaces "1" 
     .Material "Copper (annealed)" 
     .Mode "Picks" 
     .Angle "-180" 
     .Height "H1" 
     .RadiusRatio "1.0" 
     .TaperAngle "0.0" 
     .NSteps "15" 
     .SplitClosedEdges "True" 
     .SegmentedProfile "True" 
     .DeleteBaseFaceSolid "False" 
     .ClearPickedFace "True" 
     .SimplifySolid "True" 
     .UseAdvancedSegmentedRotation "True" 
     .CutEndOff "False" 
     .Create 
End With

'@ define curve circle: curve1:circle1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Circle
     .Reset 
     .Name "circle1" 
     .Curve "curve1" 
     .Radius "wire_diameter/2" 
     .Xcenter "0.0" 
     .Ycenter "0.0" 
     .Segments "0" 
     .Create
End With

'@ transform curve: translate curve1:circle1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:circle1" 
     .Vector "D1/2", "dif", "-D2/2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ transform curve: rotate curve1:circle1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:circle1" 
     .Origin "Free" 
     .Center "D1/2", "dif", "-D2/2" 
     .Angle "0", "90", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Rotate" 
End With

'@ define coverprofile: component1:coil_22

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With CoverCurve
     .Reset 
     .Name "coil_22" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Curve "curve1:circle1" 
     .DeleteCurve "True" 
     .Create
End With

'@ pick face

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickFaceFromId "component1:coil_22", "1"

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeOnCurveFromId "curve1:line2", "1", "1"

'@ define rotate: component1:coil_curve_22

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Rotate 
     .Reset 
     .Name "coil_curve_22" 
     .Component "component1" 
     .NumberOfPickedFaces "1" 
     .Material "Copper (annealed)" 
     .Mode "Picks" 
     .Angle "-180" 
     .Height "H2" 
     .RadiusRatio "1.0" 
     .TaperAngle "0.0" 
     .NSteps "15" 
     .SplitClosedEdges "True" 
     .SegmentedProfile "True" 
     .DeleteBaseFaceSolid "False" 
     .ClearPickedFace "True" 
     .SimplifySolid "True" 
     .UseAdvancedSegmentedRotation "True" 
     .CutEndOff "False" 
     .Create 
End With

'@ delete shape: component1:coil_22

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Delete "component1:coil_22"

'@ delete shape: component1:coil_1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Delete "component1:coil_1"

'@ delete shape: component1:coil_2

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Delete "component1:coil_2"

'@ delete shape: component1:coil_11

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Delete "component1:coil_11"

'@ define cylinder: component1:solid1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "wire_diameter/2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "-20", "20" 
     .Xcenter "D1/2" 
     .Ycenter "dif" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid2

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "wire_diameter/2" 
     .InnerRadius "0.0" 
     .Axis "x" 
     .Xrange "D1/160", "D1-D1/160" 
     .Ycenter "0" 
     .Zcenter "0" 
     .Segments "0" 
     .Create 
End With

'@ rename block: component1:solid1 to: component1:jk

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Rename "component1:solid1", "jk"

'@ delete shape: component1:jk

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Delete "component1:jk"

'@ define cylinder: component1:solid3

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid3" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "wire_diameter/2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "-D2/2+D2/160", "D2/2-D2/160" 
     .Xcenter "D1/2" 
     .Ycenter "dif" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid8

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid8" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "wire_diameter/2" 
     .InnerRadius "0.0" 
     .Axis "x" 
     .Xrange "D1/160", "D1/2-D1/32" 
     .Ycenter "H1" 
     .Zcenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid9

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid9" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "wire_diameter/2" 
     .InnerRadius "0.0" 
     .Axis "x" 
     .Xrange "D1/2+D1/32", "D1-D1/160" 
     .Ycenter "H1" 
     .Zcenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid10

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid10" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "wire_diameter/2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "-D2/2+D2/160", "-D2/32" 
     .Xcenter "D1/2" 
     .Ycenter "H1-dif" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:solid11

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "wire_diameter/2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "D1/32", "D2/2-D2/160" 
     .Xcenter "D1/2" 
     .Ycenter "H1-dif" 
     .Segments "0" 
     .Create 
End With

'@ pick face

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickFaceFromId "component1:solid10", "3"

'@ pick face

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickFaceFromId "component1:solid8", "3"

'@ define loft: component1:solid12

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Loft 
     .Reset 
     .Name "solid12" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Tangency "0.01" 
     .Minimizetwist "true" 
     .CreateNew 
End With

'@ pick face

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickFaceFromId "component1:solid9", "1"

'@ pick face

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickFaceFromId "component1:solid11", "1"

'@ define loft: component1:solid13

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Loft 
     .Reset 
     .Name "solid13" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Tangency "0.01" 
     .Minimizetwist "true" 
     .CreateNew 
End With

'@ define discrete port: 1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "50.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "False", "158", "723", "-3"
     .SetP2 "False", "164.5", "725", "2"
     .InvertDirection "False"
     .LocalCoordinates "True"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

