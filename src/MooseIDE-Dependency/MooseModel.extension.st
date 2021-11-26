Extension { #name : #MooseModel }

{ #category : #'*MooseIDE-Dependency' }
MooseModel >> rootsForTreeMap [

	^ self allRootContainers asMooseGroup
]
