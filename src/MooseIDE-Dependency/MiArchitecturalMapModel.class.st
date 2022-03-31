"
I am a model of a hierarchical map.
I am responsible for:
- holding a property list
- holding elements to display on the hierarchical map.
"
Class {
	#name : #MiArchitecturalMapModel,
	#superclass : #Object,
	#instVars : [
		'entities',
		'childrenBlock',
		'childrenQuery',
		'showAllLinks',
		'associationTypes',
		'tags',
		'colorPalette',
		'assocTypeToColorDict'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #'as yet unclassified' }
MiArchitecturalMapModel class >> defaultDynamicTagIsDead [

	^ MiDynamicTag new
		  color: Color black ;
		  name: 'Is dead' ;
		  query: [ :e | e isDead ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiArchitecturalMapModel class >> defaultDynamicTagIsStub [

	^ MiDynamicTag new
		  color: Color yellow ;
		  name: 'Is stub' ;
		  query: [ :e | e isStub ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiArchitecturalMapModel class >> defaultDynamicTags [

	^ { 
		  self defaultDynamicTagIsStub .
		  self defaultDynamicTagIsDead }
]

{ #category : #accessing }
MiArchitecturalMapModel >> assocTypeToColorDict [

	^ assocTypeToColorDict
]

{ #category : #accessing }
MiArchitecturalMapModel >> associationTypes [

	^ associationTypes
]

{ #category : #accessing }
MiArchitecturalMapModel >> associationTypes: aCollection [

	
	associationTypes := aCollection.
	assocTypeToColorDict := Dictionary new.
	aCollection doWithIndex: [ :type :i | 
		i <= colorPalette size
			ifTrue: [ assocTypeToColorDict at: type put: (colorPalette at: i) ]
			ifFalse: [ assocTypeToColorDict at: type put: Color random ] ]
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenFor: anEntity [

	^ childrenQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiArchitecturalMapModel >> childrenQuery: anObject [

	childrenQuery := anObject
]

{ #category : #private }
MiArchitecturalMapModel >> colorFor: anEntity [

	^ Color gray
]

{ #category : #accessing }
MiArchitecturalMapModel >> entities [

	^ entities
]

{ #category : #accessing }
MiArchitecturalMapModel >> entities: anObject [

	entities := anObject
]

{ #category : #accessing }
MiArchitecturalMapModel >> initialize [

	super initialize.
	showAllLinks := false.
	colorPalette := (RSQualitativeColorPalette new paired12) range asOrderedCollection.
	associationTypes := OrderedCollection new.
	tags := OrderedCollection new
]

{ #category : #accessing }
MiArchitecturalMapModel >> showAllLinks [

	^ showAllLinks
]

{ #category : #accessing }
MiArchitecturalMapModel >> showAllLinks: anObject [

	showAllLinks := anObject
]

{ #category : #accessing }
MiArchitecturalMapModel >> tags [

	^ tags
]

{ #category : #accessing }
MiArchitecturalMapModel >> tags: anObject [

	tags := anObject
]
