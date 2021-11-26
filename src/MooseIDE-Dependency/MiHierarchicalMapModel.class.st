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
		'dynamicTags',
		'childrenBlock'
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
MiHierarchicalMapModel >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
MiHierarchicalMapModel >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel >> colorFor: anEntity [
	
	| dt |
	dt :=  (self dynamicTagFor: anEntity).
	^ dt color ifNil: [ self colorForDynamicTag:  dt]
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel >> colorForDynamicTag: aDynamicTag [
	
	self flag: 'Model should have a color map and automatically handle colors.'.
	^ Color green
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapModel >> dynamicTagFor: anEntity [

	^ self dynamicTags
		  detect: [ :dt | dt isApplicableTo: anEntity ]
		  ifNone: [ MiNullDynamicTag new ]
]

{ #category : #accessing }
MiHierarchicalMapModel >> dynamicTags [

	^ dynamicTags
]

{ #category : #accessing }
MiHierarchicalMapModel >> dynamicTags: anObject [

	dynamicTags := anObject
]

{ #category : #accessing }
MiHierarchicalMapModel >> entities [

	^ entities
]

{ #category : #accessing }
MiHierarchicalMapModel >> entities: anObject [

	entities := anObject
]
