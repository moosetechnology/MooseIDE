Class {
	#name : #MiDistributionMap,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'entities',
		'childrenBlock',
		'propertyBlock'
	],
	#category : #'MooseIDE-Telescope-DistributionMap'
}

{ #category : #running }
MiDistributionMap >> childrenBlock [
	^ childrenBlock
]

{ #category : #running }
MiDistributionMap >> childrenBlock: aBlock [
	childrenBlock := aBlock
]

{ #category : #accessing }
MiDistributionMap >> entities [
	^ entities
]

{ #category : #accessing }
MiDistributionMap >> entities: anObject [
	entities := anObject
]

{ #category : #running }
MiDistributionMap >> propertyBlock [
	^ propertyBlock
]

{ #category : #running }
MiDistributionMap >> propertyBlock: aBlock [
	propertyBlock := aBlock
]

{ #category : #running }
MiDistributionMap >> run [
	super run.
	(TLDistributionMap
		containerEntities: self entities
		innerEntities: self childrenBlock
		property: self propertyBlock) openInCanvas: self canvas.
	self canvas zoomToFit
]
