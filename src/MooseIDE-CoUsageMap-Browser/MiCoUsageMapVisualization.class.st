"
TODO
"
Class {
	#name : #MiCoUsageMapVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'coUsageMap'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #brokerage }
MiCoUsageMapVisualization >> consume: anItem [
	anItem class = FamixTag
		ifTrue: [ self consumeTag: anItem ]
		ifFalse: [ self consumeTagAssociation: anItem ]
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> consumeTag: aTag [
	self updateLegend
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> consumeTagAssociation: aFamixTagAssociation [
	| entity tag miCoObject |
	entity := aFamixTagAssociation entity.
	tag := aFamixTagAssociation tag.
	miCoObject := coUsageMap miMethods , coUsageMap miAttributes 
		detect: [ :each | each rawObject = entity and: [ each tag ~= tag ] ] ifNone: [ nil ].
	miCoObject ifNil: [ ^ self ].
	miCoObject tag: tag.
	coUsageMap updateShapeColors
]

{ #category : #highlighting }
MiCoUsageMapVisualization >> highlightShapes [
	^ #()
]

{ #category : #initialization }
MiCoUsageMapVisualization >> initialize [

	super initialize.
	self script: [ :canvas | canvas ]
]

{ #category : #initialization }
MiCoUsageMapVisualization >> itemsFor: aClass [
	
	aClass = FamixTag
		ifTrue: [ { "a group o tags" } ]
		ifFalse: [ { "a group o assoiations" } ].
]

{ #category : #initialization }
MiCoUsageMapVisualization >> itemsFor: aClass key: key [
	^ self perform: key with: aClass
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> remove: anObject [
	anObject class = FamixTag
		ifTrue: [ self removeTag: anObject ]
		ifFalse: [ self removeTagAssociation: anObject ].
	
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> removeTag: aTag [
	| canvas legendTag |
	canvas := coUsageMap canvas.
	legendTag := coUsageMap legendTag.
	
	"updating legend"
	legendTag tagsFromMooseModel: self owner classModel mooseModel.
	legendTag build.
	
	coUsageMap markManager removeTag: aTag.
	canvas signalUpdate.
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> removeTagAssociation: aFamixTagAssociation [
	| entity miCoObject |
	entity := aFamixTagAssociation entity.
	miCoObject := coUsageMap miMethods , coUsageMap miAttributes 
		detect: [ :each | each rawObject = entity ] ifNone: [ nil ].
	miCoObject ifNil: [ ^ self ].
	"this avoids call the consumer producer system"
	miCoObject privateTag: nil.
	coUsageMap updateShapeColors
]

{ #category : #running }
MiCoUsageMapVisualization >> run [
	| model |
	super run.
	model := self owner classModel.
	coUsageMap := MiCoUsageMapMooseBuilder new
		container: self canvas;
		attributes: model attributes;
		methods: model methods;
		application: self owner application.
	self updateLegend.
	coUsageMap build.
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> updateLegend [
	| legendTag |
	legendTag := coUsageMap legendTag.
	legendTag tagsFromMooseModel: self owner classModel mooseModel.
	legendTag build.
	coUsageMap updateShapeColors.
]
