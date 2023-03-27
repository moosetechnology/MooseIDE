"
I use the MiCoUsageMapBuilder like a bridge for the browser
"
Class {
	#name : #MiCoUsageMapVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'specModel',
		'settings',
		'mapBuilder'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #'private - for tests' }
MiCoUsageMapVisualization >> closeSettingsBrowser [
	settings close
]

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
	miCoObject := mapBuilder miMethods , mapBuilder miAttributes 
		detect: [ :each | each rawObject = entity and: [ each tag ~= tag ] ] ifNone: [ nil ].
	miCoObject ifNil: [ ^ self ].
	miCoObject tag: tag.
	mapBuilder updateShapeColors
]

{ #category : #highlighting }
MiCoUsageMapVisualization >> highlightShapes [
	^ #()
]

{ #category : #initialization }
MiCoUsageMapVisualization >> initialize [
	super initialize.
	self script: [ :canvas | canvas ].

	mapBuilder := MiCoUsageMapBuilder new.
	mapBuilder visualization: self.
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> itemsFor: aClass [
	| model |
	model := self owner collectionModel mooseModel.
	
	aClass = FamixTagAssociation ifTrue: [ ^ model allTagAssociations ].
	aClass = FamixTag ifTrue: [ ^ model allTags ].
	^ #(  )
]

{ #category : #actions }
MiCoUsageMapVisualization >> openSettingsBrowser [
	settings := mapBuilder openSettingsBrowser
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
	canvas := mapBuilder canvas.
	legendTag := mapBuilder legendTagBuilder.
	
	"updating legend"
	self tagsFromMooseModel: self owner collectionModel mooseModel.
	legendTag build.
	
	mapBuilder markManager removeTag: aTag.
	canvas signalUpdate.
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> removeTagAssociation: aFamixTagAssociation [
	| entity miCoObject |
	entity := aFamixTagAssociation entity.
	miCoObject := mapBuilder miMethods , mapBuilder miAttributes 
		detect: [ :each | each rawObject = entity ] ifNone: [ nil ].
	miCoObject ifNil: [ ^ self ].
	"this avoids call the consumer producer system"
	miCoObject privateTag: nil.
	mapBuilder updateShapeColors
]

{ #category : #running }
MiCoUsageMapVisualization >> run [
	| model |
	super run.
	model := self owner collectionModel.
	mapBuilder 
		container: self canvas;
		methods: model;
		settings: self settings;
		application: self owner application.
	self updateLegend.
	mapBuilder build.
]

{ #category : #accessing }
MiCoUsageMapVisualization >> settings [
	^ settings
]

{ #category : #accessing }
MiCoUsageMapVisualization >> settings: anObject [
	settings := anObject
]

{ #category : #accessing }
MiCoUsageMapVisualization >> specModel [

	^specModel
]

{ #category : #accessing }
MiCoUsageMapVisualization >> specModel: anObject [

	specModel := anObject
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> tagsFromMooseModel: aMooseModel [
	| group legendTag |
	aMooseModel ifNil: [ ^ self ]. 
	legendTag := mapBuilder legendTagBuilder.
	legendTag removeOldLegend.
	group := aMooseModel allTags sorted: [ :a :b | a name < b name ].
	group do: [ :tag | legendTag addTag: tag asMiCoTag ].
]

{ #category : #update }
MiCoUsageMapVisualization >> threshold75: aNumber [
	mapBuilder threshold75: aNumber
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> update: anObject [
	self consume: anObject
]

{ #category : #update }
MiCoUsageMapVisualization >> updateChildren [
	mapBuilder updateChildren
]

{ #category : #update }
MiCoUsageMapVisualization >> updateInnerBoxSize [
	mapBuilder updateInnerBoxSize
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> updateLegend [
	| legendTag |
	legendTag := mapBuilder legendTagBuilder.
	legendTag removeOldLegend.
	legendTag build.
	mapBuilder updateShapeColors.
]

{ #category : #update }
MiCoUsageMapVisualization >> updateShapeLayout [
	mapBuilder updateShapeLayout
]
