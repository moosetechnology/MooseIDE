Extension { #name : #MiModelRootBrowser }

{ #category : #'*MooseIDE-NewTools' }
MiModelRootBrowser >> miInspect [

	self inspector inspect: self miSelectedModel forBuses: buses
]
