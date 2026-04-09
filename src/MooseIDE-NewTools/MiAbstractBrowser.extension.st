Extension { #name : 'MiAbstractBrowser' }

{ #category : '*MooseIDE-NewTools' }
MiAbstractBrowser >> miInspect [
	"For the inspector we try to have a specialized moose entity to provide the most useful information."

	MiInspectorBrowser inspect: self miSelectedItem mooseInterestingEntity forBuses: buses
]
