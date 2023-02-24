"
I hold a icon set for Moose IDE
"
Class {
	#name : #MiIconProvider,
	#superclass : #SpIconProvider,
	#category : #'MooseIDE-Core-Application'
}

{ #category : #accessing }
MiIconProvider >> iconNamed: aName [

	^ MooseIcons icons
		  at: aName
		  ifAbsent: [ 
		  Smalltalk ui icons iconNamed: aName ifNone: [ self noIcon ] ]
]

{ #category : #accessing }
MiIconProvider >> iconNamed: aName ifAbsent: aBlock [

	^ MooseIcons icons at: aName ifAbsent: aBlock
]

{ #category : #initialization }
MiIconProvider >> initialize [

	super initialize.
	MooseIcons buildCache
]

{ #category : #accessing }
MiIconProvider >> noIcon [

	^ Smalltalk ui icons iconNamed: #blankIcon
]
