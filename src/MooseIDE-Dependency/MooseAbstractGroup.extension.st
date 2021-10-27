Extension { #name : #MooseAbstractGroup }

{ #category : #'*MooseIDE-Dependency' }
MooseAbstractGroup >> rootsForTreeMap [

	^ self select: [ :entity | entity isContainerEntity ]
]
