Class {
	#name : 'MiShowOutgoingMenuItem',
	#superclass : 'MiArchitecturalNodeMenuItem',
	#category : 'MooseIDE-ArchitecturalMap-Menu',
	#package : 'MooseIDE-ArchitecturalMap',
	#tag : 'Menu'
}

{ #category : 'testing' }
MiShowOutgoingMenuItem >> canBeExecuted [

	^ shape isShape and: [ 
		  shape isNode and: [ 
			  shape model rawModel isTag or: [ 
				  shape model parent rawModel isTag ] ] ]
]

{ #category : 'execution' }
MiShowOutgoingMenuItem >> execute [

	visualization addOutgoingsFor: shape model
]

{ #category : 'accessing' }
MiShowOutgoingMenuItem >> label [
	^ 'Show outgoing'
]
