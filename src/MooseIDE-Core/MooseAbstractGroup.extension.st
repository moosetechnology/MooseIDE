Extension { #name : #MooseAbstractGroup }

{ #category : #'*MooseIDE-Core' }
MooseAbstractGroup >> miPropagate [

	(MiApplication current busNamed: MiApplication defaultBusName ) globallySelect: self.
]
