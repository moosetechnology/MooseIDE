Class {
	#name : #MiButterflyMapModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'currentEntity'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #initialization }
MiButterflyMapModel class >> settingsManagerClass [

	^ MiButterflyMapSettingsManager
]

{ #category : #computing }
MiButterflyMapModel >> childrenFor: anEntity [

	^ settingsManager childrenQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity [

	^ currentEntity
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity: anObject [

	currentEntity := anObject.
	browser runVisualization
]

{ #category : #accessing }
MiButterflyMapModel >> entities [
	"should probably return all entities displayed and not only the central one"
	^self currentEntity
		ifNil: [ #() ]
		ifNotNil: [ :entity | { entity } ]
]

{ #category : #testing }
MiButterflyMapModel >> hasSettings [

	^ true
]

{ #category : #initialization }
MiButterflyMapModel >> initialize [

	super initialize.
	self initializeSettingsManager
]

{ #category : #computing }
MiButterflyMapModel >> leftEntitiesFor: anEntity [

	^ settingsManager clientsQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiButterflyMapModel >> miSelectedItem [

	^ self entities
]

{ #category : #computing }
MiButterflyMapModel >> rightEntitiesFor: anEntity [

	^ settingsManager providersQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiButterflyMapModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ browser runVisualization ]
]
