"
I am a model of a hierarchical map.
I am responsible for:
- holding a property list
- holding elements to display on the hierarchical map.
"
Class {
	#name : #MiHierarchicalMapModel,
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
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel class >> defaultDynamicTagIsDead [

	^ MiDynamicTag new
		  color: Color black ;
		  name: 'Is dead' ;
		  query: [ :e | e isDead ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel class >> defaultDynamicTagIsStub [

	^ MiDynamicTag new
		  color: Color yellow ;
		  name: 'Is stub' ;
		  query: [ :e | e isStub ] ;
		  yourself
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel class >> defaultDynamicTags [

	^ { 
		  self defaultDynamicTagIsStub .
		  self defaultDynamicTagIsDead }
]

{ #category : #accessing }
MiHierarchicalMapModel >> assocTypeToColorDict [

	^ assocTypeToColorDict
]

{ #category : #accessing }
MiHierarchicalMapModel >> associationTypes [

	^ associationTypes
]

{ #category : #accessing }
MiHierarchicalMapModel >> associationTypes: aCollection [

	
	associationTypes := aCollection.
	assocTypeToColorDict := Dictionary new.
	aCollection doWithIndex: [ :type :i | 
		i <= colorPalette size
			ifTrue: [ assocTypeToColorDict at: type put: (colorPalette at: i) ]
			ifFalse: [ assocTypeToColorDict at: type put: Color random ] ]
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenFor: anEntity [

	^ childrenQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenQuery: anObject [

	childrenQuery := anObject
]

{ #category : #private }
MiHierarchicalMapModel >> colorFor: anEntity [

	^ Color gray
]

{ #category : #accessing }
MiHierarchicalMapModel >> entities [

	^ entities
]

{ #category : #accessing }
MiHierarchicalMapModel >> entities: anObject [

	entities := anObject
]

{ #category : #accessing }
MiHierarchicalMapModel >> initialize [

	super initialize.
	showAllLinks := false.
	colorPalette := (RSQualitativeColorPalette new paired12) range asOrderedCollection.
	associationTypes := OrderedCollection new.
	tags := OrderedCollection new
]

{ #category : #accessing }
MiHierarchicalMapModel >> showAllLinks [

	^ showAllLinks
]

{ #category : #accessing }
MiHierarchicalMapModel >> showAllLinks: anObject [

	showAllLinks := anObject
]

{ #category : #accessing }
MiHierarchicalMapModel >> tags [

	^ tags
]

{ #category : #accessing }
MiHierarchicalMapModel >> tags: anObject [

	tags := anObject
]
