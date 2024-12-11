"
I use the MiCoUsageMapBuilder like a bridge for the browser
"
Class {
	#name : #MiCoUsageMapVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'specModel',
		'mapBuilder'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #running }
MiCoUsageMapVisualization >> buildInCanvas: aCanvas [

	self specModel currentMooseModel ifNil: [ ^ self ].

	aCanvas @ RSCanvasController new noLegend.

	mapBuilder
		container: aCanvas;
		build.

	^ aCanvas
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> consume: anItem [
	anItem isTag
		ifTrue: [ self consumeTag: anItem ]
		ifFalse: [ self consumeTagAssociation: anItem ]
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> consumeTag: aTag [
	self updateLegend
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> consumeTagAssociation: aFamixTagAssociation [
	"search the box for the tagged entity with the right tag
	 - if found nothing to do
	 - else update the visualization"

	| entity tag |
	entity := aFamixTagAssociation entity.
	tag := aFamixTagAssociation tag.

	((specModel containerBoxes , specModel innerBoxes) 
		anySatisfy: [ :each | (each mooseEntity = entity) and: [ each tag = tag ] ])
		ifTrue: [ ^ self ].

	mapBuilder updateShapeColors
]

{ #category : #initialization }
MiCoUsageMapVisualization >> initialize [

	super initialize.

	mapBuilder := MiCoUsageMapBuilder new.
	mapBuilder visualization: self
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> itemsFor: aClass [
	| model |
	model := self owner containerEntities mooseModel.
	
	aClass = FamixTagAssociation ifTrue: [ ^ model allTagAssociations ].
	aClass = FamixTag ifTrue: [ ^ model allTags ].
	^ #(  )
]

{ #category : #'private - testing' }
MiCoUsageMapVisualization >> mapBuilder [
	^mapBuilder 
]

{ #category : #'as yet unclassified' }
MiCoUsageMapVisualization >> modelForShape: aShape [

	^ aShape model mooseEntity
]

{ #category : #actions }
MiCoUsageMapVisualization >> openSettings [
	"called from the visualization's globalMenu"
	specModel openSettings
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
	self tagsFromMooseModel: self specModel currentMooseModel.
	legendTag build.
	
	mapBuilder menuManager removeTag: aTag.
	canvas signalUpdate.
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> removeTagAssociation: aFamixTagAssociation [

	| entity miCoObject |
	entity := aFamixTagAssociation entity.

	miCoObject := specModel containerBoxes , specModel innerBoxes 
		detect: [ :each | each mooseEntity = entity ]
		ifNone: [ ^ self ].

	mapBuilder updateShapeColors
]

{ #category : #accessing }
MiCoUsageMapVisualization >> selectedInnerEntity [
	^specModel selectedEntity
]

{ #category : #accessing }
MiCoUsageMapVisualization >> selectedInnerEntity: aMooseEntity [
	specModel selectedEntity: aMooseEntity
]

{ #category : #accessing }
MiCoUsageMapVisualization >> selectedTag [
	^specModel selectedTag
]

{ #category : #accessing }
MiCoUsageMapVisualization >> selectedTag: aTag [
	specModel selectedTag: aTag
]

{ #category : #accessing }
MiCoUsageMapVisualization >> settings [
	^self specModel settings
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
MiCoUsageMapVisualization >> updateBoxColor: aMiCoBox fromTags: tags [

	mapBuilder updateBoxColor: aMiCoBox fromTags: tags
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
	mapBuilder updateShapeColors
]

{ #category : #update }
MiCoUsageMapVisualization >> updateShapeLayout [
	mapBuilder updateShapeLayout
]
