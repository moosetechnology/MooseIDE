Extension { #name : #MooseObject }

{ #category : #'*MooseIDE-Core' }
MooseObject >> isMooseObject [
	^ true
]

{ #category : #'*MooseIDE-Core' }
MooseObject >> miPropagate [

	(MiApplication current busNamed: MiApplication defaultBusName ) globallySelect: self.
]
