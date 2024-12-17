Extension { #name : #MooseEntity }

{ #category : #'*MooseIDE-Dependency' }
MooseEntity >> queryAllOutgoingForDSM [
	"Query all the outgoing associations of the receiver and its children.
	 This is a special implementation intended to catch more dependencies.
	 For example it gets the declaredType of variables.
	 This is temporary until we resolve the issue of declaredType not being an Association"

	^ self query outgoing dependencies
]

{ #category : #'*MooseIDE-Dependency' }
MooseEntity >> rootsForTreeMap [

	^ {  }
]
