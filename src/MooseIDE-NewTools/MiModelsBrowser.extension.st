Extension { #name : #MiModelsBrowser }

{ #category : #'*MooseIDE-NewTools' }
MiModelsBrowser >> miInspect [

	self inspector inspect: self miSelectedModel forBuses: buses
]
