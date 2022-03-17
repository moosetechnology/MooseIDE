"
I use the MiCoUsageMapMooseBuilder like a bridge for the for the browser
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
	self identityHash traceCr.
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
	self script: [ :canvas | canvas ].
	coUsageMap := MiCoUsageMapMooseBuilder new.
	coUsageMap visualization: self.
]

{ #category : #actions }
MiCoUsageMapVisualization >> openSettingsBrowser [
	^ coUsageMap markManager openSettingsBrowser
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
	self tagsFromMooseModel: self owner collectionModel mooseModel.
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
	model := self owner collectionModel.
	coUsageMap 
		container: self canvas;
		methods: model;
		application: self owner application.
	self updateLegend.
	coUsageMap build.
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> tagNeedWorkFrom: aMooseModel [
	| name cls |
	cls := MiCoUsageMapSettings.
	name := cls tagNeedWorkName.
	
	^ [ aMooseModel findTagNamed: name ]
		on: NotFound
		do: [ | newTag |
			newTag := (aMooseModel createTagNamed: name)
				color: cls tagNeedWorkColor;
				yourself.
			self owner application consumeItem: newTag from: self.
			newTag ]
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> tagsFromMooseModel: aMooseModel [
	| ctag group legendTag |
	aMooseModel ifNil: [ ^ self ]. 
	legendTag := coUsageMap legendTag.
	legendTag removeOldLegend.
	ctag := self tagNeedWorkFrom: aMooseModel.
	group := aMooseModel allTags sorted: [ :a :b | a name < b name ].
	legendTag conflictTag: ctag asMiCoTag.
	group 
		reject: [ :tag | tag = ctag ] 
		thenDo: [ :tag | legendTag addTag: tag asMiCoTag ].
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> update: anObject [
	self consume: anObject
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> updateLegend [
	| legendTag |
	legendTag := coUsageMap legendTag.
	self tagsFromMooseModel: self owner collectionModel mooseModel.
	legendTag build.
	coUsageMap updateShapeColors.
]
