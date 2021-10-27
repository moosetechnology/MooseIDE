Extension { #name : #SpCommand }

{ #category : #'*MooseIDE-Core' }
SpCommand >> updateIconForMode: aReceivingMode [

	presenter ifNil: [ ^ self ].
	self iconName: (self decoratedCommand iconNameForState:
			 self decoratedCommand receivingMode = aReceivingMode).
	presenter icon: (self iconNamed: self iconName)
]
