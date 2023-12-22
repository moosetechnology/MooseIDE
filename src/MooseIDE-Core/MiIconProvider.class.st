"
I hold a icon set for Moose IDE
"
Class {
	#name : #MiIconProvider,
	#superclass : #SpIconProvider,
	#category : #'MooseIDE-Core-Application'
}

{ #category : #accessing }
MiIconProvider >> iconForTag: aTag [
	"generates an icon for aTag (using its answer to #color)
	 if aTag is nil, the color is #F0F0F0"

	| newColor |
	newColor := aTag
		            ifNil: [ Color transparent ]
		            ifNotNil: [
		            aTag color
			            ifNil: [ Color transparent ]
			            ifNotNil: [ aTag color ] ].

	^ ((aTag isNil or: [ aTag class = FamixTag ])
		   ifTrue: [ self iconNamed: #emptyTag ]
		   ifFalse: [ self iconNamed: #emptyAlternativeTag ])
		  mapColor: (Color fromHexString: '#F0F0F0')
		  to: newColor
]

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
