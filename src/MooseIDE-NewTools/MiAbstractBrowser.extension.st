Extension { #name : #MiAbstractBrowser }

{ #category : #'*MooseIDE-NewTools' }
MiAbstractBrowser >> miInspect [

	self inspector inspect: self miSelectedItem forBuses: buses
]
