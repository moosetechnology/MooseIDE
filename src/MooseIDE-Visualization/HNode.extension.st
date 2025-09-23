Extension { #name : 'HNode' }

{ #category : '*MooseIDE-Visualization' }
HNode >> miInspect [

	self rawModel miInspect
]

{ #category : '*MooseIDE-Visualization' }
HNode >> miPropagateOn: buses [

	self rawModel miPropagateOn: buses
]
