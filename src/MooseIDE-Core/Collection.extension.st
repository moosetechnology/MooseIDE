Extension { #name : #Collection }

{ #category : #'*MooseIDE-Core' }
Collection >> miInspect [

	self asMooseGroup miInspect
]

{ #category : #'*MooseIDE-Core' }
Collection >> miPropagate [ 

	self asMooseGroup miPropagate.
]
