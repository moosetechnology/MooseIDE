Class {
	#name : #MiHideIncomingMenuItem,
	#superclass : #MiArchitecturalNodeMenuItem,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #testing }
MiHideIncomingMenuItem >> canBeExecuted [

	^ shape isShape and: [ 
		  shape isNode and: [ 
			  shape model rawModel isTag or: [ 
				  shape model parent rawModel isTag ] ] ]
]

{ #category : #testing }
MiHideIncomingMenuItem >> label [

	^ 'Hide incoming'
]
