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
	| entity tag miCoObject |
	entity := aFamixTagAssociation entity.
	tag := aFamixTagAssociation tag.
	miCoObject := specModel containerBoxes , specModel innerBoxes 
		detect: [ :each | each mooseEntity = entity and: [ each tag ~= tag ] ] ifNone: [ nil ].
	miCoObject ifNil: [ ^ self ].
	self flag: 'tag-association already set, but need to show it in the map'.
	self specModel tagEntity: miCoObject mooseEntity with: tag.
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
	model := self owner containerEntities mooseModel.
	
	aClass = FamixTagAssociation ifTrue: [ ^ model allTagAssociations ].
	aClass = FamixTag ifTrue: [ ^ model allTags ].
	^ #(  )
]

{ #category : #'private - testing' }
MiCoUsageMapVisualization >> mapBuilder [
	^mapBuilder 
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
	miCoObject := mapBuilder containerBoxes , mapBuilder innerBoxes 
		detect: [ :each | each mooseEntity = entity ] ifNone: [ nil ].
	miCoObject ifNil: [ ^ self ].
	"this avoids call the consumer producer system"
	miCoObject privateTag: nil.
	mapBuilder updateShapeColors
]

{ #category : #running }
MiCoUsageMapVisualization >> run [
	| mooseModel |
	super run.
	mooseModel := self specModel currentMooseModel.
	mooseModel ifNil: [ ^self ].
	mapBuilder 
		container: self canvas;
		build.
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
